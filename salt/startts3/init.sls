ts3_service_file: #Luo systemd servicen ts3:lle
  file.managed:
    - name: /lib/systemd/system/ts3server.service
    - user: root
    - group: root
    - mode: 644
    - contents: |
        [Unit]
        Description=Teamspeak Service
        Wants=network.target

        [Service]
        WorkingDirectory=/home/teamspeak
        User=teamspeak
        ExecStart=/home/teamspeak/ts3server_minimal_runscript.sh
        ExecStop=/home/teamspeak/ts3server_startscript.sh stop
        ExecReload=/home/teamspeak/ts3server_startscript.sh restart
        Restart=always
        RestartSec=15

        [Install]
        WantedBy=multi-user.target

ts3_service_running: #Käynnistää ts3 serverin
  service.running:
    - name: ts3server
    - enable: True
    - require:
      - file: ts3_service_file

ufw_open_ts3_ports: #Avaa tarvittavat portit ts3 serverille
  cmd.run:
    - name: |
        ufw allow 9987/udp
        ufw allow 30033/tcp
        ufw allow 10011/tcp
        ufw allow 41144/tcp
    - unless: ufw status | grep "9987/udp"

wait_for_ts3_service:
  cmd.run:
    - name: sleep 6
    - require:
      - service: ts3_service_running

extract_ts3_credentials_journal:
  cmd.run:
    - name: |
        echo "==== TeamSpeak Credentials ====" > /root/ts3_credentials.txt
        echo "" >> /root/ts3_credentials.txt

        echo "ServerAdmin Password:" >> /root/ts3_credentials.txt
        journalctl -u ts3server -n 200 | grep -oP '(?<=password=)[A-Za-z0-9]+' >> /root/ts3_credentials.txt

        echo "" >> /root/ts3_credentials.txt
        echo "Privilege Token:" >> /root/ts3_credentials.txt
        journalctl -u ts3server -n 200 | grep -oP '(?<=token=)[A-Za-z0-9+/=]+' >> /root/ts3_credentials.txt

        echo "" >> /root/ts3_credentials.txt
        echo "Saved to: /root/ts3_credentials.txt"
    - require:
      - cmd: wait_for_ts3_service
    - unless: test -f /root/ts3_credentials.txt
