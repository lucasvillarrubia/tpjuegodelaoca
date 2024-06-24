
; NO SÉ CÓMO DEVOLVER LAS POSICIONES DE LAS OCAAAAAAAAAS


global inicializar_juego
extern inicializar_zorro

section .data
    zorro_comio_suficientes_ocas db 0   
    zorro_ocas_capturadas db 0

section .bss
    zorro_fila resd 1
    zorro_columna resd 1
    ocas_capturadas resd 1
    gano_zorro resb 1
    es_turno_del_zorro resb 1


section .text
inicializar_juego:
    ;aca va a llamarse inicializar ocas
    ;
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