%define ZORRO_FIL_INICIAL 3
%define ZORRO_COL_INICIAL 4


;   MINI CLI PARA PROBAR MOVIMIENTOS DE ZORRO


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

%macro mGetchar 0
    sub     rsp,8
    call    getchar
    add     rsp,8
%endmacro

%macro limpiarConsola 0
    mov     rdi, cmd_clear
    sub     rsp, 8
    call    system
    add     rsp, 8
%endmacro


extern printf
extern scanf
extern getchar
extern system
extern mover_zorro
extern verificar_estado_juego
global main

extern definir_matriz
extern inicializar_juego
extern imprimir_tablero
global main


section .data
    zorro_ocas_capturadas dd 0   
    zorro_comio_suficientes_ocas db 0          ;   ;   datos lógica zorro
    ;turno_del_zorro db 1             ;mal nombre habia conflicto
    print_start db "El zorro comienza en la fila %i y en la columna %i y está ayunado", 10, 0
    print_posicion db "El zorro está en la fila %i y en la columna %i. Comió %i ocas", 10, 0
    mensaje_movimiento db "che, dame un movimiento:", 10, 0
    formato_movimiento db " %c", 0
    captura_reciente dd 0
    cmd_clear db "clear", 0
    ; estos cuatro mensajes se combinan en ERROR (pero se muestran en mover)
    ;mensaje_input_erroneo db "che, metiste cualquiera", 10, 0
    ;mensaje_mov_erroneo db "nono, esa letra no sirve", 10, 0
    ;mensaje_limites db "cagaste, estas afuera", 10, 0
    ;mensaje_sin_capturar db "te cagaste de hambre", 10, 0
    ;
    mensaje_error db "bueno: metiste cualquiera, o una letra que no sirve, o saliste del tablero, o no comiste nada", 10, 0
    mensaje_exito db "termino el movimiento todo joya", 10, 0
    mensaje_vivo db "te avivaste pero no funciona", 10, 0
    mensaje_captura db "devoraste", 10, 0
    mensaje_salida db "saliste querido", 10, 0
    aviso_victoria db "somos campeones", 10, 0
    aviso_derrota db "era por abajo", 10, 0           


    estado_juego dd 0
    bienvenida db 10, 10, 10, 32, 32, 32, 32, "¡Bienvenidxs al Juego de la Oca!", 10, 32, 32, 32, 32, "Si el zorro come 12 ocas gana (?", 10, 10, 10, 0
    instrucciones db "\n\n\tInstrucciones de juego (masomenos):\n\n \
        Con la letra (A)  -->  Te movés a la IZQUIERDA. \n \
        Con la letra (D)  -->  Te movés a la DERECHA.   \n \
        Con la letra (W)  -->  Te movés hacia ARRIBA.   \n \
        Con la letra (S)  -->  Te movés hacia ABAJO.   \n \
        Con la letra (Q)  -->  Te movés hacia ARRIBA IZQUIERDA.   \n \
        Con la letra (E)  -->  Te movés hacia ARRIBA DERECHA.   \n \
        Con la letra (Z)  -->  Te movés hacia ABAJO IZQUIERDA.   \n \
        Con la letra (X)  -->  Te movés hacia ABAJO DERECHA.   \n\n\n\n", 0
    mensaje_victoria_zorro db "Ganó el zorrooooo"
    mensaje_victoria_ocas db "Ganaron las ocasssss"               ;


section .bss
    zorro_fila resd 1
    zorro_columna resd 1
    ocas_capturadas resd 1
    gano_zorro resb 1
    movimiento resb 1
    es_turno_del_zorro resb 1
    string_basura resb 50


section .text
main:
    sub rsp, 8
    call imprimir_tablero 
    add rsp, 8

    sub rsp, 8
    call inicializar_juego
    add rsp, 8
    mov dword [zorro_fila], edi
    mov dword [zorro_columna], esi
    mov dword [zorro_ocas_capturadas], edx
    mov byte [zorro_comio_suficientes_ocas], cl
    mov byte [es_turno_del_zorro], ch

