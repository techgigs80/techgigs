Build Private Git and Gitolite server
========================


## Install the git and gitolite on CentOS 7
+ Create git user
  + Prepare fresh centos 7 server
  + add new git user
  ```bash
  sudo adduser \
      --system \
      --shell /bin/bash \
      --gecos 'git version control' \
      --group \
      --disabled-password \
      --home /git \
      git
  ```
+ Install dependencies and git-core
    ```bash
    yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
    yum install git-core
    ```
+ Install the gitolite for managing git account
    ```bash
    su - git
    git clone git://github.com/sitaramc/gitolite
    mkdir ${HOME}/bin
    yum install perl-DBD-MySQL -y
    gitolite/install -ln
    ```
+ Add the admin rsa key to gitolite
    ```bash
    (on admin computer)
    ssh-keygen -t rsa -b 4096 -C "kyungho.ku@poscoict.com"
    (put name on 'Git-Admin')
    (cp Git-Admin.pub to your 'Git-Admin.pub')

    (on git server)
    su - git
    ${HOME}/bin/gitolite setup -pk Git-Admin.pub
    ```


## Congifure the account for git through gitolite
+  Cloning gitolite configuration
```bash
(on Git-Admin server)
git clone git@git.poscoict.com:gitolite-admin.git
```
