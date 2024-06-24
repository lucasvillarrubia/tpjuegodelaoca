NASM=nasm
NASMFLAGS=-f elf64 -g -F dwarf

GCC=gcc
GCCFLAGS=-no-pie -z noexecstack

all: juego.out

juego.out: main.o inicializar_zorro.o verificar_estado_juego.o inicializar_juego.o imprimir_tablero.o capturar.o definir_matriz.o mover_zorro.o tablero.o
	$(GCC) main.o inicializar_zorro.o verificar_estado_juego.o inicializar_juego.o imprimir_tablero.o capturar.o definir_matriz.o mover_zorro.o tablero.o -o juego.out $(GCCFLAGS)


main.o: main.asm
	$(NASM) $(NASMFLAGS) -o main.o main.asm

capturar.o: capturar.asm
	$(NASM) $(NASMFLAGS) -o capturar.o capturar.asm

inicializar_zorro.o: inicializar_zorro.asm
	$(NASM) $(NASMFLAGS) -o inicializar_zorro.o inicializar_zorro.asm

verificar_estado_juego.o: verificar_estado_juego.asm
	$(NASM) $(NASMFLAGS) -o verificar_estado_juego.o verificar_estado_juego.asm

inicializar_juego.o: inicializar_juego.asm
	$(NASM) $(NASMFLAGS) -o inicializar_juego.o inicializar_juego.asm

imprimir_tablero.o: imprimir_tablero.asm
	$(NASM) $(NASMFLAGS) -o imprimir_tablero.o imprimir_tablero.asm

definir_matriz.o: definir_matriz.asm
	$(NASM) $(NASMFLAGS) -o definir_matriz.o definir_matriz.asm

mover_zorro.o: mover_zorro.asm
	$(NASM) $(NASMFLAGS) -o mover_zorro.o mover_zorro.asm

tablero.o: tablero.asm
	$(NASM) $(NASMFLAGS) -o tablero.o tablero.asm

clean:
	rm -f *.o *.lst juego.out
