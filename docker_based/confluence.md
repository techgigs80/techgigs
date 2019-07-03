# Install confluence through docker

## Install mariadb container (without data storage)

+ Install docker container for mariadb

```bash
docker search mariadb
docker pull mariadb

docker run --name mariadb -p 3306:3306 -v /data/mariadb/sock:/var/run/mysqld -v /data/mariadb/log:/var/log/mysql -v /data/mariadb/conf:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD='q1w2e3r4!' -d mariadb

# in docker container
mkdir -p /var/log/mysql/mariadb-bin
chown -R mysql. /var/log/mysql
chown -R mysql. /var/run/mysqld
chmod -R 775 /etc/mysql

# in host
sudo cp /data/std_mysql_docker.cnf /data/mariadb/conf

# in docker container
chown -R mysql. /etc/mysql
rm -rf /var/lib/mysql/*
mysql_install_db --user=mysql --defaults-file=/etc/mysql/conf.d/std_mysql_docker.cnf
```

## Install mariadb container (with handling stored data)

+ Install docker container for mariadb

```bash
docker search mariadb
docker pull mariadb

docker run --name mariadb -p 3306:3306 -v /data/mariadb/sock:/var/run/mysqld -v /data/mariadb:/data  -v /data/mariadb/conf:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD='q1w2e3r4!' -d mariadb

# in docker container
mkdir -p /data/{tables,plugins,dumps,logs,log-bin}
chmod -R 775 /data

# in host
sudo cp std_mysql.cnf /data/mariadb/conf

# in docker container
chown -R mysql. /data
mysql_install_db --user=mysql --defaults-file=/etc/mysql/conf.d/std_mysql.cnf
```

+ Install necessary packages for the convenience

```bash
docker exec -it $(your docker name) bash
sudo apt-get update --fix-missing
sudo apt-get install vim

# add the following line in ~/.bashrc

if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Some more alias to avoid making mistakes:
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim -v'
set -o vi
```

## Configure mariadb

+ Set up the root account

```bash
# in docker container
mysqladmin -uroot password      # reset root password

mysql -uroot -p

mysql> create user 'root'@'192.168.42.%' identified by 'Posco1ct!';
mysql> grant all on *.* to 'root'@'192.168.42.%' identified by 'Posco1ct!' WITH GRANT OPTION;
mysql> flush privileges;
```

## Install the confluence container

+ Install docker container for confluence

```bash
docker pull cptactionhank/atlassian-confluence:latest
docker rm --volumes --force "confluence-container"
docker create --restart=no --name "confluence-container" \
  --publish "8090:8090" \
  --link mariadb:mariadb\
  --volume "/data/confluence:/var/atlassian/confluence" \
  --env "CATALINA_OPTS= -Xmx1G" \
  kkh/conflu-jdk8
docker start --attach "confluence-container"

# in docker container
docker exec -it --user root confluence-container bash
chown -R 2:2 /var/atlassian/confluence
(restart container)
```

+ check bundled tomcat version

```bash
# in confluence container
java -cp lib/catalina.jar org.apache.catalina.util.ServerInfo
```

+ Create confluence database

```bash
# connect to the mariadb
mysql --socket=/data/mariadb/sock/mysqld.sock -uroot -p

mysql> create database confluence CHARACTER SET utf8 COLLATE utf8_bin;
mysql> create user 'confluence'@'172.17.0.%' identified by 'Posco1ct!';
mysql> grant all on confluence.* to 'confluence'@'172.17.0.%' identified by 'Posco1ct!';
mysql> flush privileges;
```

+ Congfiure JNDI data source for confluece

```bash
# in confluence container
docker exec -it --user root confluence-container bash
cp /var/atlassian/confluence/mariadb-java-client-1.1.9.jar /opt/atlassian/confluence/confluence/WEB-INF/lib

vi /opt/atlassian/confluence/conf/server.xml
# Insert the following DataSource  Resource  element for your specific database directly after the lines above (inside the  Context  element, directly after the opening  <Context.../>  line,  before  Manager).

# templete
<Resource name="jdbc/confluence" auth="Container" type="javax.sql.DataSource"
  username="<database-user>"
  password="<password>"
  driverClassName="org.mariadb.jdbc.Driver"
  url="jdbc:mariadb://<host>:3306/<database-name>?useUnicode=true&amp;characterEncoding=utf8"
  maxTotal="60"
  maxIdle="20"
  defaultTransactionIsolation="READ_COMMITTED"
  validationQuery="Select 1"/>

# for our own
<Resource name="jdbc/confluence" auth="Container" type="javax.sql.DataSource"
  username="confluence"
  password="Posco1ct!"
  driverClassName="org.mariadb.jdbc.Driver"
  url="jdbc:mariadb://mariadb:3306/confluence?useUnicode=true&amp;characterEncoding=utf8"
  maxTotal="60"
  maxIdle="20"
  defaultTransactionIsolation="READ_COMMITTED"
  validationQuery="Select 1"/>

vi /opt/atlassian/confluence/confluence/WEB-INF/web.xml
# Insert the following element between <web-app> and </web-app>
<resource-ref>
  <description>Connection Pool</description>
  <res-ref-name>jdbc/confluence</res-ref-name>
  <res-type>javax.sql.DataSource</res-type>
  <res-auth>Container</res-auth>
</resource-ref>
```

+ when install jndi name is **java:comp/env/jdbc/confluence**

## Configure the confluence server

+ the things needs to do in general configuration
  + attachment settings : 100MB -> 1GB
  + Timeout : 10000 ms -> 60000 ms
  + update default add-ons
  + (at least should be in mariadb configuration)
    + max_connections=500
    + transaction_isolation=READ-COMMITTED
    + innodb_buffer_pool_size=1G
    + innodb_log_file_size=512M
    + max_allowed_packet=512M