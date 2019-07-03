## Linux Group Admin
+ folder permission
```bash
sudo chmod 755 (folder)
```

+ add new group for deep-learners
+ add new user to existing group
```bash
groupadd -g 1001 deep-learners
useradd -g 1001 -u 1001 roki -d /light_data/roki -s /bin/bash
mkdir -p /light_data/roki
cp /etc/skel/.bashrc /light_data/roki
cp /etc/skel/.profile /light_data/roki/.bash_profile
usermod -G deep-learners roki
```


+ add privilegs to specific group
```bash
sudo visudo

# add below line
%deep-learners ALL=/usr/bin/pip
```