Para correr

sudo apt install asm

si agregan archivos
- actualizar linea para compilar ( ver issue de ahcer make file :)
- agregas el .o de su asm ak git ignore

línea pa compilar:

nasm -f elf64 main.asm -o main.o
nasm -f elf64 inicializar_juego.asm -o inicializar_juego.o
nasm -f elf64 imprimir_tablero.asm -o imprimir_tablero.o



gcc main.o inicializar_juego.o imprimir_tablero.o  -o juego.out -no-pie  -z noexecstack

./juego.out

------extra
Si cuando tiras el comando de linkeo con GCC te da un warning rarisimo
Sobre un stack ejecutable
Sumar -z noexecstack como opcion lo suprime


---------------
GDB

nasm -f elf64 -g -F dwarf -l main.lst -o main.o main.asm 
nasm -f elf64 -g -F dwarf -l inicializar_juego.lst -o inicializar_juego.o inicializar_juego.asm 
nasm -f elf64 -g -F dwarf -l imprimir_tablero.lst -o imprimir_tablero.o imprimir_tablero.asm 


 gcc main.o inicializar_juego.o imprimir_tablero.o  -o juego.out -no-pie  -z noexecstack

COMANDO COPADO: layout regs