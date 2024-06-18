section .data
    matriz  db ' ', ' ', 'O', 'O', 'O', ' ', ' ', 0
            db ' ', ' ', 'O', 'O', 'O', ' ', ' ', 0
            db 'O', 'O', 'O', 'O', 'O', 'O', 'O', 0
            db 'O', 'O', 'O', 'O', 'O', 'O', 'O', 0
            db 'O', 'O', 'O', 'O', 'O', 'O', 'O', 0
            db ' ', ' ', 'O', 'O', 'O', ' ', ' ', 0
            db ' ', ' ', 'O', 'O', 'O', ' ', ' ', 0

section .text
    global imprimir_tablero

imprimir_tablero:
    ; Alinear la pila
    push rbp
    mov rbp, rsp

    ; Configurar los registros necesarios
    mov rsi, matriz   ; rsi apunta al arreglo matriz
    mov rdi, 1        ; descriptor de archivo: stdout
    mov rax, 1        ; número de syscall para sys_write
    xor rcx, rcx      ; limpiar rcx (contador de bucle)

.loop_outer:
    mov rdx, 0        ; resetear rdx (contador de bytes)

.loop_inner:
    mov al, [rsi + rcx]  ; cargar byte de matriz en al
    test al, al        ; verificar si al es cero (fin de fila)
    jz .end_row        ; saltar a .end_row si al es cero

    add al, '0'        ; convertir byte a caracter ASCII
    mov [rsp], al      ; almacenar caracter ASCII en la pila (temporal)
    mov rdx, 1         ; número de bytes a escribir (1 byte)
    syscall            ; hacer syscall para escribir caracter

    inc rcx            ; mover al siguiente byte en matriz
    jmp .loop_inner    ; repetir bucle interno

.end_row:
    add rcx, 1         ; mover al inicio de la siguiente fila (omitir el cero terminador)
    cmp rcx, 56        ; verificar si todos los bytes (7 filas * 8 columnas)
    jl .loop_outer     ; saltar a .loop_outer si rcx es menor que 56

    ; Restaurar la pila
    mov rsp, rbp
    pop rbp

    ret
