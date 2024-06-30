%define MAX_FILAS 7
%define MAX_COLUMNAS 7


;
; POSIBILIDADES DE MOVIMIENTO:
; - SI EL CASILLERO A OCUPAR TIENE UNA OCA, SE CHEQUEA SI SE PUEDE CAPTURAR, USANDO <capturar.asm>
; - SI ES UN CASILLERO VACÍO, SE UBICA AL ZORRO EN LAS NUEVAS COORDENADAS
; - SI EL MOVIMIENTO ESTÁ FUERA DE RANGO, NO SE MUEVE AL ZORRO
;
; INTERPRETACIÓN DEL MOVIMIENTO [CAPTURA] A UTILIZAR:
; - UNA VEZ QUE EL ZORRO CAPTURA UNA OCA, SIGUE SIENDO SU TURNO, SI EL MOVIMIENTO SIGUIENTE A LA CAPTURA:
;   + RESULTA EN OTRA CAPTURA, ESTO SE REPITE (EN CASO DE PODER CAPTURAR EN DIRECCIONES DISTINTAS)
;   + ES A UN CASILLERO VACÍO, EL ZORRO NO SE MUEVE Y ES TURNO DE LAS OCAS
;



;
; Pre:
; RECIBE LOS SIGUIENTES PARÁMETROS EN LOS RESPECTIVOS REGISTROS:
; - char movimiento         dil
; - int fila                esi
; - int columna             edx
; - int captura_reciente    ecx
;
; Post:
; DEVUELVE UN RESULTADO EN rax:
; - (1) si hubo un input o movimiento inválido, y el zorro no se movió
; - (0) si el movimiento fue exitoso y cambió la posición del zorro
; - (-1) caso especial de interrupción voluntaria del programa
;
; SI LA POSICIÓN DEL ZORRO CAMBIA (rax = 0) SE DEVUELVE POSICIÓN Y SI CAPTURÓ:
; - int fila                en edi
; - int columna             en esi
; - int captura_reciente    en edx
;




%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro


global mover_zorro
extern buscar_indice_de_oca
extern capturar
extern printf


section .data
    ;prints de pruebas
    mensaje_input_erroneo db "che, metiste cualquiera", 10, 0
    mensaje_mov_erroneo db "nono, esa letra no sirve", 10, 0
    ;mensaje_limites db "cagaste, estas afuera", 10, 0
    ;mensaje_sin_capturar db "te cagaste de hambre", 10, 0

section .bss
    movimiento resb 1
    fila resd 1
    columna resd 1
    captura_reciente resd 1
    ;ocasss
    otro_vector_ocas resq 1
    otro_tope_ocas resb 1

section .text
mover_zorro:
    mov [movimiento], dil
    mov [fila], esi
    mov [columna], edx
    mov [captura_reciente], ecx
    mov [otro_vector_ocas], r11 ; le paso el puntero al vector de ocas
    mov [otro_tope_ocas], bl


movimiento_es_letra:
movimiento_es_minuscula:
    cmp byte [movimiento], 97
    jl movimiento_es_mayuscula
    cmp byte [movimiento], 122
    jg error_input
    jmp es_movimiento_valido
movimiento_es_mayuscula:
    cmp byte [movimiento], 65
    jl error_input
    cmp byte [movimiento], 90
    jg error_input
    jmp es_movimiento_valido
es_movimiento_valido:
    cmp byte [movimiento], 84 ;T
    je salida
    cmp byte [movimiento], 116 ;t
    je salida
    cmp byte [movimiento], 65 ;A
    je mov_izquierda
    cmp byte [movimiento], 97 ;a
    je mov_izquierda
    cmp byte [movimiento], 68 ;D
    je mov_derecha
    cmp byte [movimiento], 100 ;d
    je mov_derecha
    cmp byte [movimiento], 87 ;W
    je mov_arriba
    cmp byte [movimiento], 119 ;w
    je mov_arriba
    cmp byte [movimiento], 83 ;S
    je mov_abajo
    cmp byte [movimiento], 115 ;s
    je mov_abajo
    cmp byte [movimiento], 81 ;Q
    je mov_arriba_izquierda
    cmp byte [movimiento], 113 ;q
    je mov_arriba_izquierda
    cmp byte [movimiento], 69 ;E
    je mov_arriba_derecha
    cmp byte [movimiento], 101 ;e
    je mov_arriba_derecha
    cmp byte [movimiento], 90 ;Z
    je mov_abajo_izquierda
    cmp byte [movimiento], 122 ;z
    je mov_abajo_izquierda
    cmp byte [movimiento], 88 ;X
    je mov_abajo_derecha
    cmp byte [movimiento], 120 ;x
    je mov_abajo_derecha
    jmp error_movimiento


