%define CANT_OCAS_PARA_GANAR 12
%define MAX_FILAS 7
%define MAX_COLUMNAS 7

;
; ACÁ SE LLEGA DE DOS FORMAS:
; - EL ZORRO SE ACABA DE MOVER (SE VERIFICA SI PERDIÓ O NO)
; - EL ZORRO ACABA DE COMER UNA OCA (SE VERIFICA SI GANÓ O NO, DESPUÉS SI PERDIÓ)
;

extern printf
extern mover_zorro
extern buscar_indice_de_oca
global verificar_estado_juego


section .data
    movimientos_posibles db 65, 87, 68, 88, 81, 69, 90, 67 ; 'A', 'W', 'D', 'X', 'Q', 'E', 'Z', 'C'
    corte_loop          db 0



    


section .bss
    ocas_capturadas resd 1
    fila_original resd 1
    columna_original resd 1
    fila_verificar  resd 1
    columna_verificar resd 1
    verificar_mov resb 1
    ;ocass
    verificador_vector_ocas resq 1
    verificador_tope_ocas resb 1
    contador resq 1

section .text
verificar_estado_juego:
    mov [ocas_capturadas], edi
    mov [fila_original], esi
    mov [columna_original], edx
    mov [verificador_vector_ocas], r11 ; le paso el puntero al vector de ocas
    mov [verificador_tope_ocas], bl
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

    ;mov r12, movimientos_posibles
    mov qword [contador], 0
    

chequear_movimientos:
    mov byte[corte_loop], 0
    cmp qword [contador], 8
    jge zorro_acorralado
    mov r12, movimientos_posibles
    mov r9, qword [contador]
    mov dil, byte [r12 + r9]
    mov byte [verificar_mov], dil
    ; LLAMO A ES_MOV_VALIDO
    ; ESPERO 0 SI SE PUEDE MOVER
    ; ESPERO 1 SI QUEDA AFUERA DEL TABLERO
    ; ESPERO -1 SI PUEDE CAPTURAR
    call es_movimiento_valido
    cmp rax, 0
    je aqui_no_paso_nada_caballeros
    jl probar_captura
    add qword [contador], 1
    jmp chequear_movimientos


es_movimiento_valido:
    cmp byte [verificar_mov], 65 ;A
    je mov_izquierda
    cmp byte [verificar_mov], 68 ;D
    je mov_derecha
    cmp byte [verificar_mov], 87 ;W
    je mov_arriba
    cmp byte [verificar_mov], 88 ;X
    je mov_abajo
    cmp byte [verificar_mov], 81 ;Q
    je mov_arriba_izquierda
    cmp byte [verificar_mov], 69 ;E
    je mov_arriba_derecha
    cmp byte [verificar_mov], 90 ;Z
    je mov_abajo_izquierda
    cmp byte [verificar_mov], 67 ;C
    je mov_abajo_derecha
    jmp zorro_acorralado
mov_izquierda:
    mov eax, [columna_original]
    mov [columna_verificar], eax
    dec dword [columna_verificar]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp se_podria_mover
mov_derecha:
    mov eax, [columna_original]
    mov [columna_verificar], eax
    inc dword [columna_verificar]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp se_podria_mover
mov_arriba:
    mov eax, [fila_original]
    mov [fila_verificar], eax
    dec dword [fila_verificar]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp se_podria_mover
mov_abajo:
    mov eax, [fila_original]
    mov [fila_verificar], eax
    inc dword [fila_verificar]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp se_podria_mover
mov_arriba_izquierda:
    mov eax, [columna_original]
    mov [columna_verificar], eax
    mov eax, [fila_original]
    mov [fila_verificar], eax
    dec dword [fila_verificar]
    dec dword [columna_verificar]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp se_podria_mover
mov_arriba_derecha:
    mov eax, [columna_original]
    mov [columna_verificar], eax
    mov eax, [fila_original]
    mov [fila_verificar], eax
    dec dword [fila_verificar]
    inc dword [columna_verificar]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp se_podria_mover
mov_abajo_izquierda:
    mov eax, [columna_original]
    mov [columna_verificar], eax
    mov eax, [fila_original]
    mov [fila_verificar], eax
    inc dword [fila_verificar]
    dec dword [columna_verificar]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp se_podria_mover
mov_abajo_derecha:
    mov eax, [columna_original]
    mov [columna_verificar], eax
    mov eax, [fila_original]
    mov [fila_verificar], eax
    inc dword [fila_verificar]
    inc dword [columna_verificar]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp se_podria_mover
esta_dentro_tablero:
    mov rax, 0
    cmp dword [fila_verificar], 1
    jl fuera_de_rango
    cmp dword [fila_verificar], MAX_FILAS
    jg fuera_de_rango
    cmp dword [columna_verificar], 1
    jl fuera_de_rango
    cmp dword [columna_verificar], MAX_COLUMNAS
    jg fuera_de_rango
    cmp dword [columna_verificar], 3
    jl chequear_esquinas
    cmp dword [columna_verificar], 5
    jg chequear_esquinas
    ret
chequear_esquinas:
    cmp dword [fila_verificar], 3
    jl fuera_de_rango
    cmp dword [fila_verificar], 5
    jg fuera_de_rango
    ret
fuera_de_rango:
    mov rax, 1
    ret


se_podria_mover:
    call chequear_si_hay_oca
    cmp rax, -1
    je podria_capturar
    mov rax, 0
    ret
podria_capturar:
    cmp byte[corte_loop], 1
    je termina_fuera_de_limites
    mov byte[corte_loop], 1
    mov rax, -1
    ret
termina_fuera_de_limites:
    mov rax, 1
    ret


probar_captura:
    call es_movimiento_valido
    cmp rax, 0
    je aqui_no_paso_nada_caballeros
    add qword [contador], 1
    jmp chequear_movimientos



chequear_si_hay_oca:
    mov rdi, [verificador_vector_ocas]
    mov sil, [verificador_tope_ocas]
    mov eax, [fila_verificar]
    cdqe
    mov dl, al
    mov eax, [columna_verificar]
    cdqe
    mov cl, al
    sub rsp, 8
    call buscar_indice_de_oca
    add rsp, 8
    ; si no hay ninguna oca en las contiguas: se puede mover --> NO PIERDE
    cmp rax, -1
    je no_hay_oca
    ;hay una oca en esa contigua
    mov rax, -1
    ret
no_hay_oca:
    mov rax, 0
    ret
    

zorro_acorralado:
    mov rax, -1
    ret
aqui_no_paso_nada_caballeros:
    mov rax, 0
    ret

