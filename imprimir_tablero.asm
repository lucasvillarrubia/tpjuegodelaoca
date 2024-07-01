
%define MAX_FILAS 7
%define MAX_COLUMNAS 7
%define MAX_CASILLEROS 49


%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

extern buscar_indice_de_oca
extern printf
global main
global imprimir_tablero

section .data

    long_elemento       dd 1
    long_fila           dd 7
    espacio             db 32   ; ' '
    vacio               db 45   ; '-'
    puntero_matriz      dd 0
    format_newline db 10, 10, 10, 0        ; Carácter de nueva línea para imprimir al final de cada fila
    un_par_de_espacios db 32, 32, 32, 32, 32, 0

section .bss
    matriz         times MAX_CASILLEROS             resb 1
    casillero                                       resw 1
    caracter                                        resb 1
    pos_fila                                        resd 1
    pos_columna                                     resd 1
    zorrito_fila                                    resd 1
    zorrito_columna                                 resd 1

    mi_puntero_vector_ocas                          resq 1
    mi_tope_ocas                                    resb 1

    zorro                                           resb 1
    oca                                             resb 1


section .text
    
imprimir_tablero:


    mov dword [zorrito_fila], edi
    mov dword [zorrito_columna], esi
    mov [mi_puntero_vector_ocas], rdx
    mov [mi_tope_ocas], cl
    mov byte [zorro], al
    mov byte [oca], bl
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
    mov r9, 0
    mov r9d, dword [zorrito_columna]
    cmp dword [pos_columna], r9d
    ;cmp dword [pos_columna], 3

    jne seguir_buscando

    mov r8, 0
    mov r8d, dword [zorrito_fila]
    cmp dword [pos_fila], r8d
    ;cmp dword [pos_fila], 4
    je rellenar_zorro
    seguir_buscando:

    mov rdi, [mi_puntero_vector_ocas]
    mov sil, [mi_tope_ocas]
    mov eax, [pos_fila]
    cdqe
    mov dl, al
    mov eax, [pos_columna]
    cdqe
    mov cl, al
    call buscar_indice_de_oca



    ; mov rax, 0
    cmp rax, 0
    jge rellenar_oca
    call esta_dentro_tablero
    ;mov rax, 1
    cmp rax, 0
    jne rellenar_fuera_de_tablero
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
    ;inc dword [puntero_matriz]
    add dword [puntero_matriz], 1
    mov edx, [pos_fila]
    dec edx
    imul edx, [long_fila]
    mov rax, 0
    add eax, edx
    mov edx, [pos_columna]
    dec edx
    imul edx, 1
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
    ;inc dword [pos_columna]
    add dword [pos_columna], 1
    ret
avanzar_fila:
    ;inc dword [pos_fila]
    add dword [pos_fila], 1
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

esta_dentro_tablero:
    mov rax, 0
    cmp dword [pos_fila], 1
    jl fuera_de_rango
    cmp dword [pos_fila], MAX_FILAS
    jg fuera_de_rango
    cmp dword [pos_columna], 1
    jl fuera_de_rango
    cmp dword [pos_columna], MAX_COLUMNAS
    jg fuera_de_rango
    cmp dword [pos_columna], 3
    jl chequear_esquinas
    cmp dword [pos_columna], 5
    jg chequear_esquinas
    ret
chequear_esquinas:
    cmp dword [pos_fila], 3
    jl fuera_de_rango
    cmp dword [pos_fila], 5
    jg fuera_de_rango
    ret
fuera_de_rango:
    mov rax, 1
    ret
    
