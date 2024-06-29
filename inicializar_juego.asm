
; NO SÉ CÓMO DEVOLVER LAS POSICIONES DE LAS OCAAAAAAAAAS

;contantes para oca
%define ARRIBA 'W'
%define IZQUIERDA 'A'
%define ABAJO 'S'
%define DERECHA 'D'
%define CANT_OCAS 17
%define TAMAÑO_OCA 2


global inicializar_juego
extern inicializar_zorro

;parte de ocas
extern inicializar_ocas

section .data
    zorro_comio_suficientes_ocas db 0   
    zorro_ocas_capturadas db 0

    nombre_archivo db "partida_guardada.bin",0
    modo db "rb",0
    

section .bss
    ;seccion zorro
    zorro_fila resd 1
    zorro_columna resd 1
    gano_zorro resb 1
    es_turno_del_zorro resb 1
    id_archivo resq 1

    ;seccion ocas
    fila_zorro                  resd 1
    columna_zorro               resd 1
    zorro_ocas_capturadas_memoria       resb 1 
    vector_ocas                 times CANT_OCAS resb TAMAÑO_OCA
    tope_ocas                   resb 1
    movimientos_validos         times 3 resb 1


section .text
inicializar_juego:
    
    ;si hay archivo con partida guardada: usarla. sin darle opcion a los jugadores pues DICTADURA
    ;mov rdi, nombre_archivo
    ;mov rsi, modo
    ;call fopen

    ;cmp rax, 0
    ;jle inicializar_sin_partida_guardada
    ;mov rax, qword[id_archivo]
    ;leer partida guardada

inicializar_sin_partida_guardada:
    
    ;sub rsp, 8
    ;call definir_matriz ;aca llamariamos a una funcion que pregunte que tablero quiera?
    ;add rsp, 8
    ;

    lea     rdi, [vector_ocas]
    lea     rsi, [movimientos_validos] ; uso un vector de movimientos para saber cual es el valido, talvez pueda servir mas
                                       ; cuando rotemos la matriz y las ocas tengan un movimiento no disponible
    lea     rdx, [tope_ocas]
    mov     rcx, IZQUIERDA ; LA ORIENTACION PEDIDA ESTA HARDCODEADA, ESTO ME LO DEBERIAN PASAR
    call    inicializar_ocas

    
    sub rsp, 8
    call inicializar_zorro
    add rsp, 8
    mov dword [zorro_fila], edi
    mov dword [zorro_columna], esi
    mov dword [zorro_ocas_capturadas], edx
    mov byte [zorro_comio_suficientes_ocas], cl
    mov byte [es_turno_del_zorro], ch

    mov edi, [zorro_fila]
    mov esi, [zorro_columna]
    mov edx, [zorro_ocas_capturadas]
    mov cl, [zorro_comio_suficientes_ocas]
    mov ch, [es_turno_del_zorro]

    ret