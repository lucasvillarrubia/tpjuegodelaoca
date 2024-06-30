global eliminar_oca
extern buscar_indice_de_oca


section .bss

    puntero_tope_ocas   resq 1

section .text

; FUNCION PRINCIPAL
; (rdi, rsi, rdx, rcx)
; (vector_de_ocas: rdi, tope_ocas: rsi, auxiliar_fila: dl, auxiliar_columna: cl)  
; post: si la oca existe reduce el tope en 2 y reacomoda el vector para que la oca buscada
;       este fuera del tope y devuelve 1 en rax, si la oca no existe devuelve -1 en rax.
eliminar_oca:
    mov     [puntero_tope_ocas], rsi
    mov     al, [rsi]
    mov     sil, al
    call    buscar_indice_de_oca
    cmp     rax, -1
    je      no_se_puede_eliminar_oca
    mov     rsi, [puntero_tope_ocas]
    sub     byte[rsi], 2 ; le quito una oca al vector (con el tope)
    mov     rbx, rax
    ; actualizo el vector para sacar la oca que quiero eliminar
    loop_eliminar_oca:
        mov     al, [rsi]
        cmp     bl, [rsi]
        jge     terminar_loop_eliminar_oca
        mov     dl, [rdi + rbx + 2] ; agarro la proxima fila
        mov     [rdi + rbx], dl ; la pongo en la fila del actual
        mov     cl, [rdi + rbx + 3] ; agarro la proxima columna
        mov     [rdi + rbx + 1], cl ; la pongo en la columna del actual
        add     rbx, 2
        jmp     loop_eliminar_oca
    terminar_loop_eliminar_oca:
        mov     rax, 1
        ret
    no_se_puede_eliminar_oca:
        mov     rax, -1
        ret