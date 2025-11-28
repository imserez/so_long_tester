#!/bin/bash

# --- Colores para que se vea bonito ---
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Configuración ---
EXECUTABLE="./so_long"
MAPS_DIR="maps_err"

# 1. Comprobar si existe el ejecutable
if [ ! -f "$EXECUTABLE" ]; then
  echo -e "${RED}Error: No encuentro el ejecutable '$EXECUTABLE'.${NC}"
  echo -e "Asegúrate de compilar con 'make' primero."
  exit 1
fi

# 2. Comprobar si existe la carpeta de mapas
if [ ! -d "$MAPS_DIR" ]; then
  echo -e "${RED}Error: No encuentro la carpeta '$MAPS_DIR'.${NC}"
  exit 1
fi

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}    TESTEANDO MAPAS DE ERROR (so_long)   ${NC}"
echo -e "${CYAN}=========================================${NC}\n"

# Array para guardar los tests fallidos
FAILED_TESTS=()

# 3. Bucle para probar cada archivo
for map in "$MAPS_DIR"/*; do
  # Si la carpeta está vacía, evita errores
  [ -e "$map" ] || continue

  # Imprimimos el nombre del mapa
  echo -e "${YELLOW}Probando mapa: ${NC}$map"
  echo -e "${CYAN}-----------------------------------------${NC}"

  # Ejecutamos el programa
  # 2>&1 redirige los errores (stderr) a la salida normal para que los veas
  $EXECUTABLE "$map" 2>&1

  # Capturamos el código de salida (Exit Code)
  RET=$?

  echo -e ""
  if [ $RET -ne 0 ]; then
    echo -e "Exit Code: ${GREEN}$RET (OK - El programa detectó error o salió)${NC}"
  else
    echo -e "Exit Code: ${RED}$RET (CUIDADO - El programa retornó 0)${NC}"
    # Guardamos el mapa en la lista de fallos
    FAILED_TESTS+=("$map")
  fi
  echo -e "${CYAN}-----------------------------------------${NC}\n"

  # Pausa opcional para leer (descomenta si va muy rápido)
  # sleep 0.5
done

# --- 4. Resumen Final ---
echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}             RESUMEN FINAL               ${NC}"
echo -e "${CYAN}=========================================${NC}"

if [ ${#FAILED_TESTS[@]} -eq 0 ]; then
  echo -e "\n${GREEN}¡Felicidades! Tu so_long gestionó correctamente todos los mapas de error.${NC}"
else
  echo -e "\n${RED}ATENCIÓN: Tu programa aceptó como válidos (Exit 0) los siguientes mapas erróneos:${NC}"
  for failed_map in "${FAILED_TESTS[@]}"; do
    echo -e "  - ${YELLOW}$failed_map${NC}"
  done
  echo -e "\n${RED}Total de fallos: ${#FAILED_TESTS[@]}${NC}"
fi
