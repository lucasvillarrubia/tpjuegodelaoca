extern fopen
extern fread
extern fwrite
extern fclose

global escribir_archivo
global leer_archivo

extern inicializar_sin_partida_guardada

section .data
	path_archivo   db "partida_guardada.dat", 0
	modo_escritura db "wb", 0
	modo_lectura   db "rb", 0


section .bss
	id_archivo resq 1 ; File descriptor to be used in file operations

	puntero_zorro_fila 			resq 1
	puntero_zorro_columna 		resq 1
	puntero_tope_ocas			resq 1
	puntero_vector_ocas 		resq 1
	puntero_movimientos_validos resq 1
	puntero_contadores_zorro 	resq 1


	registro    		times 0 resb 1
		zorro_fila 				resd 1
		zorro_columna 			resd 1
		vector_ocas     		resb 34
		tope_ocas               resb 1
		movimientos_validos 	resb 4
		contadores_zorro 		resd 8

	registro_escritura times 0  resb 1
		fila_z         			resd 1
		columna_z	 			resd 1
		vector_o	    		resb 34
		tope_o	                resb 1
		movimientos_v		 	resb 4
		contadores_z	 		resd 8

section .text

escribir_archivo:

	mov [fila_z],r8d		
	mov	[columna_z],r9d			
	mov	[puntero_vector_ocas] ,r10    		
	mov	[tope_o],r11b       
	mov	[puntero_movimientos_validos] ,r12
	mov [puntero_contadores_zorro],r13

	mov rdi, path_archivo
	mov rsi, modo_escritura
	
	sub rsp, 8
	call fopen
	add rsp, 8

	cmp rax, 0
    jle errorOpen
    
	mov qword[id_archivo], rax

	mov rcx ,0

escribir_vector_ocas:
	cmp rcx, 34
	je fin
	mov rsi, [puntero_vector_ocas]
	mov al, [rsi + rcx]
	mov [vector_o + rcx],al

	mov rsi, [puntero_vector_ocas]
	mov al, [rsi + rcx + 1]
	mov [vector_o +rcx + 1],al
	add rcx, 2
	jmp escribir_vector_ocas
fin:
	mov rcx, 0
escribir_vector_movimientos
	cmp rcx, 4
	je final

	mov rsi, [puntero_movimientos_validos]
	mov al, [rsi + rcx]
	mov [movimientos_v +rcx],al
	inc rcx
	jmp escribir_vector_movimientos

final:
	mov rcx, 0
escribir_vector_contadores:

	cmp rcx, 32
	je escribir

	mov rsi, [puntero_contadores_zorro]
	mov eax, [rsi + rcx]
	mov [contadores_z + rcx],eax
	add rcx, 4
	jmp escribir_vector_contadores


escribir:

	mov rdi, registro_escritura
	mov rsi, 79
	mov rdx, 1
	mov rcx, [id_archivo]
	
	sub rsp, 8
	call fwrite
	add rsp, 8

	mov rdi, [id_archivo]

	sub rsp, 8
	call fclose
	add rsp, 8
	
	ret

; (r8, r9, r10, r11, r12, r13)
; pre: (zorro_fila: r8, zorro_columna: r9, vector_ocas: r10, tope_ocas: r11, movimientos_validos: r12, contadores_zorro: r13)  
leer_archivo:


	mov [puntero_zorro_fila],r8		
	mov	[puntero_zorro_columna],r9
	mov	[puntero_vector_ocas] ,r10
	mov	[puntero_tope_ocas],r11
	mov	[puntero_movimientos_validos] ,r12
	mov [puntero_contadores_zorro],r13



	; mov rax,[puntero_vector_ocas]
	; mov bl, [rax]
	; mov bl, [rax + 1]


	mov rdi, path_archivo
	mov rsi, modo_lectura
	
	sub rsp, 8
	call fopen
	add rsp, 8

	cmp rax, 0
    jle inicializar_sin_archivo

	mov qword [id_archivo], rax

	mov rdi, registro
	mov rsi, 79
	mov rdx, 1
	mov rcx, [id_archivo]

	sub rsp, 8
	call fread
	add rsp, 8

	mov rdi, [id_archivo]

	sub rsp, 8
	call fclose
	add rsp, 8
	
	; mov bl, [vector_ocas]
	; mov bl, [vector_ocas + 1]


	mov rax, [puntero_zorro_fila]
	mov rbx, [zorro_fila]
	mov [rax], ebx
	
	mov rax, [puntero_zorro_columna]
	mov rbx, [zorro_columna]
	mov [rax], ebx

	mov rax, [puntero_tope_ocas]
	mov rbx, [tope_ocas]
	mov [rax], bl
	mov rcx, 0
	call copiar_vectores
	ret


copiar_vectores:
copiar_vector_ocas:
	cmp rcx, 34
	je terminar_copia_ocas
	mov rax, [puntero_vector_ocas]
	mov sil, [vector_ocas + rcx]
	mov [rax + rcx], sil

	mov sil, [vector_ocas + rcx + 1]
	mov [rax + rcx + 1], sil
	add rcx, 2
	jmp copiar_vector_ocas
terminar_copia_ocas:
	mov rcx, 0

copiar_movimientos_validos:
	cmp rcx, 4
	je terminar_copia_movimientos

	mov rax, [puntero_movimientos_validos]
	mov sil, [movimientos_validos + rcx]
	mov [rax +rcx],sil
	inc rcx 
	jmp copiar_movimientos_validos

terminar_copia_movimientos:
	mov rcx, 0

copiar_contadores:
	cmp rcx, 32
	je terminar_copias

	mov rax, [puntero_contadores_zorro]
	mov esi, [contadores_zorro + rcx]
	mov [rax + rcx], esi
	add rcx, 4
	jmp copiar_contadores

terminar_copias:
	mov rax, 1
	ret



errorOpen:
	ret

inicializar_sin_archivo:
	; sub rsp, 8
	; call inicializar_sin_partida_guardada
	; add rsp, 8
	mov rax, -1
	ret
