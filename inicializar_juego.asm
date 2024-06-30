

; NO SÉ CÓMO DEVOLVER LAS POSICIONES DE LAS OCAAAAAAAAAS

;contantes para oca
%define ARRIBA 'W'
%define IZQUIERDA 'A'
%define ABAJO 'S'
%define DERECHA 'D'
%define CANT_OCAS 17
%define TAMAÑO_OCA 2


global inicializar_juego

global inicializar_sin_partida_guardada
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
    fila_zorro                      resd 1
    columna_zorro                   resd 1
    zorro_ocas_capturadas_memoria   resb 1 

    mi_puntero_vector_ocas                  resq 1
    mi_puntero_movimientos_validos          resq 1
    mi_puntero_tope_ocas                    resq 1
    mi_copia_orientacion                    resb 1


section .text

; (rdi, rsi, rdx, rcx)
; pre: (vector_ocas: rdi, movimientos_validos: rsi, tope_ocas: rdx, orientacion: cl)
inicializar_juego:
    mov [mi_puntero_vector_ocas], rdi
    mov [mi_puntero_movimientos_validos], rsi
    mov [mi_puntero_tope_ocas], rdx
    mov [mi_copia_orientacion], cl

inicializar_sin_partida_guardada:
    
    ;sub rsp, 8
    ;call definir_matriz ;aca llamariamos a una funcion que pregunte que tablero quiera?
    ;add rsp, 8
    ;
    mov     rdi, [mi_puntero_vector_ocas]
    mov     rsi, [mi_puntero_movimientos_validos] ; uso un vector de movimientos para saber cual es el valido, talvez pueda servir mas
                                       ; cuando rotemos la matriz y las ocas tengan un movimiento no disponible
    mov     rdx, [mi_puntero_tope_ocas]
    mov     cl, [mi_copia_orientacion] ; LA ORIENTACION PEDIDA ESTA HARDCODEADA, ESTO ME LO DEBERIAN PASAR
    call    inicializar_ocas
    mov     rdi, [mi_puntero_movimientos_validos]
    mov     al, byte[rdi]
    mov     al, byte[rdi + 1]
    mov     al, byte[rdi+ 2]
    mov     al, byte[rdi+ 3]
    ; mov     rdi, [mi_puntero_tope_ocas]
    ; mov     cl, [rdi]
    ; mov     cl, [mi_puntero_tope_ocas]
    ; mov     rdi, [mi_puntero_vector_ocas]

    ; mov     cl, [rdi]
    ; mov     cl, [rdi + 1]


    mov cl, [mi_copia_orientacion]

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
