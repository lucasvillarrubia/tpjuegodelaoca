línea pa compilar:

gcc *.c -o jueguito -std=c99 -Wall -Wconversion -Werror -Wtype-limits -Wextra -lm

y pa ejecutar:

./jueguito

cosas horribles que no arreglé:
- switches en mover_oca y mover_zorro (y su repetición)
- valores literales (everywhere)
- condiciones de if largas
- tampoco agregué operadores ternarios

extras:
- no arreglé pre y posts del headers file (sólo las borré)
- no están las instrucciones completas para el jugador
- no agregué las condiciones para jugar con letras minúsculas

con respecto al tp:
- el zorro todavía no puede hacer saltos múltiples comiendo ocas
- no se imprimen ni guardan las estadísticas de movimiento del zorro
- bueno lo de la "personalización" falta también (capaz será suficiente con unicode o codigos ascii)
- guardar partida y recuperar: tengo que buscar mi otro tp de algo1

that´s all
