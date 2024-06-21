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



global  main
global  inicializar_ocas
global  buscar_indice_de_oca
global  mover_oca
global  eliminar_oca


section .data
    cantidad_ocas               db 17
    ocas_largo                  db 34



section .bss
    vector_ocas                 times CANT_OCAS resb TAMAÑO_OCA
    tope_ocas                   resb 1
    fila_a_comparar             resb 1
    columna_a_comparar          resb 1
    movimientos_validos         times 3 resb 1
    auxiliar_fila               resb 1
    auxiliar_columna            resb 1
section .text

; ignorar main e inicializar_juego los uso para probar cosas
main:
    call        inicializar_juego
    ret


inicializar_juego:
    lea     rdi, [vector_ocas]
    lea     rsi, [movimientos_validos]
    lea     rdx, [tope_ocas]
    call    inicializar_ocas
    ; mov     al, [vector_ocas + 1]
    ; cbw
    ; cwde
    ; cdqe
    mov     byte[auxiliar_fila], 0
    mov     byte[auxiliar_columna], 3
    lea     rdi, [vector_ocas]
    mov     sil, [tope_ocas]
    mov     dl, [auxiliar_fila]
    mov     cl, [auxiliar_columna]
    call    buscar_indice_de_oca
    ret


; (rdi, rsi, rdx)
; asumo que el vector de ocas es una variable? los movimientos_validos tambien? (por ahora los recibo por parametro)
; pre: (vector_ocas: rdi, movimientos_validos: rsi, tope_ocas: rdx)
inicializar_ocas:
    call    inicializar_movimientos_validos
    mov     rax, rdi; dejo el puntero al inicio del vector en rax
    mov     byte[rdx], 0
    mov     rbx, 0          ; rbx va a ser i = 0

    primer_loop:
        mov     rcx, 0          ; rcx va a ser j = 0
        cmp     rbx, MAX_FILAS  ; mientras rbx sea menor a 7 continua
        jge     cerrar_primer_loop
        segundo_loop:
            cmp     rcx, MAX_COLUMNAS    ; mientras rcx sea menor a 7 continua
            jge     cerrar_segundo_loop
            jmp     comprobar_condiciones_de_inicializacion
        avanzar_segundo_loop:
            inc     rcx
            jmp     segundo_loop
        cerrar_segundo_loop:
            inc     rbx
            jmp     primer_loop
    cerrar_primer_loop:
        ret ; devuelvo en rax el puntero al inicio del vector

    inicializar_movimientos_validos:
        mov     rax, rsi
        mov     dl, IZQUIERDA
        mov     [rax],  dl
        inc     rax
        mov     dl, ABAJO
        mov     [rax],  dl
        inc     rax
        mov     dl, DERECHA
        mov     [rax],  dl
        ret

    comprobar_condiciones_de_inicializacion:
        cmp rcx, 2      ; si la oca esta en la fila 3 la agrego
        je agregar_a_vector_de_ocas

        cmp rbx, 1
        jle segunda_condicion_de_inicializacion
        cmp rbx, 5
        jge segunda_condicion_de_inicializacion

        cmp rcx, 0      ; si la oca esta entre la columna 1 y 5 (sin incluir) y en la fila 1 la agrego
        je agregar_a_vector_de_ocas
        cmp rcx, 1      ; si la oca esta entre la columna 1 y 5 (sin incluir) y en la fila 2 la agrego
        je agregar_a_vector_de_ocas

    segunda_condicion_de_inicializacion:
        cmp rbx, 0      ; si la oca esta en la columna 1 compruebo la siguiente condicion
        je tercera_condicion_de_inicializacion
        cmp rbx, 6      ; si la oca esta en la columna 7 compruebo la siguiente condicion
        jne no_cumple_ninguna_condicion

    tercera_condicion_de_inicializacion:
        cmp rcx, 3      ; si la oca esta en la fila 3 la agrego
        je agregar_a_vector_de_ocas
        cmp rcx, 4      ; si la oca esta en la fila 4 la agrego
        je agregar_a_vector_de_ocas

    no_cumple_ninguna_condicion:
        jmp     avanzar_segundo_loop    ; la oca no se puede agregar, entonces avanzo a la siguiente posicion

    agregar_a_vector_de_ocas:
        mov     [rdi], bl       ;le agrego la fila a la oca
        mov     [rdi + 1], cl   ;le agrego la columna a la oca
        add     rdi, 2          ;avanzo el puntero a la siguiente oca
        add     byte[rdx], 2
        jmp     avanzar_segundo_loop

