#!/bin/bash

# Validate Game
if [ "$SRV_REPAIR_SERVER" = 1 ]
then
/SteamCMD/steamcmd.sh \
  +force_install_dir ../PalContent \
  +login anonymous \
  +app_update 2394010 validate \
  +quit \
  </dev/null
fi

# Update Game
if [ "$SRV_UPDATE_SERVER" = 1 ]
then
/SteamCMD/steamcmd.sh \
  +force_install_dir ../PalContent \
  +login anonymous \
  +app_update 2394010 \
  +quit \
  </dev/null
fi

# Start Game
exec /PalContent/PalServer.sh \
  -port="$SRV_PORT" \
  -players="$SRV_PLAYERS" \
  -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS
