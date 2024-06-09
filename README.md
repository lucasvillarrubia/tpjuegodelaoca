Para correr

sudo apt install asm

si agregan archivos
- actualizar linea para compilar ( ver issue de ahcer make file :)
- agregas el .o de su asm ak git ignore

línea pa compilar:

nasm -f elf64 main.asm -o main.o
nasm -f elf64 inicializar_juego.asm -o inicializar_juego.o
nasm -f elf64 imprimir_tablero.asm -o imprimir_tablero.o
nasm -f elf64 definir_matriz.asm -o definir_matriz.o


gcc main.o inicializar_juego.o imprimir_tablero.o definir_matriz.o -o juego
