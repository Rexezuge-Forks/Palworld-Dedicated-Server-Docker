# Palworld Dedicated Server Docker

## Source

[[Github](https://github.com/Rexezuge-Forks/Palworld-Dedicated-Server-Docker)]

## Launch

```shell
docker volume create SteamCMD_DATA
docker volume create PalContent_DATA
docker run -d -p 8211:8211/udp \
  --name Palworld-Server \
  --restart=unless-stopped \
  -v SteamCMD_DATA://SteamCMD \
  -v PalContent_DATA:/PalContent \
  rexezuge/palworld-server:release
```

## Official Documentation

[[Configuration file](https://tech.palworldgame.com/settings-and-operation/configuration)]
