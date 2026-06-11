# Docker Compose Commands

```Bash
docker compose up          # baut nur, wenn noch kein Image existiert

docker compose up --build  # baut auf jeden Fall neu → Standard im Dev

docker compose build       # baut nur die Images, startet nichts

docker compose push        # (nach build) pusht in Registry

docker compose down -v     # löscht auch named volumes

docker exec -it arma3-mods "bash"
```

## My Docker Compose Commands
```Bash
docker compose -f docker-compose.main.yml -p arma3-main up -d --build
docker compose -f docker-compose.spider.yml -p arma3-spider up -d --build
docker compose -f docker-compose.custom.yml -p arma3-custom up -d --build
docker compose -f docker-compose.experimental.yml -p arma3-experimental up -d --build
```

## Shortcut Script

```Bash
if [ -z "$1" ]; then
    echo "Fehler: Kein Argument Uebergeben."
    echo "Verwendung: $0 <server-name> <start|stop|up|down|logs>"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Fehler: Kein Argument Uebergeben."
    echo "Verwendung: $0 <server-name> <start|stop|up|down|logs>"
    exit 1
fi

SERVER=$1
CMD=$2

sh -c "docker compose -f docker-compose.${SERVER}.yml ${CMD}"
```