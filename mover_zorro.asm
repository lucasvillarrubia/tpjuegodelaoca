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
extern eliminar_oca


section .data
    ;prints de pruebas
    mensaje_input_erroneo db "che, metiste cualquiera", 10, 0
    mensaje_mov_erroneo db "nono, esa letra no sirve", 10, 0
    mensaje_limites db "cagaste, estas afuera", 10, 0
    mensaje_sin_capturar db "te cagaste de hambre", 10, 0

section .bss
    movimiento resb 1
    fila_anterior resd 1
    columna_anterior resd 1
    fila_siguiente   resd 1
    columna_siguiente resd 1
    captura_reciente resd 1
    mov_falso resq 1
    ;ocasss
    otro_vector_ocas resq 1
    otro_tope_ocas resq 1

section .text
mover_zorro:
    mov [movimiento], dil
    mov [fila_anterior], esi
    mov [columna_anterior], edx
    mov [captura_reciente], ecx
    mov [otro_vector_ocas], r11 ; le paso el puntero al vector de ocas
    mov [otro_tope_ocas], rbx
    mov [mov_falso], r10


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
    cmp byte [movimiento], 88 ;X
    je mov_abajo
    cmp byte [movimiento], 120 ;x
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
    cmp byte [movimiento], 67 ;C
    je mov_abajo_derecha
    cmp byte [movimiento], 99 ;c
    je mov_abajo_derecha
    jmp error_movimiento


mov_izquierda:
    dec dword [columna_anterior]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8]
    jmp exito
mov_derecha:
    inc dword [columna_anterior]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 4]
    jmp exito
mov_arriba:
    dec dword [fila_anterior]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 8]
    jmp exito
mov_abajo:
    inc dword [fila_anterior]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 12]
    jmp exito
mov_arriba_izquierda:
    dec dword [fila_anterior]
    dec dword [columna_anterior]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 16]
    jmp exito
mov_arriba_derecha:
    dec dword [fila_anterior]
    inc dword [columna_anterior]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 20]
    jmp exito
mov_abajo_izquierda:
    inc dword [fila_anterior]
    dec dword [columna_anterior]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 24]
    jmp exito
mov_abajo_derecha:
    inc dword [fila_anterior]
    inc dword [columna_anterior]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    inc dword [r8 + 28]
    jmp exito


esta_dentro_tablero:
    mov rax, 0
    cmp dword [fila_anterior], 1
    jl fuera_de_rango
    cmp dword [fila_anterior], MAX_FILAS
    jg fuera_de_rango
    cmp dword [columna_anterior], 1
    jl fuera_de_rango
    cmp dword [columna_anterior], MAX_COLUMNAS
    jg fuera_de_rango
    cmp dword [columna_anterior], 3
    jl chequear_esquinas
    cmp dword [columna_anterior], 5
    jg chequear_esquinas
    ret
chequear_esquinas:
    cmp dword [fila_anterior], 3
    jl fuera_de_rango
    cmp dword [fila_anterior], 5
    jg fuera_de_rango
    ret
fuera_de_rango:
    mov rax, 1
    ret


termina_fuera_de_limites:
    lea rdi, [rel mensaje_limites]
    mPrintf
    mov edi, [captura_reciente]
    mov rax, 1
    ret
termina_sin_capturar:
    lea rdi, [rel mensaje_sin_capturar]
    mPrintf
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
    ;_____________________________________________

    ; HAY UNA OCA EN LA CASILLA A MOVER? SÍ
    ;mov rax, 0

    ; HAY UNA OCA EN LA CASILLA A MOVER? NO
    ;mov rax, 1

    mov rdi, [otro_vector_ocas]
    mov rax, [otro_tope_ocas]
    mov sil, [rax]
    mov eax, [fila_anterior]
    cdqe
    mov dl, al
    mov eax, [columna_anterior]
    cdqe
    mov cl, al
    call buscar_indice_de_oca


    cmp rax, -1
    je ubicar_zorro
    mov dil, [movimiento]
    mov esi, [fila_anterior]
    mov edx, [columna_anterior]
    mov r11, [otro_vector_ocas] ; le paso el puntero al vector de ocas
    mov rax, [otro_tope_ocas]
    mov bl,  byte [rax]
    sub rsp, 8
    call capturar
    add rsp, 8
    cmp rax, 0
    jne termina_sin_capturar

    ; falso movimiento no modifica la posición
    cmp qword [mov_falso], 1
    je salida


    mov [fila_siguiente], edi
    mov [columna_siguiente], esi
    mov dword [captura_reciente], 1


    mov rdi, [otro_vector_ocas]
    mov rsi, [otro_tope_ocas]
    mov al, [rsi]
    mov eax, [fila_anterior]
    cdqe
    mov dl, al
    mov eax, [columna_anterior]
    cdqe
    mov cl, al
    call eliminar_oca


    mov rax, 0
    mov edi, [fila_siguiente]
    mov esi, [columna_siguiente]
    mov edx, [captura_reciente]
    ret
ubicar_zorro:

    ; falso movimiento no modifica la posición
    cmp qword [mov_falso], 1
    je salida

    cmp dword [captura_reciente], 1
    je termina_haciendose_el_vivo_despues_de_comer
    mov dword [captura_reciente], 0
    mov rax, 0
    mov edi, [fila_anterior]
    mov esi, [columna_anterior]
    mov edx, [captura_reciente]
    ret


salida:
    mov rax, -1
    ret

