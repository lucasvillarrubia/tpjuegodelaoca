%define MAX_FILAS 7
%define MAX_COLUMNAS 7
%define CANT_OCAS 17
%define NO_ENCONTRADX -1
%define OCA 'O'
%define FUERA_TABLERO 'X'
%define LUGAR_VACIO '-'
%define TAMAÑO_OCA 2
%define ARRIBA 'W'
%define IZQUIERDA 'A'
%define ABAJO 'S'
%define DERECHA 'D'



extern	printf
extern  puts
global  main


%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro


section .data
    cantidad_ocas               db 17
    ocas_largo                  db 34
    fila_elemento_buscado       db 0
    columna_elemento_buscado    db 2
    tope_ocas                   db 0


section .bss
    vector_ocas         times CANT_OCAS resb TAMAÑO_OCA
    ; tope_ocas           resb 1
    oca_fila_actual     resb 1
    oca_columna_actual  resb 1
    movimientos_validos times 3 resb 1
    auxiliar_fila       resb 1
    auxiliar_columna    resb 1
section .text

; ignorar main e inicializar_juego los uso para probar cosas
main:
    call        inicializar_juego
    ; mov         al, [vector_ocas]
    ; cbw
    ; cwde
    ; cdqe
    ; mov         al, [vector_ocas + 1]
    ; cbw
    ; cwde
    ; cdqe
    ret


inicializar_juego:
    call     inicializar_ocas
    ; mov         al, [vector_ocas]
    ; cbw
    ; cwde
    ; cdqe
    ; mov         al, [vector_ocas + 1]
    ; cbw
    ; cwde
    ; cdqe
    call     buscar_oca
    ret

inicializar_ocas:
    lea     rax, [movimientos_validos]
    mov     dl, IZQUIERDA
    mov     [rax],  dl
    inc     rax
    mov     dl, ABAJO
    mov     [rax],  dl
    inc     rax
    mov     dl, DERECHA
    mov     [rax],  dl
    lea     rax, [vector_ocas]; dejo el puntero al vector en rax
    ; mov     byte[tope_ocas], 0    por alguna razon no quiere funcionar asi que lo defini en 0
    mov     rcx, 0          ; rcx va a ser i = 0

primer_loop:
    mov     rdx, 0          ; rdx va a ser j = 0
    cmp     rcx, MAX_FILAS  ; mientras rcx sea menor a 7 continua
    jge     cerrar_primer_loop
    segundo_loop:
        cmp     rdx, MAX_COLUMNAS    ; mientras rdx sea menor a 7 continua
        jge     cerrar_segundo_loop
        jmp     comprobar_condiciones_de_inicializacion
    avanzar_segundo_loop:
        inc     rdx
        jmp     segundo_loop
    cerrar_segundo_loop:
        inc     rcx
        jmp     primer_loop
cerrar_primer_loop:
    lea         rax, [vector_ocas]; devuelvo el puntero al vector en rax REPETIDO
    ret



comprobar_condiciones_de_inicializacion:
    cmp rdx, 2      ; si la oca esta en la fila 3 la agrego
    je agregar_a_vector_de_ocas

    cmp rcx, 1
    jle segunda_condicion_de_inicializacion
    cmp rcx, 5
    jge segunda_condicion_de_inicializacion

    cmp rdx, 0      ; si la oca esta entre la columna 1 y 5 (sin incluir) y en la fila 1 la agrego
    je agregar_a_vector_de_ocas
    cmp rdx, 1      ; si la oca esta entre la columna 1 y 5 (sin incluir) y en la fila 2 la agrego
    je agregar_a_vector_de_ocas

segunda_condicion_de_inicializacion:
    cmp rcx, 0      ; si la oca esta en la columna 1 compruebo la siguiente condicion
    je tercera_condicion_de_inicializacion
    cmp rcx, 6      ; si la oca esta en la columna 7 compruebo la siguiente condicion
    jne no_cumple_ninguna_condicion

tercera_condicion_de_inicializacion:
    cmp rdx, 3      ; si la oca esta en la fila 3 la agrego
    je agregar_a_vector_de_ocas
    cmp rdx, 4      ; si la oca esta en la fila 4 la agrego
    je agregar_a_vector_de_ocas

no_cumple_ninguna_condicion:
    jmp     avanzar_segundo_loop    ; la oca no se puede agregar, entonces avanzo a la siguiente posicion

agregar_a_vector_de_ocas:

    mov     [rax], cl       ;le agrego la fila a la oca
    mov     [rax + 1], dl   ;le agrego la columna a la oca
    add     rax, 2          ;avanzo el puntero a la siguiente oca
    inc     byte[tope_ocas]
    jmp     avanzar_segundo_loop


buscar_oca:
    mov     rcx, 0; contador para comparar con el tope
    mov     rbx, 0; contador para saber el indice del elemento en el vector
    primer_loop_buscar:
        cmp     rcx, [tope_ocas]
        jge     oca_no_encontrada
        mov     sil, [vector_ocas + rbx]; consigo la fila de la oca del vector AUN NO FUNCIONA
        mov     [oca_fila_actual], sil
        mov     sil, [vector_ocas + rbx + 1]; consigo la columna de la oca del vector AUN NO FUNCIONA
        mov     [oca_columna_actual], sil
        call    comprobar_posiciones_iguales
        cmp     rax, 0
        jge     oca_encontrada
        add     rbx, 2
        inc     rcx
        jmp     primer_loop_buscar
    oca_encontrada:
        mov     rax, rbx
        ret ;  en rax devuelvo el indice del elemento buscado teniendo en cuenta que el vector tiene 2 elementos por oca

    oca_no_encontrada:
        ret ; asumo que donde me llamen voy a usar el rax -1 para decir que no encontre la oca


