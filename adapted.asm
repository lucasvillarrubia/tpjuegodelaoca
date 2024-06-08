%define MAX_FILAS 7
%define MAX_COLUMNAS 7
%define CANT_OCAS 17
%define MAX_OCAS 48
%define NO_ENCONTRADX -1
%define ZORRO_COL_INICIAL 3
%define ZORRO_FIL_INICIAL 4
%define ZORRO 'Z'
%define OCA 'O'
%define FUERA_TABLERO 'X'
%define LUGAR_VACIO '-'

%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

extern printf
extern inicializar_juego
global main

section .data
    format_matrix db "%c ", 0
    format_newline db 10, 0
    format_ocas db "Ocas capturadas: %d", 10, 0
    bienvenida db "\n\n\n\t¡Bienvenidxs al Juego de la Oca!\n\tSi el zorro come 12 ocas gana (?\n\n\n", 0
    instrucciones db "\n\n\tInstrucciones de juego (masomenos):\n\n \
        Con la letra (A)  -->  Te movés a la IZQUIERDA. \n \
        Con la letra (D)  -->  Te movés a la DERECHA.   \n \
        Con la letra (W)  -->  Te movés hacia ARRIBA.   \n \
        Con la letra (S)  -->  Te movés hacia ABAJO.   \n \
        Con la letra (Q)  -->  Te movés hacia ARRIBA IZQUIERDA.   \n \
        Con la letra (E)  -->  Te movés hacia ARRIBA DERECHA.   \n \
        Con la letra (Z)  -->  Te movés hacia ABAJO IZQUIERDA.   \n \
        Con la letra (X)  -->  Te movés hacia ABAJO DERECHA.   \n\n\n\n", 0

section .bss
    tablero resb MAX_FILAS * MAX_COLUMNAS
    ocas resb MAX_OCAS * 16
    zorro_posicion resd 2
    zorro_ocas_capturadas resd 1
    zorro_comio_suficientes resb 1
    tope_ocas resd 1
    es_turno_del_zorro resb 1

section .text
main:
    call inicializar_juego
    call imprimir_tablero
    ret


; adapted.asm:102: error: mismatch in operand sizes
; adapted.asm:104: error: mismatch in operand sizes
; adapted.asm:107: error: mismatch in operand sizes
; adapted.asm:116: error: mismatch in operand sizes
