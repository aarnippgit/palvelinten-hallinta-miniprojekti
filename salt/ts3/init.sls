install_ufw:                        # Asentaa ufw:n
  pkg.installed:
    - name: ufw

enable_ufw:                         # Aktivoi ufw:n, avaa portit SSH:ta ja masteria varten sekä uudelleenkäynnistää sen
  cmd.run:
    - name: ufw --force enable && ufw allow 22/tcp && ufw allow 4505/tcp && ufw allow 4506/tcp && ufw reload
    - unless: 'ufw status | grep -q "Status: active"'
    - require:
      - pkg: install_ufw

install_lbzip2:                     # Asentaa lbzip2
  pkg.installed:
    - name: lbzip2  

create_server_user:                 # Luo käyttäjän teamspeak
  user.present:
    - name: teamspeak
    - home: /home/teamspeak
    - password: "!"                 # Salasanakirjautuminen estetty, käyttäjälle pääsy "sudo su - teamspeak"

download_ts3_server:                # Lataa TeamSpeak 3 palvelintiedostot 
  file.managed:
    - name: /home/teamspeak/teamspeak3-server_linux_amd64-3.13.7.tar.bz2
    - source: https://files.teamspeak-services.com/releases/server/3.13.7/teamspeak3-server_linux_amd64-3.13.7.tar.bz2
    - source_hash: 775a5731a9809801e4c8f9066cd9bc562a1b368553139c1249f2a0740d50041e
    - require:
      - pkg: install_lbzip2         # Edellytetään lbzip2 asennus sekä käyttäjän ja kotihakemiston olemassaolo
      - user: create_server_user

extract_files:                      # Purkaa ladatun tar-tiedoston
  cmd.run:
    - name: tar -xf /home/teamspeak/teamspeak3-server_linux_amd64-3.13.7.tar.bz2 -C /home/teamspeak --strip-components=1 # Siirtyy käyttäjän kotihakemistoon ja purkaa tiedostot suoraan sinne
    - cwd: /home/teamspeak
    - creates: /home/teamspeak/ts3server_minimal_runscript.sh
    - require: 
      - file: download_ts3_server

accept_license:                     # Luo tyhjän tiedoston jolla lisenssi hyväksytään
  file.managed:
    - name: /home/teamspeak/.ts3server_license_accepted
