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
docker compose -f docker-compose.base.yml -p arma3-base up -d --build
docker compose -f docker-compose.main.yml -p arma3-main up -d --build
docker compose -f docker-compose.spider.yml -p arma3-spider up -d --build
docker compose -f docker-compose.custom.yml -p arma3-custom up -d --build
```

## Alias
```Bash
# in deine ~/.bashrc oder ~/.zshrc
alias main-up='docker compose -f docker-compose.main.yml -p arma3-main up -d --build'
alias custom-up='docker compose -f docker-compose.custom.yml -p arma3-custom up -d --build'
alias main-down='docker compose -f docker-compose.main.yml -p arma3-main down'
alias custom-down='docker compose -f docker-compose.custom.yml -p arma3-custom down'
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

#alias a3up='docker compose -f docker-compose.base.yml up -d'
#alias a3start='docker compose -f docker-compose.base.yml start'
#alias a3stop='docker compose -f docker-compose.base.yml stop'
#alias a3down='docker compose -f docker-compose.base.yml down'
#alias a3logs='docker compose -f docker-compose.base.yml logs -f'
```