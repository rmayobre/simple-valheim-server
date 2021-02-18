#!/bin/bash
export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=892970

start() {
    echo "Starting Valheim server..."

    cd $SERVER_DIR

    # Start valheim server executable with provided arguments.
    # This will use environment variables defined in the docker image.
    ./valheim_server.x86_64 \
    -name $SERVER_NAME \
    -port $SERVER_PORT \
    -world $WORLD_NAME \
    -password $PASSWORD \
    -savedir $WORLD_DATA_DIR &
    VALHEIM_PID=$!

    export LD_LIBRARY_PATH=$templdpath


    echo "Valheim server has successfully started, PRESS CTRL-C to exit"
    echo "Valheim server PID is: $VALHEIM_PID"
    echo "Valheim Server name: $SERVER_NAME"
    echo "Valheim World name: $WORLD_NAME"
    echo "Valheim is running on port: $SERVER_PORT"

    # Keep script running by waiting for Valheim's PID.
    wait $VALHEIM_PID
}

# Shutdown logic for valheim server.
shutdown() {
    echo "Valheim Server is shutting down..."

    # Terminate process by PID
    kill -2 $1

    # Wait for Valhiem Server to end.
    wait $1

    # Exit with status Zero.
    exit 0
}

# Call the shutdown function when an interupt or termination signal is sent.
trap shutdown SIGINT SIGTERM

# Call the start function.
start
