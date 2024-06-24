%define MAX_FILAS 7
%define MAX_COLUMNAS 7
%define MAX_CASILLEROS 49


%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro


extern printf
global main
global imprimir_tablero

section .data
    ; comienza en la primera casilla (1,1)
    ;pos_fila            dd 1
    ;pos_columna         dd 1

    long_elemento       dd 1
    long_fila           dd 7
    ;salto_de_linea      db 10   ; '\n'
    espacio             db 32   ; ' '
    zorro               db 90   ; 'Z'
    oca                 db 79   ; 'O'
    vacio               db 45   ; '-'
    ;max_casilleros      dd MAX_CASILLEROS
    puntero_matriz      dd 0
    ;formato_print       db "%s", 0

    ;format_elemento db "%2d ", 0   ; Formato para imprimir cada elemento de la matriz
    format_newline db 10, 10, 10, 0        ; Carácter de nueva línea para imprimir al final de cada fila
    ;format_space db "   ", 0       ; Espacio para rellenar en la parte superior e inferior de la matriz
    un_par_de_espacios db 32, 32, 32, 32, 32, 0

section .bss
    matriz         times MAX_CASILLEROS             resb 1
    casillero                                       resw 1
    caracter                                        resb 1
    pos_fila                                        resd 1
    pos_columna                                     resd 1
    zorrito_fila                                    resd 1
    zorrito_columna                                 resd 1


section .text
    
imprimir_tablero:


    mov dword [zorrito_fila], edi
    mov dword [zorrito_columna], esi
    call llenar_matriz
    call imprimir_tablero_nuevo
    ret


llenar_matriz:
    mov rcx, 0
    mov rcx, MAX_CASILLEROS
    mov dword [pos_fila], 1
    mov dword [pos_columna], 1
    mov dword [puntero_matriz], 0
rellenar_casillero:
    call buscar_contenido_casillero
    call ubicar_en_matriz
    call escribir_en_matriz
    call avanzar_posicion
    ;loop rellenar_casillero
    cmp dword [puntero_matriz], MAX_CASILLEROS
    jl rellenar_casillero
    ret


buscar_contenido_casillero:
    mov word [casillero], 0
    ; ESTÁ EL ZORRO AHÍ?
    ; qcy uso el rdx (????
    mov r8, 0
    mov r8d, dword [zorrito_fila]
    cmp dword [pos_fila], r8d
    ;cmp dword [pos_fila], 3
    jne rellenar_casillero_vacio
    mov r9, 0
    mov r9d, dword [zorrito_columna]
    cmp dword [pos_columna], r9d
    ;cmp dword [pos_columna], 4
    je rellenar_zorro
    ; HAY UNA OCA AHÍ?
    ; falta llamada a hay_una_oca
    mov rax, 1
    cmp rax, 0
    je rellenar_oca
    ; ESTÁ DENTRO DEL TABLERO?
    ; falta llamada a esta_dentro_rango
    mov rax, 1
    cmp rax, 0
    je rellenar_fuera_de_tablero
    ; CASO DEFAULT: CASILLERO VACÍO
    jmp rellenar_casillero_vacio
rellenar_zorro:
    mov al, [zorro]
    mov byte [casillero], al
    ret
rellenar_oca:
    mov al, [oca]
    mov byte [casillero], al
    ret
rellenar_fuera_de_tablero:
    mov al, [espacio]
    mov byte [casillero], al
    ret
rellenar_casillero_vacio:
    mov al, [vacio]
    mov byte [casillero], al
    ret


ubicar_en_matriz:
    mov rbx, 0
    mov rbx, matriz
    mov rdx, 0
    inc dword [puntero_matriz]
    mov edx, [pos_fila]
    dec edx
    imul edx, [long_fila]
    mov rax, 0
    add eax, edx
    mov edx, [pos_columna]
    dec edx
    imul edx, [long_elemento]
    add eax, edx
    add rbx, rax
    ret


escribir_en_matriz:
    mov al, [casillero]
    mov byte [rbx], al
    ret


avanzar_posicion:
avanzar_columna:
    cmp dword [pos_columna], MAX_COLUMNAS
    jge avanzar_fila
    inc dword [pos_columna]
    ret
avanzar_fila:
    inc dword [pos_fila]
    mov dword [pos_columna], 1
    ret


leer_de_matriz:
    mov rdx, 0
    mov rax, 0
    mov rdx, casillero
    mov al, byte [rbx]
    mov byte [rdx], al
    add rdx, 1
    mov byte [rdx], 0
    mov rdi, casillero
    mPrintf
    ; si se mueve de columna
    cmp dword [pos_columna], MAX_COLUMNAS
    je salto_de_linea
    mov rdi, un_par_de_espacios
    mPrintf
    ret
    ; si se mueve de fila
salto_de_linea:
    mov rdi, format_newline
    mPrintf
    ret


imprimir_tablero_nuevo:
    mov dword [pos_fila], 1
    mov dword [pos_columna], 1
    mov dword [puntero_matriz], 0
    mov rcx, 0
    mov rcx, MAX_CASILLEROS
imprimir_casillero:
    call ubicar_en_matriz
    call leer_de_matriz
    call avanzar_posicion
    ;loop imprimir_casillero
    cmp dword [puntero_matriz], MAX_CASILLEROS
    jl imprimir_casillero
    ret