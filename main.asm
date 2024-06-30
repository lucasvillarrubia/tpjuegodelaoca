%define ARRIBA 'W'
%define IZQUIERDA 'A'
%define ABAJO 'S'
%define DERECHA 'D'
%define CANT_OCAS 17
%define TAMAÑO_OCA 2

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


;parte imprimir terreno y zorro
extern printf
extern scanf
extern getchar
extern system
extern mover_zorro
extern verificar_estado_juego

extern inicializar_juego
extern imprimir_tablero

;parte de ocas
extern buscar_indice_de_oca
extern mover_oca
extern eliminar_oca

extern preguntar_orientacion


global main


section .data
    zorro_ocas_capturadas dd 0   
    zorro_comio_suficientes_ocas db 0          ;   ;   datos lógica zorro
    print_start db "El zorro comienza en la fila %i y en la columna %i y está ayunado", 10, 0
    print_posicion db "El zorro está en la fila %i y en la columna %i. Comió %i ocas", 10, 0
    mensaje_movimiento db "che, dame un movimiento:", 10, 0
    mensaje_indice db "ingrese las coordenadas de la oca que quiere mover:", 10, 0
    formato_movimiento db " %c", 0
    formato_coordenada db " %i%i", 0
    captura_reciente dd 0
    cmd_clear db "clear", 0
    mensaje_error db "bueno: metiste cualquiera, o una letra que no sirve, o saliste del tablero, o no comiste nada", 10, 0
    mensaje_exito db "termino el movimiento todo joya", 10, 0
    mensaje_vivo db "te avivaste pero no funciona", 10, 0
    mensaje_captura db "devoraste", 10, 0
    mensaje_salida db "saliste querido", 10, 0
    aviso_victoria db "somos campeones", 10, 0
    aviso_derrota db "era por abajo", 10, 0           


    estado_juego dd 0
    mensaje_victoria_zorro db "Ganó el zorrooooo"
    mensaje_victoria_ocas db "Ganaron las ocasssss"               ;

    contadores_zorro times 8 dd 0
    formato_numero db "%i", 10, 0
    est_derecha db "Los movimientos realizados a la derecha fueron: %i", 10, 0
    est_izquierda db "Los movimientos realizados a la izquierda fueron: %i", 10, 0
    est_abajo db "Los movimientos realizados a abajo fueron: %i", 10, 0
    est_arriba db "Los movimientos realizados a arriba fueron: %i", 10, 0
    est_ab_der db "Los movimientos realizados a abajo a la derecha fueron: %i", 10, 0
    est_ab_izq db "Los movimientos realizados a abajo a la izquierda fueron: %i", 10, 0
    est_arr_der db "Los movimientos realizados a arriba a la derecha fueron: %i", 10, 0
    est_arr_izq db "Los movimientos realizados a arriba a la iquierda fueron: %i", 10, 0


    bienvenida db 10, 10, 10, "¡Bienvenidxs al Juego de la Oca!", 10, "Quien ganara?? Si el zorro come todas las ocas gana pero si queda acorralado, las ocas ganan ", 10, 0

    instruccionesZ db 10, "Instrucciones de como realizar un movimiento: ", 10, \
        "Con la letra (A)  -->  Te movés a la IZQUIERDA.", 10, \
        "Con la letra (D)  -->  Te movés a la DERECHA.", 10, \
        "Con la letra (W)  -->  Te movés hacia ARRIBA.", 10, \
        "Con la letra (S)  -->  Te movés hacia ABAJO.", 10, \
        "Con la letra (Q)  -->  Te movés hacia ARRIBA IZQUIERDA.", 10, \
        "Con la letra (E)  -->  Te movés hacia ARRIBA DERECHA.", 10, \
        "Con la letra (Z)  -->  Te movés hacia ABAJO IZQUIERDA.", 10, \
        "Con la letra (X)  -->  Te movés hacia ABAJO DERECHA.", 10, 0

    instruccionesO db 10, "Aclaraciones de las ocas : ", 10, \
        "Ingrese por pantalla la coordenada de la oca que desea mover y luego realize su movimiento", 10,10, 10, 0

    turno_oca db 10, "Ahora es el turno de las ocas ", 10
    turno_zorro db 10, "Es el turno del zorro ", 10
       


section .bss
    gano_zorro resb 1
    es_turno_del_zorro resb 1
    orientacion                 resb 1

    ;seccion zorro
    zorro_fila resd 1
    zorro_columna resd 1
    movimiento resb 1
    string_basura resb 50

    ;seccion ocas
    auxiliar_fila               resb 1
    auxiliar_columna            resb 1
    vector_ocas                 times CANT_OCAS resb TAMAÑO_OCA
    tope_ocas                   resb 1
    movimientos_validos         times 3 resb 1
    indice_de_oca               resb 1


section .text
main:
    mov rdi, bienvenida
    mPrintf

inicializar:
    sub rsp, 8
    call preguntar_orientacion
    add rsp, 8

    mov [orientacion], rax
    lea rdi, [vector_ocas]
    lea rsi, [movimientos_validos]
    lea rdx, [tope_ocas]
    mov cl,  [orientacion] ; es una letra W, A, X o D
    sub rsp, 8
    call inicializar_juego
    add rsp, 8
    
    mov dword [zorro_fila], edi
    mov dword [zorro_columna], esi
    mov dword [zorro_ocas_capturadas], edx
    mov byte [zorro_comio_suficientes_ocas], cl
    mov byte [es_turno_del_zorro], ch

loop_juego:

    mov rdi, instruccionesZ
    mPrintf

    mov rdi, instruccionesO
    mPrintf

