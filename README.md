# docker-mysql-master-slave-replication

Replication Demo

This repo demonstrates how to set up replication between two Docker containers.
Requirements

    Docker
    Docker Compose

Instructions

    Clone this repo.

    Run >     bash replication.sh

Verification

Once the replication is set up, you can verify it by adding a new entry to the master database. The slave database should be updated with the new entry shortly after.
Cleanup

To stop the containers, run docker-compose down.

Author

Vishalk17
