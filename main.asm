extern inicializar_juego
extern imprimir_tablero
global main

section .data
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

section .text
main:
    call inicializar_juego
    ;call definir_matriz ;aca llamariamos a una funcion que pregunte que tablero quiera?
    call imprimir_tablero
    ret

