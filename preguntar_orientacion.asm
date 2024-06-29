section .bss
    caracter resb 1   

section .data
    mensaje_pedir db "Ingrese una orientación (A, W, X, D): ", 0
    mensaje_error db "Carácter inválido. Intente nuevamente.", 0
    formato_caracter db " %c", 0

section .text
    global preguntar_orientacion

%macro mScanf 0
    sub     rsp,8
    call    scanf
    add     rsp,8
%endmacro

%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro
extern printf
extern scanf

preguntar_orientacion:
    mov rdi, mensaje_pedir
    mPrintf

leer_caracter:
    mov rdi, formato_caracter
    mov rsi, caracter
    mScanf
    movzx rax, byte [caracter]

    ; Verificar si el carácter es válido (A, W, X, D)
    cmp rax, 'A'
    je caracter_valido
    cmp rax, 'W'
    je caracter_valido
    cmp rax, 'X'
    je caracter_valido
    cmp rax, 'D'
    je caracter_valido

    ; Si no es válido, mostrar mensaje de error y volver a pedir
    mov rdi, mensaje_error
    mPrintf
    jmp preguntar_orientacion

caracter_valido:
    ret