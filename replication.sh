#!/bin/bash

## start containers

docker-compose up -d

##### wait until mysql container ready
until docker exec mysql-master sh -c 'mysql -uroot -proot -e ";"'
do
    echo "Waiting for mysql-master database connection..."
    sleep 4
done

until docker exec mysql-master sh -c 'mysql -uroot -proot -e ";"'
do
    echo "Waiting for mysql-slave database connection..."
    sleep 4
done


################### Master Start ###################

# User already created in docker-compose,
# provide required permission for replication user

grant_per="GRANT REPLICATION SLAVE ON *.* TO 'vishal'@'%' IDENTIFIED BY 'vishal@123'; FLUSH PRIVILEGES;"

docker exec mysql-master /bin/bash -c "mysql -uroot -proot -e \"$grant_per\""

# Retrieve the master status
master_status=$(docker exec mysql-master mysql -uroot -proot -e "SHOW MASTER STATUS\G")

# Extract the master log file and position from the status output
master_log_file=$(echo "$master_status" | grep "File:" | awk '{print $2}')
master_log_pos=$(echo "$master_status" | grep "Position:" | awk '{print $2}')

################### Master End ###################

################### Slave Start ###################

# Connect to the MySQL slave and configure the replication settings

connect="CHANGE MASTER TO MASTER_HOST='mysql-master', MASTER_USER='vishal', MASTER_PASSWORD='vishal@123', MASTER_LOG_FILE='$master_log_file', MASTER_LOG_POS=$master_log_pos;"

docker exec mysql-slave /bin/bash -c "mysql -uroot -proot -e \"$connect\""

# Start the slave

docker exec mysql-slave /bin/bash -c "mysql -uroot -proot -e 'START SLAVE;'"

# Check the slave status

docker exec mysql-slave /bin/bash -c "mysql -uroot -proot -e 'SHOW SLAVE STATUS \G;'"
