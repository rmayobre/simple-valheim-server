FROM debian:buster-slim

ARG PUID=1000

########################################
#    SteamCMD Environment Variables    #
########################################

ENV USER steam
ENV HOME_DIR "/home/${USER}"
ENV STEAMCMD_DIR "${HOME_DIR}/steamcmd"

########################################
# Valheim Server Environment Variables #
########################################

ENV SERVER_DIR "/home/steam/valheim"
ENV WORLD_DATA_DIR "/home/steam/valheim-data"
ENV SERVER_PORT 2456
ENV SERVER_NAME "TestServerName"
ENV WORLD_NAME "TestWorldName"
ENV PASSWORD "password"

# Expose these ports for Valheim Server
EXPOSE 2456/udp
EXPOSE 2457/udp
EXPOSE 2458/udp

# Install and set up SteamCMD
RUN set -x \
	&& dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6=8.3.0-6 \
		lib32gcc1=1:8.3.0-6 \
		wget=1.20.1-1.1 \
		ca-certificates=20200601~deb10u2 \
		nano=3.2-3 \
		libsdl2-2.0-0:i386=2.0.9+dfsg1-1 \
		curl=7.64.0-4+deb10u1 \
	&& useradd -u "${PUID}" -m "${USER}" \
        && su "${USER}" -c \
                "mkdir -p \"${STEAMCMD_DIR}\" \
                && wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C \"${STEAMCMD_DIR}\" \
                && \"./${STEAMCMD_DIR}/steamcmd.sh\" +quit \
                && mkdir -p \"${HOME_DIR}/.steam/sdk32\" \
                && ln -s \"${STEAMCMD_DIR}/linux32/steamclient.so\" \"${HOME_DIR}/.steam/sdk32/steamclient.so\" \
		        && ln -s \"${STEAMCMD_DIR}/linux32/steamcmd\" \"${STEAMCMD_DIR}/linux32/steam\" \
		        && ln -s \"${STEAMCMD_DIR}/steamcmd.sh\" \"${STEAMCMD_DIR}/steam.sh\"" \
	&& ln -s "${STEAMCMD_DIR}/linux32/steamclient.so" "/usr/lib/i386-linux-gnu/steamclient.so" \
	&& ln -s "${STEAMCMD_DIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
	&& apt-get remove --purge -y \
		wget \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

# Use SteamCMD to install Valheim Server
RUN "${STEAMCMD_DIR}"/steamcmd.sh +login anonymous \
+force_install_dir $SERVER_DIR \
+app_update 896660 \
validate +exit

# Copy the start script
COPY ./start_valheim_server.sh ${SERVER_DIR}

USER ${USER}

WORKDIR ${STEAMCMD_DIR}
WORKDIR ${SERVER_DIR}

VOLUME ${STEAMCMD_DIR}
VOLUME ${WORLD_DATA_DIR}

ENTRYPOINT ["./start_valheim_server.sh"]