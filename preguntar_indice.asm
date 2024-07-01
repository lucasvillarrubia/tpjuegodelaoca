%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

%macro mScanf 0
    sub     rsp,8
    call    scanf
    add     rsp,8
%endmacro

extern printf
extern scanf

extern strtol

section .data
    mensaje_indice_fil db "Ingrese el indice de la fila: ", 0
    mensaje_indice_col db "Ingrese el indice de la columna: ", 0
    formato_coordenada db " %d", 0
    mensaje_error db "No se ingreso un numero int ", 10, 0
    dummy               db " %c", 0

section .bss
    puntero_auxiliar_fila_2 resq 1
    puntero_auxiliar_columna_2 resq 1
    fila_scanf resd 1
    columna_scanf resd 1

    buffer_fila resb 10
    buffer_columna resb 10
    

section .text
global preguntar_indice

preguntar_indice:
    mov [puntero_auxiliar_fila_2], rdi
    mov [puntero_auxiliar_columna_2], rsi

pedir_coordenadas:
    mov rsi, 0
    mov dword[fila_scanf], 0
    mov dword[columna_scanf], 0
    lea rdi, [rel mensaje_indice_fil]
    mPrintf
    mov rdi, formato_coordenada
    mov rsi, fila_scanf
    mScanf
    cmp rax, 0
    je  validar_entero
    mov eax, [fila_scanf]
    cdqe
    mov rbx, [puntero_auxiliar_fila_2]
    mov [rbx], al

    lea rdi, [rel mensaje_indice_col]
    mPrintf

    mov rdi, formato_coordenada
    mov rsi, columna_scanf
    mScanf
    cmp rax, 0
    je  validar_entero
    mov eax, [columna_scanf]
    cdqe
    mov rbx, [puntero_auxiliar_columna_2]
    mov [rbx], al
ret



validar_entero:
    lea rdi, [rel mensaje_error]
    mPrintf
    mov rdi, dummy
    mScanf
    jmp pedir_coordenadas

