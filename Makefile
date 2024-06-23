NASM=nasm
NASMFLAGS=-f elf64 -g -F dwarf

GCC=gcc
GCCFLAGS=-no-pie -z noexecstack

all: juego.out

juego.out: main.o capturar.o inicializar_zorro.o mover_zorro.o verificar_estado_juego.o
	$(GCC) main.o capturar.o inicializar_zorro.o mover_zorro.o verificar_estado_juego.o -o juego.out $(GCCFLAGS)

main.o: main.asm
	$(NASM) $(NASMFLAGS) -o main.o main.asm

capturar.o: capturar.asm
	$(NASM) $(NASMFLAGS) -o capturar.o capturar.asm

inicializar_zorro.o: inicializar_zorro.asm
	$(NASM) $(NASMFLAGS) -o inicializar_zorro.o inicializar_zorro.asm

mover_zorro.o: mover_zorro.asm
	$(NASM) $(NASMFLAGS) -o mover_zorro.o mover_zorro.asm

verificar_estado_juego.o: verificar_estado_juego.asm
	$(NASM) $(NASMFLAGS) -o verificar_estado_juego.o verificar_estado_juego.asm

clean:
	rm -f *.o *.lst juego.out

.PHONY: all clean