%define CANT_OCAS 17
%define TAMAÑO_OCA 2
%define ARRIBA 'W'
%define IZQUIERDA 'A'
%define ABAJO 'S'
%define DERECHA 'D'

global  main

extern inicializar_zorro
extern inicializar_ocas
extern buscar_indice_de_oca
extern mover_oca
extern eliminar_oca

section .data


section .bss
    fila_zorro                  resd 1
    columna_zorro               resd 1
    ocas_capturadas             resd 1
    zorro_ocas_capturadas       resb 1
    vector_ocas                 times CANT_OCAS resb TAMAÑO_OCA
    tope_ocas                   resb 1
    movimientos_validos         times 3 resb 1
section .text

main:
    lea     rdi, [fila_zorro]
    lea     rsi, [columna_zorro]
    lea     rdx, [ocas_capturadas]
    mov     rcx, IZQUIERDA ; LA ORIENTACION PEDIDA ESTA HARDCODEADA, ESTO ME LO DEBERIAN PASAR
    lea     r8, [zorro_ocas_capturadas]
    call    inicializar_zorro
    lea     rdi, [vector_ocas]
    lea     rsi, [movimientos_validos] ; uso un vector de movimientos para saber cual es el valido, talvez pueda servir mas
                                       ; cuando rotemos la matriz y las ocas tengan un movimiento no disponible
    lea     rdx, [tope_ocas]
    mov     rcx, IZQUIERDA ; LA ORIENTACION PEDIDA ESTA HARDCODEADA, ESTO ME LO DEBERIAN PASAR
    call    inicializar_ocas
    ret