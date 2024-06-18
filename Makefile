NASM=nasm
NASMFLAGS=-f elf64 -g -F dwarf

GCC=gcc
GCCFLAGS=-no-pie -z noexecstack

all: juego.out

juego.out: main.o inicializar_juego.o imprimir_tablero.o
	$(GCC) main.o inicializar_juego.o imprimir_tablero.o -o juego.out $(GCCFLAGS)

main.o: main.asm
	$(NASM) $(NASMFLAGS) -o main.o main.asm

inicializar_juego.o: inicializar_juego.asm
	$(NASM) $(NASMFLAGS) -o inicializar_juego.o inicializar_juego.asm

imprimir_tablero.o: imprimir_tablero.asm
	$(NASM) $(NASMFLAGS) -o imprimir_tablero.o imprimir_tablero.asm

clean:
	rm -f *.o *.lst juego.out

.PHONY: all clean
