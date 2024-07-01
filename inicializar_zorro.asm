%define ARRIBA 'W'
%define IZQUIERDA 'A'
%define ABAJO 'X'
%define DERECHA 'D'

%define ZORRO_FIL_INICIAL_ARRIBA    5
%define ZORRO_COL_INICIAL_ARRIBA    4

%define ZORRO_FIL_INICIAL_ABAJO     3
%define ZORRO_COL_INICIAL_ABAJO     4

%define ZORRO_FIL_INICIAL_IZQUIERDA 4
%define ZORRO_COL_INICIAL_IZQUIERDA 5

%define ZORRO_FIL_INICIAL_DERECHA   4
%define ZORRO_COL_INICIAL_DERECHA   3

%define OCAS_CAPTURADAS_INICIALMENTE 0

%define ZORRO_FIL_INICIAL 3
%define ZORRO_COL_INICIAL 4

;
; Pre:
; (rdi, rsi, rdx, rcx, r8)
; (fila_zorro: rdi, columna_zorro: rsi, ocas_capturadas: rdx, orientacion: cl, zorro_ocas_capturadas: r8)
; Necesita recibir una orientacion: W, A, X o D. La orientacion default es W.
;
; Post:
; INICIALIZA LAS VARIABLES RECIBIDAS Y DEVUELVE LOS SIGUIENTES CAMPOS
; - bool comio_suficientes_ocas             cl
; - bool es_turno_del_zorro                 ch


%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro


extern printf
global inicializar_zorro


section .data
    zorro_ocas_capturadas dd 0
    zorro_comio_suficientes_ocas db 0           ;   } datos lógica zorro para devolver
    es_turno_del_zorro db 1                     ;       <----     no sé si es correcto que esto del turno esté acá pero así lo había codeado en C (?
    print_posicion db "El zorro está en la fila %i y en la columna %i. Comió %i ocas", 10, 0
    
    
section .bss
    zorro_fila resd 1
    zorro_columna resd 1
    orientacion_zorro resb 1


section .text
inicializar_zorro:
inicializar:
    mov [orientacion_zorro], cl
posicionar_zorro_segun_orientacion:
    cmp     cl, ABAJO
    je      ubicar_zorro_para_tablero_hacia_abajo
    cmp     cl, IZQUIERDA
    je      ubicar_zorro_para_tablero_hacia_izquierda
    cmp     cl, DERECHA
    je      ubicar_zorro_para_tablero_hacia_derecha
    jmp     ubicar_zorro_para_tablero_hacia_arriba

ubicar_zorro_para_tablero_hacia_arriba:
    mov dword [zorro_fila], ZORRO_FIL_INICIAL_ARRIBA
    mov dword [zorro_columna], ZORRO_COL_INICIAL_ARRIBA
    jmp devolver_cosas_zorro

ubicar_zorro_para_tablero_hacia_abajo:
    mov dword [zorro_fila], ZORRO_FIL_INICIAL_ABAJO
    mov dword [zorro_columna], ZORRO_COL_INICIAL_ABAJO
    jmp devolver_cosas_zorro

ubicar_zorro_para_tablero_hacia_izquierda:
    mov dword [zorro_fila], ZORRO_FIL_INICIAL_IZQUIERDA
    mov dword[zorro_columna], ZORRO_COL_INICIAL_IZQUIERDA
    jmp devolver_cosas_zorro
ubicar_zorro_para_tablero_hacia_derecha:
    mov dword [zorro_fila], ZORRO_FIL_INICIAL_DERECHA
    mov dword [zorro_columna], ZORRO_COL_INICIAL_DERECHA
    jmp devolver_cosas_zorro

devolver_cosas_zorro:
    mov edi, dword [zorro_fila]
    mov esi, dword [zorro_columna]
    mov edx, dword [zorro_ocas_capturadas]
    mov cl, byte [zorro_comio_suficientes_ocas]
    mov ch, byte [es_turno_del_zorro]

    ret

