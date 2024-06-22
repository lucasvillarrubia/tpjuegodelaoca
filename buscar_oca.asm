global buscar_indice_de_oca
extern comprobar_posiciones_iguales



section .bss
    auxiliar_fila               resb 1
    auxiliar_columna            resb 1
    tope_ocas                   resb 1
    fila_a_comparar             resb 1
    columna_a_comparar          resb 1

section .text


; FUNCION PRINCIPAL
; (rdi, rsi, rdx, rcx)
; (vector_ocas: rdi, tope_ocas: sil, auxiliar_fila: dl, auxiliar_columna: cl)
; post: devuelvo el indice de la oca en el vector, teniendo en cuenta que son 2 
;       elementos por oca, ej: oca Nro 9 devuelve indice 18.
buscar_indice_de_oca:
    mov     [auxiliar_fila], dl
    mov     [auxiliar_columna], cl
    mov     [tope_ocas], sil
    mov     rcx, 0; contador para saber el indice del elemento en el vector, y lo uso para comparar con el tope
    primer_loop_buscar:
        cmp     cl, [tope_ocas]
        jge     oca_no_encontrada
        mov     sil, [rdi + rcx]; consigo la fila de la oca del vector
        mov     [fila_a_comparar], sil
        mov     sil, [rdi + rcx + 1]; consigo la columna de la oca del vector
        mov     [columna_a_comparar], sil
        call    comprobar_posiciones_iguales
        cmp     rax, 0
        jge     oca_encontrada
        add     rcx, 2
        jmp     primer_loop_buscar
    oca_encontrada:
        mov     rax, rcx
        ret ;  en rax devuelvo el indice del elemento buscado teniendo en cuenta que el vector tiene 2 elementos por oca

    oca_no_encontrada:
        ret ; asumo que donde me llamen voy a usar el rax -1 para decir que no encontre la oca