comprobar_posiciones_iguales:
    mov     rdx, [fila_elemento_buscado]
    cmp     rdx, [oca_fila_actual]
    jne     posiciones_distintas
    mov     rdx, [columna_elemento_buscado]
    cmp     rdx, [oca_columna_actual]
    jne     posiciones_distintas
    mov     rax, 1 ; 1 representa oca encontrada
    ret
posiciones_distintas:
    mov     rax, -1 ; -1 representa oca no encontrada
    ret

; (rdi, rsi, rdx, rcx, r8, r9)
; (zorro_fila, zorro_columna, vector_de_ocas, movimiento, indice_de_oca)  
; el indice de oca tiene en cuenta que el vector tiene 2 valores por oca?
mover_oca:
    call    comprobar_movimiento_valido
    cmp     rax, 0 ;si no recibo una letra valida entonces no se puede mover
    jl      no_se_puede_mover_la_oca
    ;si fue movimiento invalido devuelvo -1?
    ;inicializo las variables
    call    esta_dentro_de_tablero
    cmp     rax, 0 ;si la proxima posicion esta fuera del tablero entonces no se puede mover
    jl      no_se_puede_mover_la_oca
    ;inicializo las variables
    call    comprobar_posiciones_iguales
    cmp     rax, 0 ;si la proxima posicion esta fuera del tablero entonces no se puede mover
    jg      no_se_puede_mover_la_oca
    ;muevo la oca
    mov     al, [auxiliar_fila]
    mov     [rdx + r8], al
    mov     al, [auxiliar_columna]
    mov     [rdx + r8 + 1], al
    mov     rax, 1
    ret




comprobar_movimiento_valido:
    cmp     rcx, [movimientos_validos]
    je      mover_izquierda
    cmp     rcx, [movimientos_validos + 1]
    je      mover_abajo
    cmp     rcx, [movimientos_validos + 2]
    je      mover_derecha
    mov     rax, -1
    ret


; ()
mover_izquierda:
    mov     al, [rdx + r8]
    mov     [auxiliar_fila], al
    mov     al, [rdx + r8 + 1]
    mov     [auxiliar_columna], al
    dec     byte[auxiliar_columna]
    mov     rax, 1
    ret

mover_abajo:
    mov     al, [rdx + r8]
    mov     [auxiliar_fila], al
    mov     al, [rdx + r8 + 1]
    mov     [auxiliar_columna], al
    dec     byte[auxiliar_fila]
    mov     rax, 1

mover_derecha:
    mov     al, [rdx + r8]
    mov     [auxiliar_fila], al
    mov     al, [rdx + r8 + 1]
    mov     [auxiliar_columna], al
    inc     byte[auxiliar_columna]
    mov     rax, 1


esta_dentro_de_tablero:
    cmp     byte[fila_elemento_buscado], 0 ;fila_elemento tiene que ser >= 0
    jl      elemento_fuera_del_tablero
    cmp     byte[fila_elemento_buscado], 6 ;fila_elemento tiene que ser <= 6
    jg      elemento_fuera_del_tablero
    cmp     byte[columna_elemento_buscado], 0 ;columna_elemento tiene que ser >= 0
    jl      elemento_fuera_del_tablero
    cmp     byte[columna_elemento_buscado], 6 ;columna_elemento tiene que ser <= 6
    jg      elemento_fuera_del_tablero

    cmp     byte[fila_elemento_buscado], 2 ;si fila_elemento es < 2 compruebo la otra condicion
    jl      comprobar_columna_valida
    cmp     byte[fila_elemento_buscado], 4 ;si fila_elemento es > 4 compruebo la otra condicion
    jg      comprobar_columna_valida
    jmp     elemento_dentro_del_tablero ;si paso las demas comprobaciones entonces esta dentro del tablero


    comprobar_columna_valida:
    cmp     byte[columna_elemento_buscado], 2 ;si columna_elemento es < 2 entonces no esta en el tablero
    jl      elemento_fuera_del_tablero
    cmp     byte[columna_elemento_buscado], 4 ;si columna_elemento es > 4 entonces no esta en el tablero
    jg      elemento_fuera_del_tablero
    jmp     elemento_dentro_del_tablero ;si paso las demas comprobaciones entonces esta dentro del tablero

    elemento_dentro_del_tablero:
    mov     rax, 1 ;con rax 1 digo que esta dentro del tablero
    ret

    elemento_fuera_del_tablero:
    mov     rax, -1 ;con rax -1 digo que no esta dentro del tablero
    ret

no_se_puede_mover_la_oca:
    mov     rax, -1
    ret

; hacer inicializacion (terminado)
; hacer buscar_oca (devuelve posicion de la oca en el vector con rax) (terminado)
; hacer eliminar_oca ()
; hacer mover_oca
; hacer esta_dentro_de_tablero ???
; las funciones que sean mas generales hacerlas en el main