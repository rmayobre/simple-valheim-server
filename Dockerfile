FROM cm2network/steamcmd

# Location for Valheim server.
ENV SERVER_DIR "/home/steam/valheim"

# Location for Valheim world data.
ENV WORLD_DATA_DIR "/home/steam/valheim-data"

ENV SERVER_PORT 2456

ENV SERVER_NAME "TestServerName"
ENV WORLD_NAME "TestWorldName"
ENV PASSWORD "password"

EXPOSE 2456/udp
EXPOSE 2457/udp
EXPOSE 2458/udp

RUN ./steamcmd.sh +login anonymous \
+force_install_dir $SERVER_DIR \
+app_update 896660 \
validate +exit

COPY ./start_valheim_server.sh ${SERVER_DIR}

VOLUME ${WORLD_DATA_DIR}

WORKDIR ${SERVER_DIR}

ENTRYPOINT ["./start_valheim_server.sh"]
