# simple-valheim-server
A simple valheim server docker image.

## Instructions
Basic docker instructions for building an image and setting up a container.

Before you start, make sure the `start_valheim_server.sh` file permissions allow for execution on your docker image. To do this on linux, run the following command:
```
chmod +x start_valheim_server.sh
```

### Build Image
Build the image like a normal docker image:
```
docker build -t rmayobre/valheimserver .
```

### Create Container
```
docker run -d \
--name valheim-server \
-v /path/to/mount:/home/steam/valheim-data \
-e SERVER_NAME="Server Name" \
-e WORLD_NAME="World Name" \
-e SERVER_PASS="password" \
rmayobre/valheimserver:latest
```