mov_izquierda:
    dec dword [columna]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8]
    jmp exito
mov_derecha:
    inc dword [columna]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 4]
    jmp exito
mov_arriba:
    dec dword [fila]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 8]
    jmp exito
mov_abajo:
    inc dword [fila]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 12]
    jmp exito
mov_arriba_izquierda:
    dec dword [fila]
    dec dword [columna]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 16]
    jmp exito
mov_arriba_derecha:
    dec dword [fila]
    inc dword [columna]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 20]
    jmp exito
mov_abajo_izquierda:
    inc dword [fila]
    dec dword [columna]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 24]
    jmp exito
mov_abajo_derecha:
    inc dword [fila]
    inc dword [columna]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 28]
    jmp exito


esta_dentro_tablero:
    mov rax, 0
    cmp dword [fila], 1
    jl fuera_de_rango
    cmp dword [fila], MAX_FILAS
    jg fuera_de_rango
    cmp dword [columna], 1
    jl fuera_de_rango
    cmp dword [columna], MAX_COLUMNAS
    jg fuera_de_rango
    cmp dword [columna], 3
    jl chequear_esquinas
    cmp dword [columna], 5
    jg chequear_esquinas
    ret
chequear_esquinas:
    cmp dword [fila], 3
    jl fuera_de_rango
    cmp dword [fila], 5
    jg fuera_de_rango
    ret
fuera_de_rango:
    mov rax, 1
    ret


termina_fuera_de_limites:
    ;lea rdi, [rel mensaje_limites]
    ;mPrintf
    mov edi, [captura_reciente]
    mov rax, 1
    ret
termina_sin_capturar:
    ;lea rdi, [rel mensaje_sin_capturar]
    ;mPrintf
    mov edi, [captura_reciente]
    mov rax, 1
    ret
termina_haciendose_el_vivo_despues_de_comer:
    mov dword [captura_reciente], -1
    mov edi, [captura_reciente]
    mov rax, 1
    ret
error_input:
    lea rdi, [rel mensaje_input_erroneo]
    mPrintf
    mov edi, [captura_reciente]
    mov rax, 1
    ret
error_movimiento:
    lea rdi, [rel mensaje_mov_erroneo]
    mPrintf
    mov edi, [captura_reciente]
    mov rax, 1
    ret


exito:

    ; argumentos para mandar a función "hay_una_oca"
    ;mov rdi, [movimiento]
    ;mov rsi, [fila]
    ;mov rdx, [columna]
    ;sub rsp, 8
    ;call hay_una_oca
    ;add rsp, 8
    ; ______________________________________________

    ; HAY UNA OCA EN LA CASILLA A MOVER? SÍ
    ;mov rax, 0

    ; HAY UNA OCA EN LA CASILLA A MOVER? NO
    ;mov rax, 1

    mov rdi, [otro_vector_ocas]
    mov sil, [otro_tope_ocas]
    mov eax, [fila]
    cdqe
    mov dl, al
    mov eax, [columna]
    cdqe
    mov cl, al
    call buscar_indice_de_oca


    cmp rax, -1
    je ubicar_zorro
    mov dil, [movimiento]
    mov esi, [fila]
    mov edx, [columna]
    lea r11, [otro_vector_ocas] ; le paso el puntero al vector de ocas
    mov bl,  [otro_tope_ocas]
    sub rsp, 8
    call capturar
    add rsp, 8
    cmp rax, 0
    jne termina_sin_capturar

    ; falso movimiento no modifica la posición
    cmp r10, 0
    jne salida

    mov [fila], edi
    mov [columna], esi
    mov dword [captura_reciente], 1
    mov rax, 0
    mov edi, [fila]
    mov esi, [columna]
    mov edx, [captura_reciente]
    ret
ubicar_zorro:

    ; falso movimiento no modifica la posición
    cmp r10, 0
    jne salida

    cmp dword [captura_reciente], 0
    jne termina_haciendose_el_vivo_despues_de_comer
    mov rax, 0
    mov edi, [fila]
    mov esi, [columna]
    mov edx, [captura_reciente]
    ret


salida:
    mov rax, -1
    ret

