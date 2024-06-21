%define MAX_FILAS 7
%define MAX_COLUMNAS 7

;
; PARA LLEGAR ACÁ:
; - YA SE CHEQUEÓ QUE EN LA CASILLA A MOVER HAY UNA OCA
; - SE TIENE "DIRECCIÓN" DEL MOVIMIENTO Y ES VÁLIDO!!!
;
; PARA QUE LA CAPTURA DE LA OCA SEA EXITOSA SE TIENE QUE VERIFICAR QUE:
; - EN LA CASILLA SIGUIENTE EN LA MISMA DIRECCIÓN ESTÉ DENTRO DEL TABLERO
; - NO HAYA UNA OCA AHÍ
; 
; SI SE CAPTURA  --->  SE UBICA AL ZORRO EN LAS NUEVAS COORDENADAS Y SIGUE SIENDO SU TURNO
;
; SI NO SE CAPTURA  --->  NO SE MUEVE AL ZORRO
;

global capturar


section .data

section .bss
    movimiento resb 1
    fila resd 1
    columna resd 1

section .text
capturar:
    mov [movimiento], dil
    mov [fila], esi
    mov [columna], edx
es_movimiento_valido:
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
    jmp termina_sin_capturar
mov_izquierda:
    dec dword [columna]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp exito
mov_derecha:
    inc dword [columna]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp exito
mov_arriba:
    dec dword [fila]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp exito
mov_abajo:
    inc dword [fila]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp exito
mov_arriba_izquierda:
    dec dword [fila]
    dec dword [columna]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp exito
mov_arriba_derecha:
    dec dword [fila]
    inc dword [columna]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp exito
mov_abajo_izquierda:
    inc dword [fila]
    dec dword [columna]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp exito
mov_abajo_derecha:
    inc dword [fila]
    inc dword [columna]
    call esta_dentro_tablero
    cmp rax, 0
    jne termina_fuera_de_limites
    jmp exito
esta_dentro_tablero:
    mov rax, 0
    ; condiciones del tablero por defecto: FALTAN BLOQUEAR LAS ESQUINAS
    cmp dword [fila], 1
    jl fuera_de_rango
    cmp dword [fila], MAX_FILAS
    jg fuera_de_rango
    cmp dword [columna], 1
    jl fuera_de_rango
    cmp dword [columna], MAX_COLUMNAS
    jg fuera_de_rango
    ; ___________________________________
    ret
fuera_de_rango:
    mov rax, 1
    ret
termina_fuera_de_limites:
    mov rax, 1
    ret
termina_sin_capturar:
    mov rax, 1
    ret
exito:
    mov edi, [fila]
    mov esi, [columna]

    ;sub rsp, 8
    ;call hay_una_oca
    ;add rsp, 8
    ; HAY UNA OCA EN LA CASILLA A MOVER? SÍ    ---->    NO PUEDE CAPTURAR, FIGURA COMO MOVIMIENTO INVÁLIDO, SIGUE SIENDO TURNO DEL ZORRO
    ;mov rax, 0

    ; HAY UNA OCA EN LA CASILLA A MOVER? NO    ---->    CAPTURAAAAA
    mov rax, 1

    cmp rax, 0
    je termina_sin_capturar
    jmp ubicar_zorro
ubicar_zorro:
    mov rax, 0
    mov edi, [fila]
    mov esi, [columna]
    ret

