#!/bin/bash

# --- Colores para que se vea bonito ---
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Configuración ---
EXECUTABLE="./so_long"
MAPS_DIR="maps_valid"  # Directorio de mapas válidos

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
echo -e "${CYAN}    TESTEANDO MAPAS VÁLIDOS (so_long)    ${NC}"
echo -e "${CYAN}=========================================${NC}"
echo -e "${YELLOW}NOTA: Cierra la ventana del juego para pasar al siguiente test.${NC}\n"

# Array para guardar los tests fallidos
FAILED_TESTS=()

# 3. Bucle para probar cada archivo
for map in "$MAPS_DIR"/*; do
  # Si la carpeta está vacía o no es archivo, evita errores
  [ -f "$map" ] || continue

  # Imprimimos el nombre del mapa
  echo -e "${YELLOW}Probando mapa válido: ${NC}$map"
  echo -e "${CYAN}-----------------------------------------${NC}"

  # Ejecutamos el programa
  # 2>&1 redirige stderr para ver si hay errores impresos
  $EXECUTABLE "$map" 2>&1

  # Capturamos el código de salida (Exit Code)
  RET=$?

  echo -e ""
  # --- LÓGICA INVERTIDA RESPECTO AL TEST DE ERRORES ---
  if [ $RET -eq 0 ]; then
    echo -e "Exit Code: ${GREEN}$RET (OK - El mapa se cargó y cerró correctamente)${NC}"
  else
    echo -e "Exit Code: ${RED}$RET (FALLO - El programa dio error o crash)${NC}"
    # Guardamos el mapa en la lista de fallos
    FAILED_TESTS+=("$map")
  fi
  echo -e "${CYAN}-----------------------------------------${NC}\n"
  
  # Pausa breve
  sleep 0.2
done

# --- 4. Resumen Final ---
echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}             RESUMEN FINAL               ${NC}"
echo -e "${CYAN}=========================================${NC}"

if [ ${#FAILED_TESTS[@]} -eq 0 ]; then
  echo -e "\n${GREEN}¡Éxito! Tu so_long aceptó todos los mapas válidos.${NC}"
else
  echo -e "\n${RED}ATENCIÓN: Tu programa falló al cargar estos mapas válidos:${NC}"
  for failed_map in "${FAILED_TESTS[@]}"; do
    echo -e "  - ${YELLOW}$failed_map${NC}"
  done
  echo -e "\n${RED}Total de fallos: ${#FAILED_TESTS[@]}${NC}"
fi
