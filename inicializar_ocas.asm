global inicializar_ocas

%define ARRIBA 'W'
%define IZQUIERDA 'A'
%define ABAJO 'S'
%define DERECHA 'D'
%define MAX_FILAS 7
%define MAX_COLUMNAS 7



section .bss
    movimientos_validos         times 3 resb 1


section .text
 

; asumo que el vector de ocas es una variable? los movimientos_validos tambien? (por ahora los recibo por parametro)
; (rdi, rsi, rdx)
; (vector_ocas: rdi, movimientos_validos: rsi, tope_ocas: rdx)
; post: inicializa las ocas desde arriba hacia abajo (filas superiores) y de izquierda a derecha, devuelve el puntero al vector en rax
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
        cmp rbx, 2      ; si la oca esta en la fila 3 la agrego
        je agregar_a_vector_de_ocas

        cmp rcx, 1
        jle segunda_condicion_de_inicializacion
        cmp rcx, 5
        jge segunda_condicion_de_inicializacion

        cmp rbx, 0      ; si la oca esta entre la columna 1 y 5 (sin incluir) y en la fila 1 la agrego
        je agregar_a_vector_de_ocas
        cmp rbx, 1      ; si la oca esta entre la columna 1 y 5 (sin incluir) y en la fila 2 la agrego
        je agregar_a_vector_de_ocas

    segunda_condicion_de_inicializacion:
        cmp rcx, 0      ; si la oca esta en la columna 1 compruebo la siguiente condicion
        je tercera_condicion_de_inicializacion
        cmp rcx, 6      ; si la oca esta en la columna 7 compruebo la siguiente condicion
        jne no_cumple_ninguna_condicion

    tercera_condicion_de_inicializacion:
        cmp rbx, 3      ; si la oca esta en la fila 3 la agrego
        je agregar_a_vector_de_ocas
        cmp rbx, 4      ; si la oca esta en la fila 4 la agrego
        je agregar_a_vector_de_ocas

    no_cumple_ninguna_condicion:
        jmp     avanzar_segundo_loop    ; la oca no se puede agregar, entonces avanzo a la siguiente posicion

    agregar_a_vector_de_ocas:
        mov     [rdi], bl       ;le agrego la fila a la oca
        mov     [rdi + 1], cl   ;le agrego la columna a la oca
        add     rdi, 2          ;avanzo el puntero a la siguiente oca
        add     byte[rdx], 2
        jmp     avanzar_segundo_loop