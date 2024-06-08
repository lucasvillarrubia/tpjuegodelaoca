#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>
#include "juego_de_la_oca.h"


const int GANA_JUGADOR_1 = 1;
const int JUGANDO = 0;
const int GANA_JUGADOR_2 = -1;


int main () {
	srand ((unsigned) time (NULL));
	juego_t juego;
	inicializar_juego (&juego);
	while ((estado_juego (juego)) == JUGANDO) {
		imprimir_tablero (juego);
		realizar_jugada (&juego);
		system ("clear");
	}
	if ((estado_juego (juego)) == GANA_JUGADOR_2) {
		printf("\n\n\n\n\n\n\n\n\n\n\n\n\t\tGANARON LAS OCAS\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
	}
	else if ((estado_juego (juego)) == GANA_JUGADOR_1) {
		printf("\n\n\n\n\n\n\n\n\n\n\n\n\t\tGANÓ EL ZORRO\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
	}
	return 0;
}