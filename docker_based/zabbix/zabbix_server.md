docker run --name rnd_zabbix_srv \
            --link mariadb:mariadb \
            -e DB_SERVER_HOST="mariadb" \
            -e MYSQL_DATABASE="zabbix" \
            -e MYSQL_USER="zabbix" \
            -e MYSQL_PASSWORD="q1w2e3r4!" \
            -d zabbix/zabbix-server-mysql:ubuntu-4.0-latest


sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
