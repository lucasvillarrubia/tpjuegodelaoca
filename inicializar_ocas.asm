global inicializar_ocas

%define ARRIBA 'W'
%define IZQUIERDA 'A'
%define ABAJO 'X'
%define DERECHA 'D'
%define MAX_FILAS 7
%define MAX_COLUMNAS 7

section .bss
    orientacion             resb 1

section .text

; Asumo que el vector de ocas es una variable? 
; orientacion es: W, A, X o D. La orientacion default es W.
; (rdi, rsi, rdx, rcx)
; (vector_ocas: rdi, movimientos_validos: rsi, tope_ocas: rdx, orientacion: cl)
; post: inicializa las ocas desde arriba hacia abajo (filas superiores) y de izquierda a derecha. 
;       Si no me pasan una orientacion entonces la default es ARRIBA
inicializar_ocas:
    mov     [orientacion], cl
    call    inicializar_movimientos_validos
    mov     byte[rdx], 0
    mov     rbx, 1          ; rbx va a ser i = 1

    primer_loop:
        mov     rcx, 1          ; rcx va a ser j = 1
        cmp     rbx, MAX_FILAS  ; mientras rbx sea menor igual a 7 continua
        jg      cerrar_primer_loop
        segundo_loop:
            cmp     rcx, MAX_COLUMNAS    ; mientras rcx sea menor igual a 7 continua
            jg      cerrar_segundo_loop
            jmp     comprobar_condiciones_de_inicializacion
        avanzar_segundo_loop:
            inc     rcx
            jmp     segundo_loop
        cerrar_segundo_loop:
            inc     rbx
            jmp     primer_loop
    cerrar_primer_loop:
        ret ; en rax no devuelvo nada

    inicializar_movimientos_validos:
        mov     byte[rsi],  IZQUIERDA
        mov     byte[rsi + 1],  ABAJO
        mov     byte[rsi + 2],  DERECHA
        mov     byte[rsi + 3],  ARRIBA
        call    sacar_movimiento_invalido
        ret

    comprobar_condiciones_de_inicializacion:
        cmp rbx, 3      ; si la oca esta en la fila 3 la agrego
        je agregar_a_vector_de_ocas

        cmp rcx, 2
        jle segunda_condicion_de_inicializacion
        cmp rcx, 6
        jge segunda_condicion_de_inicializacion

        cmp rbx, 1      ; si la oca esta entre la columna 2 y 6 (sin incluir) y en la fila 1 la agrego
        je agregar_a_vector_de_ocas
        cmp rbx, 2      ; si la oca esta entre la columna 2 y 6 (sin incluir) y en la fila 2 la agrego
        je agregar_a_vector_de_ocas

    segunda_condicion_de_inicializacion:
        cmp rcx, 1      ; si la oca esta en la columna 1 compruebo la siguiente condicion
        je tercera_condicion_de_inicializacion
        cmp rcx, 7      ; si la oca esta en la columna 7 compruebo la siguiente condicion
        jne no_cumple_ninguna_condicion

    tercera_condicion_de_inicializacion:
        cmp rbx, 4      ; si la oca esta en la fila 4 la agrego
        je agregar_a_vector_de_ocas
        cmp rbx, 5      ; si la oca esta en la fila 5 la agrego
        je agregar_a_vector_de_ocas

    no_cumple_ninguna_condicion:
        jmp     avanzar_segundo_loop    ; la oca no se puede agregar, entonces avanzo a la siguiente posicion

    agregar_a_vector_de_ocas:
        mov     [rdi], bl       ;le agrego la fila a la oca
        mov     [rdi + 1], cl   ;le agrego la columna a la oca
        call    reacomodar_en_base_a_orientacion
        add     rdi, 2          ;avanzo el puntero a la siguiente oca
        add     byte[rdx], 2
        jmp     avanzar_segundo_loop


    reacomodar_en_base_a_orientacion:
        cmp     byte[orientacion], ABAJO
        je      reacomodar_abajo
        cmp     byte[orientacion], IZQUIERDA
        je      reacomodar_izquierda
        cmp     byte[orientacion], DERECHA
        je      reacomodar_derecha
        ret

    reacomodar_abajo:
        call    espejo
        ret

    reacomodar_izquierda:
        call    rotar
        ret

    reacomodar_derecha:
        call    rotar
        call    espejo
        ret

    ; pos: doy vuelta las posiciones de la oca, cambio fila por columna y viceversa
    rotar:
        mov     [rdi], cl
        mov     [rdi + 1], bl
        ret

    ; pos: a las posiciones de la oca les asigno el punto que esta al otro lado de donde se encuentran en relacion al punto (4,4)
    ; Ej: punto (2,5) va a parar al (6, 3)
    espejo:
        mov     al, 4 ; le asigno al registro la fila central
        sub     al, [rdi] ; al registro le resto la fila asignada originalmente a la oca para sacar la "distancia" a la fila central
        add     al, 4 ; al punto central le sumo esta "distancia"
        mov     [rdi], al ; le asigno esta nueva fila a la oca
        mov     al, 4 ; le asigno al registro la columna central
        sub     al, [rdi + 1] ; al registro le resto la columna asignada originalmente a la oca para sacar la "distancia" a la columna central
        add     al, 4 ; al punto central le sumo esta "distancia"
        mov     [rdi + 1], al ; le asigno esta nueva columna a la oca
        ret

    sacar_movimiento_invalido:
        mov     al, [orientacion]
        cmp     [rsi], al
        je      sacar_movimiento_izquierda
        cmp     [rsi + 1], al
        je      sacar_movimiento_abajo
        cmp     [rsi + 2], al
        je      sacar_movimiento_derecha
        jmp     sacar_movimiento_arriba

    sacar_movimiento_izquierda:
        mov     byte[rsi], -1
        ret

    sacar_movimiento_abajo:
        mov     byte[rsi + 1], -1
        ret

    sacar_movimiento_derecha:
        mov     byte[rsi + 2], -1
        ret

    sacar_movimiento_arriba:
        mov     byte[rsi + 3], -1
        ret
