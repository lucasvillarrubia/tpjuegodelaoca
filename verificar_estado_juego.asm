%define CANT_OCAS_PARA_GANAR 12

;
; ACÁ SE LLEGA DE DOS FORMAS:
; - EL ZORRO SE ACABA DE MOVER (SE VERIFICA SI PERDIÓ O NO)
; - EL ZORRO ACABA DE COMER UNA OCA (SE VERIFICA SI GANÓ O NO, DESPUÉS SI PERDIÓ)
;

global verificar


section .data

section .bss
    ocas_capturadas resd 1
    fila resd 1
    columna resd 1


section .text
verificar:
    mov [ocas_capturadas], edi
    mov [fila], esi
    mov [columna], edx
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
    jmp aqui_no_paso_nada_caballeros
    mov rax, -1
    ret
aqui_no_paso_nada_caballeros:
    mov rax, 0
    ret

