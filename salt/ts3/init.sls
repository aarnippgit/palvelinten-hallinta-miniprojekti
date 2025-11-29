install_lbzip2:
  pkg.installed:
    - name: lbzip2  

create_server_user:
  user.present:
    - name: teamspeak
    - home: /home/teamspeak
    - password: "!"                 # Salasanakirjautuminen estetty, käyttäjälle pääsy "sudo su - teamspeak"

download_ts3_server:
  file.managed:
    - name: /home/teamspeak/teamspeak3-server_linux_amd64-3.13.7.tar.bz2
    - source: https://files.teamspeak-services.com/releases/server/3.13.7/teamspeak3-server_linux_amd64-3.13.7.tar.bz2
    - source_hash: 775a5731a9809801e4c8f9066cd9bc562a1b368553139c1249f2a0740d50041e
    - require:
      - pkg: install_lbzip2               # Edellytetään lbzip2 asennus sekä käyttäjän ja kotihakemiston olemassaolo
      - user: create_server_user

extract_files:
  cmd.run:
    - name: tar -xf /home/teamspeak/teamspeak3-server_linux_amd64-3.13.7.tar.bz2 -C /home/teamspeak --strip-components=1 # Siirtyy käyttäjän kotihakemistoon, extractaa tiedostot poistaen ne sisältäneen kansion
    - cwd: /home/teamspeak
    - creates: /home/teamspeak/ts3server_minimal_runscript.sh
    - require: 
      - file: download_ts3_server
