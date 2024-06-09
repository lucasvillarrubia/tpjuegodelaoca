
%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

extern printf


section .data
    matriz  db 0, 0, 0
            db 0, 0, 0
            db 0, 0, 0, 0, 0, 0, 0
            db 0, 0, 0, 0, 0, 0, 0
            db 0, 0, 0, 0, 0, 0, 0
            db 0, 0, 0
            db 0, 0, 0

    format_elemento db "%2d ", 0   ; Formato para imprimir cada elemento de la matriz
    format_newline db 10, 0        ; Carácter de nueva línea para imprimir al final de cada fila
    format_space db "   ", 0       ; Espacio para rellenar en la parte superior e inferior de la matriz

section .text
    extern printf
    global imprimir_matriz
    
imprimir_matriz:
    ; Imprimir la parte superior de la matriz
    sub     rsp, 8
    mov     rdi, format_space
    call    printf
    add     rsp, 8

    ; Bucle para recorrer las filas de la matriz
    mov     rsi, matriz
    mov     rax, 0
fila_loop:
    ; Si estamos en la fila central, imprimir la barra izquierda
    cmp     rax, 2
    je      imprimir_barra_izquierda


imprimir_barra_izquierda:
    ; Imprimir la barra izquierda
    sub     rsp, 8
    mov     rdi, format_space
    call    printf
    add     rsp, 8

    ; Bucle para recorrer las columnas de la matriz
    mov     rcx, 7
    columna_loop:
        ; Imprimir el elemento de la matriz
        movzx   rdi, byte [rsi]
        sub     rsp, 8
        push    rdi
        push    format_elemento
        call    printf
        add     rsp, 16  ; Ajuste de la pila para dos parámetros push
        ; Incrementar el puntero a la siguiente columna
        inc     rsi

        ; Si estamos en la columna central, imprimir la barra vertical
        cmp     rcx, 4
        je      imprimir_barra_vertical

        ; Imprimir la parte derecha de la columna
        sub     rsp, 8
        mov     rdi, format_space
        call    printf
        add     rsp, 8

        ; Salto al siguiente elemento de la fila
        dec     rcx
        jmp     siguiente_elemento

imprimir_barra_vertical:
    ; Imprimir la barra vertical
    sub     rsp, 8
    mov     rdi, format_space
    call    printf
    add     rsp, 8

siguiente_elemento:
    ; Salto al siguiente elemento de la fila
    dec     rcx
    jnz     columna_loop

    ; Si estamos en la fila central, imprimir la barra derecha
    cmp     rax, 2
    je      imprimir_barra_derecha

    ; Imprimir la parte derecha de la fila
    sub     rsp, 8
    mov     rdi, format_space
    call    printf
    add     rsp, 8

imprimir_barra_derecha:
    ; Imprimir la barra derecha
    sub     rsp, 8
    mov     rdi, format_space
    call    printf
    add     rsp, 8

    ; Si estamos en la fila central, imprimir la parte inferior de la matriz
    cmp     rax, 2
    je      imprimir_parte_inferior

    ; Imprimir una nueva línea al final de cada fila
    sub     rsp, 8
    mov     rdi, format_newline
    call    printf
    add     rsp, 8

    ; Salto a la siguiente fila de la matriz
    inc     rax
    cmp     rax, 5
    jl      fila_loop

    ; Imprimir una nueva línea al final de la matriz
    sub     rsp, 8
    mov     rdi, format_newline
    call    printf
    add     rsp, 8

    add     rsp, 8
    ret

imprimir_parte_inferior:
    ; Imprimir la parte inferior de la matriz
    sub     rsp, 8
    mov     rdi, format_space
    call    printf
    add     rsp, 8

    ret