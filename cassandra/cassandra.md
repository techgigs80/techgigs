Install the datastax cassandra community version
================================================


## Download the source from the [site](https://academy.datastax.com/planet-cassandra/cassandra)
1. Download through the wget
    ```bash
    wget http://downloads.datastax.com/datastax-ddc/datastax-ddc-3.9.0-bin.tar.gz
    ```


2. Unarchive the tar and prepare folders
    ```bash
    tar -xvzf datastax-ddc-3.9.0-bin.tar.gz
    mv datastax-ddc-3.9.0/ cassandra39
    mkdir -p {DATA,commitlog,saved_caches,hints,tmp}
    ```


3. Upload the necessary files to each server
    > **PLASFLCA1**<br/>
    > _cassandra-env.sh_node01_ to /CSDR/POSF/cassandra39/conf/cassandra-env.sh<br/>
    > _cassandra.yaml_node01_ to /CSDR/POSF/cassandra39/conf/cassandra.yaml<br/>
    > _start.sh_ to /CSDR/POSF/start.sh<br/>
    > _stop.sh_ to /CSDR/POSF/stop.sh<br/>
    > **PLASFLCA2**<br/>
    > _cassandra-env.sh_node02_ to /CSDR/POSF/cassandra39/conf/cassandra-env.sh<br/>
    > _cassandra.yaml_node02_ to /CSDR/POSF/cassandra39/conf/cassandra.yaml<br/>
    > _start.sh_ to /CSDR/POSF/start.sh<br/>
    > _stop.sh_ to /CSDR/POSF/stop.sh<br/>
    > **PLASFLCA3**<br/>
    > _cassandra-env.sh_node03_ to /CSDR/POSF/cassandra39/conf/cassandra-env.sh<br/>
    > _cassandra.yaml_node03_ to /CSDR/POSF/cassandra39/conf/cassandra.yaml<br/>
    > _start.sh_ to /CSDR/POSF/start.sh<br/>
    > _stop.sh_ to /CSDR/POSF/stop.sh<br/>


4. Start up the cluster
    ```bash
    (on each node)
    ~/start.sh

    (for check)
    nodetool status

    Datacenter: dc1
    ===============
    Status=Up/Down
    |/ State=Normal/Leaving/Joining/Moving
    --  Address        Load       Tokens       Owns (effective)  Host ID                               Rack
    UN  10.230.21.212  220.79 KiB  256          67.2%             84d0c649-1091-43c6-a184-a1a28255b177  rack1
    UN  10.230.21.116  120.16 KiB  256          65.7%             96a99370-0782-41f7-9d4c-859aa9a2ce8a  rack1
    UN  10.230.21.250   95.85 KiB  256          67.0%             738d2d43-7333-4c95-b759-54504f466394  rack1
    ```


5. Configure the basic and authentication
    ```bash
    sed -i '103s/AllowAllAuthenticator/PasswordAuthenticator/g' /CSDR/POSF/cassandra39/conf/cassandra.yaml
    (cassandra restart)
    cqlsh localhost 9042 -u cassandra -p cassandra
    cqlsh> ALTER KEYSPACE "system_auth" WITH REPLICATION = {'class' : 'SimpleStrategy', 'replication_factor' : 3};
    cqlsh> CREATE ROLE csadmin WITH PASSWORD = 'change!23' AND SUPERUSER = true AND LOGIN = true;    # change it later
    cqlsh> CREATE ROLE kairos WITH PASSWORD = 'q1w2e3r4!' AND SUPERUSER = true AND LOGIN = true;
    cqlsh> quit

    nodetool repair system_auth
    (cassandra restart)

    cqlsh localhost 9042 -u csadmin -p 'change!23'
    cqlsh> ALTER ROLE cassandra WITH PASSWORD = 'Vt2*Pw3*Hz7^Rg8&Ok5$Ux2!Ha5)Am3^' AND SUPERUSER=false;
    cqlsh> quit

    nodetool repair system_auth
    ```


6. Install the kairosdb
+ Download the package from site
    ```bash
    cd ~
    wget https://github.com/kairosdb/kairosdb/releases/download/v1.1.3/kairosdb-1.1.3-1.tar.gz
    tar -xvzf kairosdb-1.1.3-1.tar.gz
    ```
+ Configure the backend dbms
    ```bash
    vi /data/kairosdb/conf/kairosdb.properties
    #kairosdb.service.datastore=org.kairosdb.datastore.h2.H2Module				# comment
    kairosdb.service.datastore=org.kairosdb.datastore.cassandra.CassandraModule
    kairosdb.datastore.cassandra.host_list=10.230.21.116:9160,10.230.21.212:9160,10.230.21.250:9160
    kairosdb.datastore.cassandra.auth.username=kairos
    kairosdb.datastore.cassandra.auth.password=q1w2e3r4!
    ```
+ Start the kairosdb
    ```bash
    # updload start_kairosdb.sh and stop_kairosdb.sh to home directory
    start_kairosdb.sh     # for start the kairosdb
    stop_kairosdb.sh     # for stop the kairosdb
    ```


7. Configure the Authorization
    ```bash
    sed -i '112s/AllowAllAuthorizer/CassandraAuthorizer/g' ~/cassandra39/conf/cassandra.yaml
    (cassandra restart)
    cqlsh localhost 9042 -u csadmin -p 'change!23'
    cqlsh> ALTER ROLE kairos WITH SUPERUSER=false;
    cqlsh> grant all on all keyspaces to csadmin;
    cqlsh> grant all on keyspace kairosdb to kairos;
    cqlsh> quit

    nodetool repair
    ```


8. Verify the kariosdb and cassandra
    ```bash
    # for kairosdb
    check the port 4242(tcp), 8080(web)
    # for cassandra
    check the port 9042(cqlsh), 9160(thrift)
    ```
