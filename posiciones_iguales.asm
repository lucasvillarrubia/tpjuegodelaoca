global comprobar_posiciones_iguales


section .data


section .bss
    fila_a_comparar             resb 1
    columna_a_comparar          resb 1
    auxiliar_fila               resb 1
    auxiliar_columna            resb 1

section .text



; pre: auxiliar_fila, auxiliar_columna, fila_a_comparar y columna_a_comparar tienen que estar inicializados
comprobar_posiciones_iguales:
    mov     dl, [auxiliar_fila]
    cmp     dl, [fila_a_comparar]
    jne     posiciones_distintas
    mov     dl, [auxiliar_columna]
    cmp     dl, [columna_a_comparar]
    jne     posiciones_distintas
    mov     rax, 1 ; 1 representa que las posiciones son iguales
    ret
posiciones_distintas:
    mov     rax, -1 ; -1 representa que las posiciones no son iguales
    ret