section .data
    matriz  db ' ', ' ', 'O', 'O', 'O', ' ', ' ', 0
            db ' ', ' ', 'O', 'O', 'O', ' ', ' ', 0
            db 'O', 'O', 'O', 'O', 'O', 'O', 'O', 0
            db 'O', 'O', 'O', 'O', 'O', 'O', 'O', 0
            db 'O', 'O', 'O', 'O', 'O', 'O', 'O', 0
            db ' ', ' ', 'O', 'O', 'O', ' ', ' ', 0
            db ' ', ' ', 'O', 'O', 'O', ' ', ' ', 0

section .text
    global imprimir_tablero

imprimir_tablero:
    

    ret
