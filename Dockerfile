# FROM cm2network/steamcmd

# LABEL version="1.0-SNAPSHOT"
# LABEL description="A docker image to run a valheim server."

# # Location for Valheim server.
# ENV VALHEIM_SERVER "/home/steam/valheim"

# # Location for Valheim world data.
# ENV VALHEIM_DATA "/home/steam/valheim-data"

# ENV VALHEIM_PORT 2456

# ENV SERVER_NAME "TestServerName"
# ENV WORLD_NAME "TestWorldName"
# ENV PASSWORD "password"

# EXPOSE 2456/udp
# EXPOSE 2457/udp
# EXPOSE 2458/udp

# RUN ./steamcmd.sh +login anonymous \
# +force_install_dir $VALHEIM_SERVER \
# +app_update 896660 \
# validate +exit

# COPY --chmod=755 ./start_valheim_server.sh ${VALHEIM_SERVER}

# VOLUME ${VALHEIM_DATA}

# WORKDIR ${VALHEIM_SERVER}

# ENTRYPOINT ["./start_valheim_server.sh"]

FROM cm2network/steamcmd

LABEL version="1.0-SNAPSHOT"
LABEL description="A docker image to run a valheim server."

# Location for Valheim server.
ENV VALHEIM_SERVER "/home/steam/valheim"

# Location for Valheim world data.
ENV VALHEIM_DATA "/home/steam/valheim-data"

ENV VALHEIM_PORT 2456

ENV SERVER_NAME "TestServerName"
ENV WORLD_NAME "TestWorldName"
ENV PASSWORD "password"

EXPOSE 2456/udp
EXPOSE 2457/udp
EXPOSE 2458/udp

RUN ./steamcmd.sh +login anonymous \
+force_install_dir $VALHEIM_SERVER \
+app_update 896660 \
validate +exit

COPY ./start_valheim_server.sh ${VALHEIM_SERVER}

VOLUME ${VALHEIM_DATA}

WORKDIR ${VALHEIM_SERVER}

ENTRYPOINT ["./start_valheim_server.sh"]
