#!/bin/bash
export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=892970

start() {
    echo "Starting Valheim server..."

    cd $VALHEIM_SERVER

    ./valheim_server.x86_64 -name $SERVER_NAME \
    -port $VALHEIM_PORT \
    -world $WORLD_NAME \
    -password $PASSWORD \
    -savedir $VALHEIM_DATA &
    VALHEIM_PID=$!

    export LD_LIBRARY_PATH=$templdpath


    echo "Valheim server has successfully started, PRESS CTRL-C to exit"
    echo "Valheim server PID is: $VALHEIM_PID"
    echo "Valheim Server name: $SERVER_NAME"
    echo "Valheim World name: $WORLD_NAME"
    echo "Valheim is running on port: $VALHEIM_PORT"

    wait $VALHEIM_PID
}

shutdown() {
    echo "Valheim Server is shutting down..."
    kill -2 $1
    wait $1
    exit 0
}

trap shutdown SIGINT SIGTERM
start