loop_zorro:
    mov rdi, turno_zorro
    mPrintf

    mov edi, [zorro_fila]
    mov esi, [zorro_columna]
    lea rdx, [vector_ocas] ; le paso el puntero al vector de ocas
    mov cl,  [tope_ocas]
    sub rsp, 8
    call imprimir_tablero
    add rsp, 8

    jmp pedir_movimientoZ


loop_oca:
    limpiarConsola
    mov rdi, turno_oca
    mPrintf

    mov edi, [zorro_fila]
    mov esi, [zorro_columna]
    lea rdx, [vector_ocas] ; le paso el puntero al vector de ocas
    mov cl,  [tope_ocas]
    sub rsp, 8
    call imprimir_tablero
    add rsp, 8

    jmp pedir_indice

chequear_estado:
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


pedir_movimientoZ:
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
moverZ:
    ;limpiarConsola
    mov dil, [movimiento]
    mov esi, [zorro_fila]
    mov edx, [zorro_columna]
    mov ecx, [captura_reciente]
    mov r8, contadores_zorro

    ;  la única manera que pensé para que mover_zorro distinga entre un movimiento real y uno que no modifique la posición (?
    mov r10, 0
    
    lea r11, [vector_ocas] ; le paso el puntero al vector de ocas
    mov bl,  [tope_ocas]
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
    jne imprimir_captura_zorro


    ;mov edi, [zorro_ocas_capturadas]
    ;mov esi, [zorro_fila]
    ;mov edx, [zorro_columna]
    ;sub rsp, 8
    ;call verificar_estado_juego
    ;add rsp, 8
    ;cmp rax, 0
    ;jg ganaste
    ;jl perdiste


    lea rdi, [rel mensaje_exito]
    mPrintf
    jmp loop_oca

pedir_indice:
    lea rdi, [rel mensaje_indice]
    mPrintf
    mov rdi, formato_coordenada
    mov rsi, auxiliar_fila 
    mov rdx, auxiliar_columna
    mScanf
 
    mov rdi, [vector_ocas]
    mov r8,  [tope_ocas]
    mov dl,  [auxiliar_fila]
    mov cl,  [auxiliar_columna]
    call buscar_indice_de_oca
    mov [indice_de_oca] , rax

pedir_movimientoO:
    lea rdi, [rel mensaje_movimiento]
    mPrintf
    mov rdi, formato_movimiento
    mov rsi, movimiento
    mScanf
descartar_sobra_input_oca:
    mGetchar
    cmp rax, 10
    jne descartar_sobra_input_oca

moverO:
    mov sil, [movimiento]
    mov rdi, [vector_ocas]
    mov dl, [zorro_fila]
    mov cl, [zorro_columna]
    mov r8, [indice_de_oca]
    mov r8, [tope_ocas]
    mov r10, [movimientos_validos]

    sub rsp, 8
    call mover_oca
    add rsp, 8
    cmp rax, 0
    jg error
    jl salir
    jmp pedir_movimientoO


movimiento_exitoso_oca:
    jmp loop_juego


error:
    limpiarConsola ;limpiarConsola
    mov [captura_reciente], edi
    lea rdi, [rel mensaje_error]
    mPrintf
    cmp dword [captura_reciente], 0
    jl imprimir_viveza
    jmp loop_juego

imprimir_captura_zorro:
    lea rdi, [rel mensaje_captura]
    mPrintf
    inc dword [zorro_ocas_capturadas]

    ;mov edi, [zorro_ocas_capturadas]
    ;mov esi, [zorro_fila]
    ;mov edx, [zorro_columna]
    ;sub rsp, 8
    ;call verificar_estado_juego
    ;add rsp, 8
    ;cmp rax, 0
    ;jg ganaste
    ;jl perdiste
    jmp loop_oca


imprimir_viveza:
    lea rdi, [rel mensaje_vivo]
    mPrintf
    jmp terminar_turno
terminar_turno:
    ret
salir:
    ;guardar partida actual
    lea rdi, [rel mensaje_salida]
    mPrintf
    ret
ganaste:
    lea rdi, [rel aviso_victoria]
    mPrintf
    jmp terminar_juego
    ;ret
perdiste:
    lea rdi, [rel aviso_derrota]
    mPrintf
    ret

victoria_zorro:
    mov rdi, mensaje_victoria_zorro
    mPrintf
    jmp terminar_juego

victoria_ocas:
    mov rdi, mensaje_victoria_ocas
    mPrintf
    jmp terminar_juego

terminar_juego:
    
    ;mov rbx, 0

imprimir_contadores:

    imprimir_izquierda: 
        mov rdi, est_izquierda
        mov rsi, [contadores_zorro]
        mPrintf
    imprimir_derecha:
        mov rdi, est_derecha
        mov rsi, [contadores_zorro + 4]
        mPrintf
    imprimir_arriba:
        mov rdi, est_arriba
        mov rsi, [contadores_zorro + 8]
        mPrintf
    imprimir_abajo:
        mov rdi, est_abajo
        mov rsi, [contadores_zorro + 12]
        mPrintf
    imprimir_arr_izq:
        mov rdi, est_arr_izq
        mov rsi, [contadores_zorro + 16]
        mPrintf
    imprimir_arr_der:
        mov rdi, est_arr_der
        mov rsi, [contadores_zorro + 20]
        mPrintf
    imprimir_ab_izq:
        mov rdi, est_ab_izq
        mov rsi, [contadores_zorro + 24]
        mPrintf
    imprimir_ab_der:
        mov rdi, est_ab_der
        mov rsi, [contadores_zorro + 28]
        mPrintf
        ;add rbx, 4
        ;cmp rbx, 32
            
        ;jne imprimir_contadores
    ret


   

