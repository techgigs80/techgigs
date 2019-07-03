Install mosquitto on Raspbery Pi3
=================================


## Install through repository
```bash
wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key
sudo apt-key add mosquitto-repo.gpg.key

cd /etc/apt/sources.list.d/
sudo wget http://repo.mosquitto.org/debian/mosquitto-jessie.list

sudo apt-get update
sudo apt-get install mosquitto
```


## Configure for the convenice
+ basic
    ```bash
    sudo vi /etc/mosquitto/mosquitto.conf
    ```
  > pid_file /var/run/mosquitto.pid
  > <br/>persistence true
  > <br/>persistence_location /var/lib/mosquitto/
  > <br/>log_dest syslog
  > <br/>log_facility 5
  > <br/>log_timestamp false
  > <br/>autosave_interval 1800
  > <br/>include_dir /etc/mosquitto/conf.d
  > <br/>allow_anonymous false


+ security
```bash
# by root
touch /etc/mosquitto/passwd
sudo mosquitto_passwd /etc/mosquitto/passwd admin
```
