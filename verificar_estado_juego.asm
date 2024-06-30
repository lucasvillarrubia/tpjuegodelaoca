%define CANT_OCAS_PARA_GANAR 12

;
; ACÁ SE LLEGA DE DOS FORMAS:
; - EL ZORRO SE ACABA DE MOVER (SE VERIFICA SI PERDIÓ O NO)
; - EL ZORRO ACABA DE COMER UNA OCA (SE VERIFICA SI GANÓ O NO, DESPUÉS SI PERDIÓ)
;


extern mover_zorro
global verificar_estado_juego


section .data
    movimientos_posibles db 65, 87, 68, 83, 81, 69, 90, 88 ; 'A', 'W', 'D', 'S', 'Q', 'E', 'Z', 'X'

    ; ESTO NO SE USA PARA NADA PERO LO PUSE PARA QUE NO CORROMPA OTRA MEMORIA, POR AHORA MOVER_ZORRO RECIBE LOS CONTADORES EN R8
    contadores_zorro times 8 dd 0

section .bss
    ocas_capturadas resd 1
    fila resd 1
    columna resd 1
    verificador_vector_ocas resq 1
    verificador_tope_ocas resq 1


section .text
verificar_estado_juego:
    mov [ocas_capturadas], edi
    mov [fila], esi
    mov [columna], edx
    mov [verificador_vector_ocas], r11 ; le paso el puntero al vector de ocas
    mov [verificador_tope_ocas], rbx
victoria_zorro:
    cmp dword [ocas_capturadas], CANT_OCAS_PARA_GANAR
    jnge derrota_zorro
    mov rax, 1
    ret
derrota_zorro:

;falta condicional
;loop que verifique las coordenadas contiguas a la posición actual y verifica:
; - si alguna de las contiguas está dentro del tablero y no tiene una oca, NO pierde
;el segundo loop debería verificar las posiciones "segundas" (posibles casillas disponibles después de capturar una oca)
; - si todas las contiguas no están disponibles, con que alguna segunda lo esté, NO pierde
;|
;|------------> en otras palabras: si se puede mover, no pierde jsdnssjd

    mov rbx, movimientos_posibles
    mov r9, 0

chequear_movimientos:

    mov dil, byte [rbx + r9]
    mov esi, [fila]
    mov edx, [columna]
    mov ecx, 0
    mov r8, contadores_zorro
    lea r11, [verificador_vector_ocas] ; le paso el puntero al vector de ocas
    lea rbx, [verificador_tope_ocas]
    mov r10, 1
    sub rsp, 8
    call mover_zorro
    add rsp, 8

    ; si se mueve exitosamente, recibe el código de salida de mover_zorro (-1)
    cmp rax, -1

    je aqui_no_paso_nada_caballeros
    add r9, 1
    cmp r9, 8
    jnge chequear_movimientos

    mov rax, -1
    ret
aqui_no_paso_nada_caballeros:
    mov rax, 0
    ret

