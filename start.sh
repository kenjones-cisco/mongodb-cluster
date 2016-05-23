#!/bin/bash

MONGO_LOG="/var/log/mongodb/mongod.log"
MONGO="/usr/bin/mongo"
MONGOD="/usr/bin/mongod"
$MONGOD --fork --storageEngine wiredTiger --replSet "${DB_REPLICA_SET}" --smallfiles --logpath $MONGO_LOG

checkStatus() {
    echo "checking our status..."
    $MONGO --eval db

    while [ "$?" -ne 0 ]
    do
        echo "Waiting for mongod to become ready..."
        sleep 5
        $MONGO --eval db
    done
}

# waiting for the mongod process to finish starting
checkStatus

checkNodeStatus() {
    local NODE=$1
    $MONGO --host "${NODE}" --eval db

    while [ "$?" -ne 0 ]
    do
        echo "Waiting for replica node (${NODE}) to come up..."
        sleep 5
        $MONGO --host "${NODE}" --eval db
    done
}

if [ "${DB_NODE_ROLE}" == "primary" ]
then
    $MONGO --eval "rs.initiate()"

    checkNodeStatus "${REPLICA1}"
    $MONGO --eval "rs.add(\"${REPLICA1}:27017\")"

    checkNodeStatus "${REPLICA2}"
    $MONGO --eval "rs.add(\"${REPLICA2}:27017\")"
fi

tailf "${MONGO_LOG}"
