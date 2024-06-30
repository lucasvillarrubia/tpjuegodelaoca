global mover_oca

extern buscar_indice_de_oca

section .data


section .bss
    fila_a_comparar             resb 1
    columna_a_comparar          resb 1
    auxiliar_fila               resb 1
    auxiliar_columna            resb 1

section .text

; el indice de oca tiene en cuenta que el vector tiene 2 valores
; (rdi, rsi, rdx, rcx, r8, r9, r10)
; (vector_de_ocas: rdi, movimiento: sil, zorro_fila: dl, zorro_columna: cl,  indice_de_oca: r8, tope_ocas: r9b, movimientos_validos: r10)  
; post: si se pudo mover la oca entonces devuelve 1 en rax, sino devuelve -1.
mover_oca:
    call    comprobar_movimiento_valido
    cmp     rax, 0 ;si no recibo una letra valida entonces no se puede mover
    jl      no_se_puede_mover_la_oca

    call    esta_dentro_de_tablero
    cmp     rax, 0 ;si la proxima posicion esta fuera del tablero entonces no se puede mover
    jl      no_se_puede_mover_la_oca

    mov     [fila_a_comparar], dl
    mov     [columna_a_comparar], cl
    call    comprobar_posiciones_iguales
    cmp     rax, 0 ;si el zorro esta en la proxima posicion entonces no se puede mover
    jg      no_se_puede_mover_la_oca

    mov     sil, r9b
    mov     dl, [auxiliar_fila]
    mov     cl, [auxiliar_columna]
    call    buscar_indice_de_oca
    cmp     rax, -1 ;si la proxima posicion esta ocupada por alguna oca entonces no se puede mover
    jne     no_se_puede_mover_la_oca

    ;muevo la oca
    mov     al, [auxiliar_fila]
    mov     [rdi + r8], al ; REVISAR EL R8 TALVEZ SEA R8B
    mov     al, [auxiliar_columna]
    mov     [rdi + r8 + 1], al ; REVISAR EL R8 TALVEZ SEA R8B
    mov     rax, 1
    ret

    comprobar_movimiento_valido:
        cmp     sil, byte[r10]
        je      mover_izquierda
        cmp     sil, byte[r10 + 1]
        je      mover_abajo
        cmp     sil, byte[r10 + 2]
        je      mover_derecha
        cmp     sil, byte[r10 + 3]
        je      mover_arriba
        mov     rax, -1
        ret


    mover_izquierda:
        mov     al, [rdi + r8]
        mov     [auxiliar_fila], al
        mov     al, [rdi + r8 + 1]
        mov     [auxiliar_columna], al
        dec     byte[auxiliar_columna]
        mov     rax, 1
        ret

    mover_abajo:
        mov     al, [rdi + r8]
        mov     [auxiliar_fila], al
        mov     al, [rdi + r8 + 1]
        mov     [auxiliar_columna], al
        inc     byte[auxiliar_fila]
        mov     rax, 1
        ret

    mover_derecha:
        mov     al, [rdi + r8]
        mov     [auxiliar_fila], al
        mov     al, [rdi + r8 + 1]
        mov     [auxiliar_columna], al
        inc     byte[auxiliar_columna]
        mov     rax, 1
        ret

    mover_arriba:
        mov     al, [rdi + r8]
        mov     [auxiliar_fila], al
        mov     al, [rdi + r8 + 1]
        mov     [auxiliar_columna], al
        dec     byte[auxiliar_fila]
        mov     rax, 1
        ret
    ; uso auxiliar_fila y auxiliar_columna
    esta_dentro_de_tablero:
        cmp     byte[auxiliar_fila], 1 ;fila_elemento tiene que ser >= 1
        jl      elemento_fuera_del_tablero
        cmp     byte[auxiliar_fila], 7 ;fila_elemento tiene que ser <= 7
        jg      elemento_fuera_del_tablero
        cmp     byte[auxiliar_columna], 1 ;columna_elemento tiene que ser >= 1
        jl      elemento_fuera_del_tablero
        cmp     byte[auxiliar_columna], 7 ;columna_elemento tiene que ser <= 7
        jg      elemento_fuera_del_tablero

        cmp     byte[auxiliar_fila], 3 ;si fila_elemento es < 3 compruebo la otra condicion
        jl      comprobar_columna_valida
        cmp     byte[auxiliar_fila], 5 ;si fila_elemento es > 5 compruebo la otra condicion
        jg      comprobar_columna_valida
        jmp     elemento_dentro_del_tablero ;si paso las demas comprobaciones entonces esta dentro del tablero


        comprobar_columna_valida:
        cmp     byte[auxiliar_columna], 3 ;si columna_elemento es < 3 entonces no esta en el tablero
        jl      elemento_fuera_del_tablero
        cmp     byte[auxiliar_columna], 5 ;si columna_elemento es > 5 entonces no esta en el tablero
        jg      elemento_fuera_del_tablero
        jmp     elemento_dentro_del_tablero ;si paso las demas comprobaciones entonces esta dentro del tablero

        elemento_dentro_del_tablero:
        mov     rax, 1 ;con rax 1 digo que esta dentro del tablero
        ret

        elemento_fuera_del_tablero:
        mov     rax, -1 ;con rax -1 digo que no esta dentro del tablero
        ret

    no_se_puede_mover_la_oca:
        mov     rax, -1 ;con rax -1 digo que la oca no se pudo mover
        ret


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