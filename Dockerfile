FROM debian:12-slim

# Volume Mounting Directory
RUN mkdir /SteamCMD \
 && mkdir /PalContent

# Add Dependency
RUN dpkg --add-architecture i386 \
 && apt update \
 && apt upgrade -y \
 && apt install -y --no-install-recommends curl lib32gcc-s1 libc6-i386

# Extract SteamCMD
RUN curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz --output steamcmd.tar.gz \
 && tar -xzf steamcmd.tar.gz -C SteamCMD \
 && rm steamcmd.tar.gz

# Removed Unused Dependency
RUN apt autoremove --purge -y curl \
 && apt clean \
 && apt autoremove --purge -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Add Files
ADD Entrypoint.sh /.Entrypoint.sh

# Uninstall Package Manager
RUN apt install -y --no-install-recommends ca-certificates \
 && apt autoremove --purge apt --allow-remove-essential -y \
 && rm -rf /var/log/apt /etc/apt \
 && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Setup User
RUN useradd --uid 8211 -m steam

# Grant Permission to User
RUN chown -R steam:steam /SteamCMD \
 && chown -R steam:steam /PalContent

# Change User
WORKDIR /home/steam
USER steam

# Softlink Steam Library
RUN mkdir ~/.steam \
 && mkdir ~/.steam/sdk32/ \
 && ln -s /SteamCMD/linux32/steamclient.so ~/.steam/sdk32/steamclient.so \
 && mkdir ~/.steam/sdk64/ \
 && ln -s /SteamCMD/linux64/steamclient.so ~/.steam/sdk64/steamclient.so

# Remove Intermediate Layer
FROM scratch
COPY --from=0 / /

# Make Entrypoint Executable
RUN chmod +x /.Entrypoint.sh

# Change User
USER steam

# Image Label(s)
LABEL VRESION="Rolling Release" \
      UPSTREAM="https://github.com/Rexezuge-Forks/Palworld-Dedicated-Server-Docker"

# Port Forwarding
#   Only Game Server Port is Open by Default
#   Uncomment the Following Line if You Want RCON
#   EXPOSE 8211/tcp
EXPOSE 8211/udp

# Volume
VOLUME /SteamCMD /PalContent

# Environment(s)
ENV SRV_PORT=8211 \
    SRV_PLAYERS=32 \
    SRV_COMMUNITY_SERVER=1 \
    SRV_IMPROVED_MULTITHREADS=1 \
    SRV_SECURE_SERVER=1 \
    SRV_REPAIR_SERVER=0 \
    SRV_UPDATE_SERVER=1

# Set Entrypoint
ENTRYPOINT ["/bin/bash", "-c", "exec /.Entrypoint.sh"]
