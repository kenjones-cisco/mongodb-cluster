## Run MongoDB Cluster using Docker

Based on article [MongoDB Replica set using Docker Networking and Docker Compose](http://www.tothenew.com/blog/mongodb-replica-set-using-docker-networking-and-docker-compose/).

    # optionally build first
    docker-compose build

    # start up the cluster
    docker-compose up -d

A few changes that will differ from the article:

- Uses official Mongo image as base file and simply adds the start.sh file.
- start.sh script will check to see if the mongod instance running in this container is ready instead of just sleeping for 30 seconds.
- Runs as user `mongodb` instead of `root`.
- Uses actual log file instead of tailing `/dev/null`.
- Converted to version 2 of docker-compose file.
- Made the replSet configurable via environment variable.
- Switched naming to follow Mongo's use of primary/secondary.
