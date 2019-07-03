creates node-red docker image
=============================


## Make base image
+ Pull the base image form dockerhub
```bash
docker search centos:latest
docker pull centos:latest
docker inspect centos       # check RepoTags : "centos:latest"
```

+ Make container for node-red
```bash
docker run -it --name=nodered centos
yum check-update
```


+ Install the nodejs
```bash
yum install -y gcc-c++ make sudo vim
# for convenience
echo "alias vi='vim -v'" >> ~/.bashrc
echo "alias ll='ls -alF'" >> ~/.bashrc
echo "set -o vi" >> ~/.bashrc
source ~/.bashrc
# for sudoers
echo -e 'icadmin\tALL=(ALL)\tALL' >> /etc/sudoers
echo -e 'icadmin\tALL=(ALL)\tNOPASSWD: ALL' >> /etc/sudoers

useradd icadmin && echo 'icadmin:q1w2e3r4!' | chpasswd
su - icadmin
echo "alias vi='vim -v'" >> ~/.bashrc
echo "alias ll='ls -alF'" >> ~/.bashrc
echo "set -o vi" >> ~/.bashrc
source ~/.bashrc
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -
sudo yum install -y nodejs
```

sudo npm cache clean
sudo npm install -g --unsafe-perm node-red

sudo npm install -g --unsafe-perm --build-from-source johnny-five --force
sudo npm install -g --unsafe-perm --build-from-source raspi-io --force
sudo npm install -g --unsafe-perm --build-from-source node-red-contrib-gpio --force
sudo npm install -g --unsafe-perm --build-from-source node-red-contrib-modbus
sudo npm install -g --unsafe-perm --build-from-source node-red-contrib-binary
sudo npm install -g --unsafe-perm --build-from-source node-red-contrib-join
sudo npm install -g --unsafe-perm node-red-contrib-serial-modbus
sudo npm install -g --unsafe-perm node-red-node-mysql
sudo npm install -g --unsafe-perm node-red-dashboard
sudo npm install -g --unsafe-perm modbus-rest
sudo npm install -g node-red-contrib-merge
sudo npm install -g node-red-contrib-cron
sudo npm install -g pm2
npm install node-red-admin

+
```bash
```
