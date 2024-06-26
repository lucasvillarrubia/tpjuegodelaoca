%define ZORRO_FIL_INICIAL 3
%define ZORRO_COL_INICIAL 4


;
; Pre: -
;
; Post:
; DEVUELVE LA POSICIÓN INICIAL DEL ZORRO, Y EL RESTO DE CAMPOS INICIALIZADOS:
; - int fila                                edi
; - int columna                             esi
; - int ocas_capturadas                     edx
; - bool comio_suficientes_ocas             cl
; - bool es_turno_del_zorro                 ch
;


%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro


extern printf
global inicializar_zorro


section .data
    zorro_ocas_capturadas dd 0                  ;
    zorro_comio_suficientes_ocas db 0           ;   } datos lógica zorro para devolver
    es_turno_del_zorro db 1                     ;       <----     no sé si es correcto que esto del turno esté acá pero así lo había codeado en C (?
    print_posicion db "El zorro está en la fila %i y en la columna %i. Comió %i ocas", 10, 0
    
    
section .bss
    zorro_fila resd 1
    zorro_columna resd 1


section .text
inicializar_zorro:
inicializar:
    mov dword [zorro_fila], ZORRO_FIL_INICIAL
    mov dword [zorro_columna], ZORRO_COL_INICIAL
    ;call imprimir_posicion
    ;mPrintf
    mov edi, [zorro_fila]
    mov esi, [zorro_columna]
    mov edx, [zorro_ocas_capturadas]
    mov cl, [zorro_comio_suficientes_ocas]
    mov ch, [es_turno_del_zorro]
    ret
imprimir_posicion:
    mov rdi, print_posicion
    mov rsi, [zorro_fila]
    mov rdx, [zorro_columna]
    mov rcx, [zorro_ocas_capturadas]
    ret