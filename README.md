# TCPortScannerLite
Este script realiza un escaneo de puertos TCP haciendo uso de la instrucción "/dev/tcp/host/puerto".

Se  trata de una herramienta de enumeración de puertos abiertos en version "lite", empleando funciones propias del sistema de GNU/Linux.
A través de ella se podrán realizar enumeraciones por conexiones TCP como si de nmap se tratase.

Como entrada, toma la Dirección IP o Nombre de Dominio.
Como salida, imprime por pantalla la toda la información recopilada al usuario y genera un fichero en formato 'csv' con nombre "host.csv" con el listado de puertos abiertos.
