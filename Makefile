NASM=nasm
NASMFLAGS=-f elf64 -g -F dwarf

GCC=gcc
GCCFLAGS=-no-pie -z noexecstack -g

all: juego.out


juego.out: manejo_archivos.o preguntar_indice.o preguntar_orientacion.o capturar.o inicializar_zorro.o mover_zorro.o verificar_estado_juego.o inicializar_juego.o imprimir_tablero.o inicializar_ocas.o buscar_oca.o eliminar_oca.o mover_oca.o main.o
	$(GCC) manejo_archivos.o preguntar_indice.o preguntar_orientacion.o capturar.o inicializar_zorro.o mover_zorro.o verificar_estado_juego.o inicializar_juego.o imprimir_tablero.o inicializar_ocas.o buscar_oca.o eliminar_oca.o mover_oca.o  main.o -o juego.out $(GCCFLAGS)



main.o: main.asm
	$(NASM) $(NASMFLAGS) -o main.o main.asm

buscar_oca.o: buscar_oca.asm
	$(NASM) $(NASMFLAGS) -o buscar_oca.o buscar_oca.asm

capturar.o: capturar.asm
	$(NASM) $(NASMFLAGS) -o capturar.o capturar.asm


eliminar_oca.o: eliminar_oca.asm
	$(NASM) $(NASMFLAGS) -o eliminar_oca.o eliminar_oca.asm

imprimir_tablero.o: imprimir_tablero.asm
	$(NASM) $(NASMFLAGS) -o imprimir_tablero.o imprimir_tablero.asm

inicializar_juego.o: inicializar_juego.asm
	$(NASM) $(NASMFLAGS) -o inicializar_juego.o inicializar_juego.asm	

inicializar_ocas.o: inicializar_ocas.asm
	$(NASM) $(NASMFLAGS) -o inicializar_ocas.o inicializar_ocas.asm

inicializar_zorro.o: inicializar_zorro.asm
	$(NASM) $(NASMFLAGS) -o inicializar_zorro.o inicializar_zorro.asm

mover_oca.o: mover_oca.asm
	$(NASM) $(NASMFLAGS) -o mover_oca.o mover_oca.asm

mover_zorro.o: mover_zorro.asm
	$(NASM) $(NASMFLAGS) -o mover_zorro.o mover_zorro.asm

verificar_estado_juego.o: verificar_estado_juego.asm
	$(NASM) $(NASMFLAGS) -o verificar_estado_juego.o verificar_estado_juego.asm

preguntar_orientacion.o : preguntar_orientacion.asm
	$(NASM) $(NASMFLAGS) -o preguntar_orientacion.o preguntar_orientacion.asm

preguntar_indice.o: preguntar_indice.asm
	$(NASM) $(NASMFLAGS) -o preguntar_indice.o preguntar_indice.asm

manejo_archivos.o :manejo_archivos.asm
	$(NASM) $(NASMFLAGS) -o manejo_archivos.o manejo_archivos.asm

clean:
	rm -f *.o *.lst *.dat juego.out