inicializar:
    mov dword [zorro_fila], ZORRO_FIL_INICIAL
    mov dword [zorro_columna], ZORRO_COL_INICIAL
    mov rdi, print_start
    mov rsi, [zorro_fila]
    mov rdx, [zorro_columna]
    mPrintf
    jmp pedir_movimiento

loop_juego:
    ; pa que no haga loop infinito
    jmp terminar_juego
    ;sub rsp, 8
    ;call definir_matriz ;aca llamariamos a una funcion que pregunte que tablero quiera?
    ;add rsp, 8
    sub rsp, 8
    call imprimir_tablero
    add rsp, 8

    ; ...después de un movimiento
    cmp dword [estado_juego], 0
    jg victoria_zorro
    jl victoria_ocas
    je loop_juego
imprimir_posicion:
    ; COMPLETAR PRINT DE ZORRO CON: OCAS_CAPTURADAS
    mov rdi, print_posicion
    mov rsi, [zorro_fila]
    mov rdx, [zorro_columna]
    mov rcx, [zorro_ocas_capturadas]
    ret
pedir_movimiento:

    ;limpiarConsola
    ; ACÁ SE LIMPIARÍA LA TERMINAL

    call imprimir_posicion
    mPrintf
    lea rdi, [rel mensaje_movimiento]
    mPrintf
    mov rdi, formato_movimiento
    mov rsi, movimiento
    mScanf
descartar_sobra_input:
    mGetchar
    cmp rax, 10
    jne descartar_sobra_input
mover:
    mov dil, [movimiento]
    mov esi, [zorro_fila]
    mov edx, [zorro_columna]
    mov ecx, [captura_reciente]
    sub rsp, 8
    call mover_zorro
    add rsp, 8
    cmp rax, 0
    jg error
    jl salir
    jmp movimiento_exitoso
movimiento_exitoso:
    mov [zorro_fila], edi
    mov [zorro_columna], esi
    mov [captura_reciente], edx
    ; chequeo si el zorro acaba de comer
    cmp dword [captura_reciente], 0
    jne imprimir_captura


    mov edi, [zorro_ocas_capturadas]
    mov esi, [zorro_fila]
    mov edx, [zorro_columna]
    sub rsp, 8
    call verificar_estado_juego
    add rsp, 8
    cmp rax, 0
    jg ganaste
    jl perdiste


    lea rdi, [rel mensaje_exito]
    mPrintf
    ;jmp terminar_turno
    jmp pedir_movimiento
error:
    mov [captura_reciente], edi
    lea rdi, [rel mensaje_error]
    mPrintf
    cmp dword [captura_reciente], 0
    jl imprimir_viveza
    jmp pedir_movimiento
imprimir_captura:
    lea rdi, [rel mensaje_captura]
    mPrintf
    inc dword [zorro_ocas_capturadas]

    mov edi, [zorro_ocas_capturadas]
    mov esi, [zorro_fila]
    mov edx, [zorro_columna]
    sub rsp, 8
    call verificar_estado_juego
    add rsp, 8
    cmp rax, 0
    jg ganaste
    jl perdiste


    jmp pedir_movimiento
imprimir_viveza:
    lea rdi, [rel mensaje_vivo]
    mPrintf
    jmp terminar_turno
terminar_turno:
    ret
salir:
    lea rdi, [rel mensaje_salida]
    mPrintf
    ret
ganaste:
    lea rdi, [rel aviso_victoria]
    mPrintf
    ret
perdiste:
    lea rdi, [rel aviso_derrota]
    mPrintf
    ret

victoria_zorro:
    mov rdi, mensaje_victoria_ocas
    mPrintf
    jmp terminar_juego

victoria_ocas:
    mov rdi, mensaje_victoria_zorro
    mPrintf
    jmp terminar_juego

terminar_juego:
    ret


   