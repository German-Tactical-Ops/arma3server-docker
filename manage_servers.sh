#!/bin/bash

# Farben für die Ausgabe
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Standardmäßig im Detached-Modus starten
DETACHED="-d"

# Argumente verarbeiten
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--debug) DETACHED=""; shift ;;
        *) echo "Unbekanntes Argument: $1"; exit 1 ;;
    esac
done

echo -e "${BLUE}========================================"
echo -e "    Arma 3 Server Build Manager"
echo -e "========================================${NC}"

# Verfügbare Instanzen finden (basiert auf den docker-compose.*.yml Dateien)
INSTANCES=($(ls docker-compose.*.yml | grep -v "docker-compose.yml" | sed 's/docker-compose\.\(.*\)\.yml/\1/'))

show_menu() {
    echo -e "\n${YELLOW}Welchen Server möchtest du bauen/starten?${NC}"
    echo "----------------------------------------"
    echo -e "${BLUE}0)${NC} ALLE Server (Cluster) [Standard]"
    index=1
    for instance in "${INSTANCES[@]}"; do
        echo -e "${GREEN}$index)${NC} arma3-$instance"
        ((index++))
    done
    echo -e "${RED}q)${NC} Beenden"
    echo "----------------------------------------"
}

run_docker() {
    local file=$1
    local name=$2
    echo -e "\n${BLUE}Starte Build für: ${YELLOW}$name${NC}"
    docker compose -f "$file" -p arma3-$name up $DETACHED --build
}

while true; do
    show_menu
    read -p "Auswahl [0]: " choice
    
    # Standardwert setzen, wenn Eingabe leer ist
    if [[ -z "$choice" ]]; then
        choice="0"
    fi

    if [[ "$choice" == "q" ]]; then
        echo -e "${BLUE}Auf Wiedersehen!${NC}"
        exit 0
    fi

    # Prüfen ob Eingabe eine Zahl ist
    if [[ "$choice" =~ ^[0-9]+$ ]]; then
        num_instances=${#INSTANCES[@]}

        if [[ "$choice" -eq 0 ]]; then
            run_docker "docker-compose.yml" "ALLE Server (Cluster)"
            exit 0
        elif [[ "$choice" -le "$num_instances" ]]; then
            selected_instance=${INSTANCES[$((choice-1))]}
            run_docker "docker-compose.$selected_instance.yml" "arma3-$selected_instance"
        else
            echo -e "${RED}Ungültige Auswahl!${NC}"
        fi
    else
        echo -e "${RED}Bitte eine Zahl oder 'q' eingeben.${NC}"
    fi
done
