

%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro


extern definir_matriz
extern inicializar_juego
extern imprimir_tablero
global main

section .data
    estado_juego dd 0
    bienvenida db 10, 10, 10, 32, 32, 32, 32, "¡Bienvenidxs al Juego de la Oca!", 10, 32, 32, 32, 32, "Si el zorro come 12 ocas gana (?", 10, 10, 10, 0
    instrucciones db "\n\n\tInstrucciones de juego (masomenos):\n\n \
        Con la letra (A)  -->  Te movés a la IZQUIERDA. \n \
        Con la letra (D)  -->  Te movés a la DERECHA.   \n \
        Con la letra (W)  -->  Te movés hacia ARRIBA.   \n \
        Con la letra (S)  -->  Te movés hacia ABAJO.   \n \
        Con la letra (Q)  -->  Te movés hacia ARRIBA IZQUIERDA.   \n \
        Con la letra (E)  -->  Te movés hacia ARRIBA DERECHA.   \n \
        Con la letra (Z)  -->  Te movés hacia ABAJO IZQUIERDA.   \n \
        Con la letra (X)  -->  Te movés hacia ABAJO DERECHA.   \n\n\n\n", 0
    mensaje_victoria_zorro db "Ganó el zorrooooo"
    mensaje_victoria_ocas db "Ganaron las ocasssss"

section .bss
    zorro_fila resd 1
    zorro_columna resd 1
    ocas_capturadas resd 1
    gano_zorro resb 1
    es_turno_del_zorro resb 1


section .text
main:
    sub rsp, 8
    call inicializar_juego
    add rsp, 8
    mov dword [zorro_fila], edi
    mov dword [zorro_columna], esi
    mov dword [zorro_ocas_capturadas], edx
    mov byte [zorro_comio_suficientes_ocas], cl
    mov byte [es_turno_del_zorro], ch

loop_juego:
    ; pa que no haga loop infinito
    jmp terminar_juego
    ;sub rsp, 8
    ;call definir_matriz ;aca llamariamos a una funcion que pregunte que tablero quiera?
    ;add rsp, 8
    ;sub rsp, 8
    ;call imprimir_tablero
    ;add rsp, 8

    ; ...después de un movimiento
    cmp dword [estado_juego], 0
    jg victoria_zorro
    jl victoria_ocas
    je loop_juego

victoria_zorro:
    mov rdi, mensaje_victoria_ocas
    mPrintf
    jmp terminar_juego

victoria_ocas:
    mov rdi, mensaje_victoria_zorro
    mPrintf
    jmp terminar_juego

terminar_juego:
    ret

