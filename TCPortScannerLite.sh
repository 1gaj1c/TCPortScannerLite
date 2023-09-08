#!/bin/bash
# -------------------------------------------------------------------------------
# Name:      TCPortScannerLite
# Purpose:   Este script realiza un escaneo de puertos TCP haciendo uso de la 
#            instrucción "/dev/tcp/host/puerto".
#
# Input:     Dirección IP o Nombre de Dominio
# Output:    Imprime por pantalla los puertos abiertos y genera un fichero con
#            nombre "host.csv" donde los almacena.
#
# Author:    MCarmen García Jiménez
# Created:   31/08/2022
# Copyright: (c) MCarmen García Jiménez 2023
# Licence:   GPL
# -------------------------------------------------------------------------------

# Control de argumentos de entrada
if test $# -ne 1
then
    echo "Uso: $0 [(Dirección IP)|(Nombre Dominio)]"
    exit
else
    # Comprueba que la máquina exista y no esté caída.
    $(ping -c 1 $1 > /dev/null 2>&1)
    if test $? -ne 0
    then    
        echo "La Dirección IP o el Nombre de Dominio no existe, no es válido o la máquina está caída"
        exit
    fi
fi

# Función que escanea todos los puertos.
# Por cada puerto abierto, se guardará la información en un array.
function scan(){

    local numpuertos=65535 # Todos los puertos
    posUltimoPuerto=0 # Contador para el array

    for ((i=1; i<=$numpuertos; i++))
    do
        var=$(timeout 1 bash -c "</dev/tcp/"$1"/"$i > /dev/null 2>&1 && echo "abierto" || echo "cerrado")
        # Si el puerto está abierto lo almacena en un array
        if test $var = "abierto"
        then
            puertosAbiertos[$posUltimoPuerto]=$i
            ((posUltimoPuerto ++))
        fi
    done

}

# Función que imprime información al principio.
function printStart(){

    YELLOW='\033[1;33m'
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color
    now="$(date)" # Fecha y hora del sistema

    echo "TCPortScannerLite desarrollado por el estudiante Mdel Carmen García"
    echo "Hora de ejecución: " "$now"
    echo ""

    echo -e "${YELLOW}[*] ${NC}Escaneo de puertos sobre" "$1" "en proceso"

}

# Función que imprime por pantalla los puertos abiertos.
function printOnScreen(){

    if test ${#puertosAbiertos[@]} -eq 0
    then
        echo "No hay puertos abiertos"
    else
        for ((j=0; j<$posUltimoPuerto; j++))
        do
            echo -e "    ${GREEN}[+]" "${puertosAbiertos[$j]}" "${NC}-- puerto abierto"
        done
    fi        

}

# Función que guarda en un fichero los puertos abiertos.
function saveCsvFile(){

    # Concatena la direción ip o nombre de dominio introducido por el usuario 
    # con la extensión para formar el nombre del fichero
    filename="$1".csv 
    echo " " > $filename # Limpia el fichero de ejecuciones anteriores

    # Recorre el array con los puertos abiertos y los almacena en el fichero
    local pos=0
    while test $pos -lt ${#puertosAbiertos[@]}
    do
        echo $1";"${puertosAbiertos[$pos]}";open" >> $filename
        ((pos ++))
    done 

}

# Llamada a las funciones
printStart "$1"
scan "$1"
printOnScreen
saveCsvFile "$1"