; (rdi, rsi, rdx, rcx)
; (vector_ocas: rdi, tope_ocas: sil, auxiliar_fila: dl, auxiliar_columna: cl)
buscar_indice_de_oca:
    mov     [auxiliar_fila], dl
    mov     [auxiliar_columna], cl
    mov     [tope_ocas], sil
    mov     rcx, 0; contador para saber el indice del elemento en el vector, y lo uso para comparar con el tope
    primer_loop_buscar:
        cmp     cl, [tope_ocas]
        jge     oca_no_encontrada
        mov     sil, [rdi + rcx]; consigo la fila de la oca del vector
        mov     [fila_a_comparar], sil
        mov     sil, [rdi + rcx + 1]; consigo la columna de la oca del vector
        mov     [columna_a_comparar], sil
        call    comprobar_posiciones_iguales
        cmp     rax, 0
        jge     oca_encontrada
        add     rcx, 2
        jmp     primer_loop_buscar
    oca_encontrada:
        mov     rax, rcx
        ret ;  en rax devuelvo el indice del elemento buscado teniendo en cuenta que el vector tiene 2 elementos por oca

    oca_no_encontrada:
        ret ; asumo que donde me llamen voy a usar el rax -1 para decir que no encontre la oca


; (necesito que las 4 variables vengan correctamente inicializadas)
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

; (rdi, rsi, rdx, rcx, r8, r9)
; (vector_de_ocas: rdi, movimiento: sil, zorro_fila: dl, zorro_columna: cl,  indice_de_oca: r8b, tope_ocas: r9b)  
; el indice de oca tiene en cuenta que el vector tiene 2 valores por oca?
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
    cmp     sil, [movimientos_validos]
    je      mover_izquierda
    cmp     sil, [movimientos_validos + 1]
    je      mover_abajo
    cmp     sil, [movimientos_validos + 2]
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

; uso auxiliar_fila y auxiliar_columna
esta_dentro_de_tablero:
    cmp     byte[auxiliar_fila], 0 ;fila_elemento tiene que ser >= 0
    jl      elemento_fuera_del_tablero
    cmp     byte[auxiliar_fila], 6 ;fila_elemento tiene que ser <= 6
    jg      elemento_fuera_del_tablero
    cmp     byte[auxiliar_columna], 0 ;columna_elemento tiene que ser >= 0
    jl      elemento_fuera_del_tablero
    cmp     byte[auxiliar_columna], 6 ;columna_elemento tiene que ser <= 6
    jg      elemento_fuera_del_tablero

    cmp     byte[auxiliar_fila], 2 ;si fila_elemento es < 2 compruebo la otra condicion
    jl      comprobar_columna_valida
    cmp     byte[auxiliar_fila], 4 ;si fila_elemento es > 4 compruebo la otra condicion
    jg      comprobar_columna_valida
    jmp     elemento_dentro_del_tablero ;si paso las demas comprobaciones entonces esta dentro del tablero


    comprobar_columna_valida:
    cmp     byte[auxiliar_columna], 2 ;si columna_elemento es < 2 entonces no esta en el tablero
    jl      elemento_fuera_del_tablero
    cmp     byte[auxiliar_columna], 4 ;si columna_elemento es > 4 entonces no esta en el tablero
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



; (rdi, rsi, rdx, rcx)
; (vector_de_ocas: rdi, tope_ocas: rsi, auxiliar_fila: dl, auxiliar_columna: cl)  
eliminar_oca:
    call    buscar_indice_de_oca
    cmp     rax, -1
    je      no_se_puede_eliminar_oca
    sub     byte[tope_ocas], 2 ; le quito una oca al vector (con el tope)
    mov     rbx, rax
    ; actualizo el vector para sacar la oca que quiero eliminar
    loop_eliminar_oca:
        cmp     rbx, [tope_ocas]
        jge     terminar_loop_eliminar_oca
        mov     dl, [rdi + rbx + 2] ; agarro la proxima fila
        mov     [rdi + rbx], dl ; la pongo en la fila del actual
        mov     cl, [rdi + rbx + 3] ; agarro la proxima columna
        mov     [rdi + rbx + 1], dl ; la pongo en la columna del actual
        add     rbx, 2
    terminar_loop_eliminar_oca:
        mov     rax, 1
no_se_puede_eliminar_oca:
    mov     rax, -1
    ret


; hacer inicializacion (terminado)
; hacer buscar_indice_de_oca (devuelve posicion de la oca en el vector con rax) (terminado)
; hacer eliminar_oca (terminado)
; hacer mover_oca (terminado)
; hacer esta_dentro_de_tablero (terminado)
; las funciones que sean mas generales hacerlas en el main