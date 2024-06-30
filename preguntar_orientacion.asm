%define ZORRO_DEFAULT 'Z'
%define OCA_DEFAULT 'O'
%define ORIENTACION_DEFAULT 'W'


section .bss
    nueva_orientacion resb 1
    simbolo_zorro resb 1
    simbolo_ocas resb 1
    letra resb 1

section .data
    mensaje_personalizacion db "[GO AD-FREE] holis, querés personalizar tu juego? podés cambiar la orientación del tablero", 10, \
                                "y los símbolos de las piezas! ingresá (Y) para personalizar o cualquier otra letra para continuar", 10, \
                                "con la configuración predeterminada:", 10, 0
    mensaje_pedir_orientacion db "Ingrese una orientación de tablero (A, W, X, D): ", 10, 0
    mensaje_simbolo_zorro db "Ingrese con qué letra quiere representar al zorro:", 10, 0
    mensaje_simbolo_ocas db "Ingrese con qué letra quiere representar a las ocas:", 10, 0
    mensaje_error db "Carácter inválido. Intente nuevamente.", 10, 10, 0
    formato_caracter db " %c", 0
    zorro               db 90   ; 'Z'
    oca                 db 79   ; 'O'

section .text
    global personalizacion_usuario

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

%macro mGetchar 0
    sub     rsp,8
    call    getchar
    add     rsp,8
%endmacro


extern printf
extern scanf
extern getchar

personalizacion_usuario:
preguntar:
    lea rdi, [rel mensaje_personalizacion]
    mPrintf
    mov rdi, formato_caracter
    mov rsi, letra
    mScanf
descartar_stream_respuesta:
    mGetchar
    cmp rax, 10
    jne descartar_stream_respuesta
    call validar_letra
    cmp rax, 0
    je verificar_personalizacion
    lea rdi, [rel mensaje_error]
    mPrintf
    jmp preguntar
verificar_personalizacion:
    cmp byte [letra], 89 ; Y
    je comenzar_personalizacion
    cmp byte [letra], 121 ; y
    je comenzar_personalizacion
    jmp personalizacion_default
    

comenzar_personalizacion:
preguntar_orientacion:
    ;mov rdi, mensaje_pedir_orientacion
    ;mPrintf

;leer_caracter:
    ;mov rdi, formato_caracter
    ;mov rsi, letra
    ;mScanf
    ;movzx rax, byte [caracter]


    lea rdi, [rel mensaje_pedir_orientacion]
    mPrintf
    mov rdi, formato_caracter
    mov rsi, letra
    mScanf
    descartar_stream_orientacion:
    mGetchar
    cmp rax, 10
    jne descartar_stream_orientacion
    call validar_letra
    cmp rax, 0
    je verificar_orientacion
    lea rdi, [rel mensaje_error]
    mPrintf
    jmp preguntar_orientacion
verificar_orientacion:
    ; Verificar si el carácter es válido (A, W, X, D)
    cmp byte [letra], 65
    je guardar_orientacion
    cmp byte [letra], 87
    je guardar_orientacion
    cmp byte [letra], 88
    je guardar_orientacion
    cmp byte [letra], 68
    je guardar_orientacion
    cmp byte [letra], 97
    je guardar_orientacion
    cmp byte [letra], 119
    je guardar_orientacion
    cmp byte [letra], 120
    je guardar_orientacion
    cmp byte [letra], 100
    je guardar_orientacion
    ; Si no es válido, mostrar mensaje de error y volver a pedir
    lea rdi, [rel mensaje_error]
    mPrintf
    jmp preguntar_orientacion
guardar_orientacion:
    mov bl, byte [letra]
    mov byte [nueva_orientacion], bl
    jmp preguntar_simbolos


preguntar_simbolos:
preguntar_simbolo_zorro:
    lea rdi, [rel mensaje_simbolo_zorro]
    mPrintf
    mov rdi, formato_caracter
    mov rsi, letra
    mScanf
descartar_stream_zorro:
    mGetchar
    cmp rax, 10
    jne descartar_stream_zorro
    call validar_letra
    cmp rax, 0
    je guardar_zorro
    lea rdi, [rel mensaje_error]
    mPrintf
    jmp preguntar_simbolo_zorro
    guardar_zorro:
    mov bl, byte [letra]
    mov byte [simbolo_zorro], bl
    jmp preguntar_simbolo_ocas

preguntar_simbolo_ocas:
    lea rdi, [rel mensaje_simbolo_ocas]
    mPrintf
    mov rdi, formato_caracter
    mov rsi, letra
    mScanf
descartar_stream_ocas:
    mGetchar
    cmp rax, 10
    jne descartar_stream_ocas
    call validar_letra
    cmp rax, 0
    je guardar_oca
    lea rdi, [rel mensaje_error]
    mPrintf
    jmp preguntar_simbolo_ocas
    guardar_oca:
    mov bl, byte [letra]
    mov byte [simbolo_ocas], bl
    jmp terminar_personalizacion


validar_letra:
simbolo_es_minuscula:
    cmp byte [letra], 97
    jl simbolo_es_mayuscula
    cmp byte [letra], 122
    jg no_es_letra
    mov rax, 0
    ret
simbolo_es_mayuscula:
    cmp byte [letra], 65
    jl no_es_letra
    cmp byte [letra], 90
    jg no_es_letra
    mov rax, 0
    ret

no_es_letra:
    mov rax, 1
    ret



personalizacion_default:
    mov byte [simbolo_zorro], ZORRO_DEFAULT
    mov byte [simbolo_ocas], OCA_DEFAULT
    mov byte [nueva_orientacion], ORIENTACION_DEFAULT
    jmp terminar_personalizacion

terminar_personalizacion:
    mov al, byte [nueva_orientacion]
    mov bl, [simbolo_zorro]
    mov cl, [simbolo_ocas]
    ret