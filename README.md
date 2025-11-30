# TeamSpeak 3 palvelinasennus Linuxille Saltin avulla:
## Aarni Pemberton ja Miro Johansson  

Masterilla:
```
$ git clone https://github.com/aarnippgit/palvelinten-hallinta-miniprojekti.git
$ sudo mkdir -p /srv/salt/
$ sudo cp -r palvelinten-hallinta-miniprojekti/salt/. /srv/salt/
$ sudo salt *minion* state.apply
```

Minionilla:
```
$ sudo cat /root/ts3_credentials.txt
```
Ota talteen ServerAdmin Password ja Privilege Token

Avaa TeamSpeak 3 Client -> Connections -> Server Nickname or Address: *IP-osoite* -> Connect -> Anna Admin Token

Lopputulos:  
<img width="444" height="51" alt="image" src="https://github.com/user-attachments/assets/8407c7b3-2fd3-4653-9a67-5b1ba732719c" />
