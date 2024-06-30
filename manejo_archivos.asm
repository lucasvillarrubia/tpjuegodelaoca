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

	mov dword [fila_z],r8		
	mov	dword [columna_z],r9			
	mov	[puntero_vector_ocas] ,r10    		
	mov	[tope_o],r11       
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
	cmp rcx, [tope_o]
	je fin

	mov rsi, [puntero_vector_ocas + rcx]
	mov [vector_o +rcx],rsi
	add rcx, 2
	jmp escribir_vector_ocas
fin:
	mov rcx, 0
escribir_vector_movimientos
	cmp rcx, 4
	je final

	mov rsi, [puntero_movimientos_validos + rcx]
	mov [vector_o +rcx],rsi
	add rcx, 2
	jmp escribir_vector_movimientos

final:
escribir_vector_contadores:
	cmp rcx, 16
	je escribir

	mov rsi, [puntero_contadores_zorro + rcx]
	mov [vector_o +rcx],rsi
	add rcx, 2
	jmp escribir_vector_contadores

escribir:
	mov rdi, registro_escritura
	mov rsi, 59
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

leer_archivo:
	mov rdi, path_archivo
	mov rsi, modo_lectura
	
	sub rsp, 8
	call fopen
	add rsp, 8

	cmp rax, 0
    jle inicializar_sin_partida_guardada

	mov qword [id_archivo], rax

	mov rdi, registro
	mov rsi, 59
	mov rdx, 1
	mov rcx, [id_archivo]

	sub rsp, 8
	call fread
	add rsp, 8

	mov rdi, [id_archivo]

	sub rsp, 8
	call fclose
	add rsp, 8
	
	ret

errorOpen:
	ret

inicializar_sin_archivo:
	sub rsp, 8
	call inicializar_sin_partida_guardada
	add rsp, 8

	ret
