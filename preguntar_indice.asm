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
    formato_coordenada db "%d", 0
    mensaje_error db "mal int ", 10, 0

section .bss
    auxiliar_fila resb 4
    auxiliar_columna resb 4
    buffer_fila resb 10
    buffer_columna resb 10
    

section .text
global preguntar_indice

preguntar_indice:

    lea rdi, [rel mensaje_indice_fil]
    mPrintf

    mov rdi, formato_coordenada
    mov rsi, auxiliar_fila 
    mScanf

    lea rdi, [auxiliar_fila]
    call validar_entero
    test rax, rax
    mov [auxiliar_fila], eax

    lea rdi, [rel mensaje_indice_col]
    mPrintf

    mov rdi, formato_coordenada
    mov rsi, auxiliar_columna
    mScanf

    ; Convertir y validar indice de columna
    lea rdi, [auxiliar_columna]
    call validar_entero
    test rax, rax
    mov [auxiliar_columna], eax

ret

validar_entero:
    
