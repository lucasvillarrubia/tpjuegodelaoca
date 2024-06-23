
; NO SÉ CÓMO DEVOLVER LAS POSICIONES DE LAS OCAAAAAAAAAS


global inicializar_juego
extern inicializar_zorro


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
    ret
