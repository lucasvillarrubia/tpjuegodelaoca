#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>
#include "juego_de_la_oca.h"


#define MAX_FILAS 7
#define MAX_COLUMNAS 7
#define CANT_OCAS 17
#define MAX_OCAS 48

#define ZORRO_COL_INICIAL 3
#define ZORRO_FIL_INICIAL 4

#define ARRIBA 'W'
#define IZQUIERDA 'A'
#define ABAJO 'S'
#define DERECHA 'D'
#define ARRIBA_IZQUIERDA 'Q'
#define ARRIBA_DERECHA 'E'
#define ABAJO_IZQUIERDA 'Z'
#define ABAJO_DERECHA 'X'


const int GANO_ZORRO = 1;
const int JUEGO_EN_CURSO = 0;
const int GANARON_OCAS = -1;

const char ZORRO = 'Z';
const char OCA = 'O';
const char FUERA_TABLERO = 'X';
const char LUGAR_VACIO = '-';

const int LIMITE_MIN_TABLERO = 0;
const int NO_ENCONTRADX = -1;
const int OCAS_PARA_GANAR = 12;


bool coordenadas_iguales (coordenada_t a, coordenada_t b) {
    return ((a.fila == b.fila) && (a.col == b.col));
}

//mal nombre , mejor nombre pisa oca
int buscar_oca (oca_t ocas [MAX_OCAS], int tope_ocas, coordenada_t posicion) {
	for(int i= 0; i<tope_ocas ; i++){
		if (coordenadas_iguales (ocas[i].posicion, posicion)) {
          	return i;
        }
	}
	return NO_ENCONTRADX;
}


void eliminar_oca (oca_t ocas [MAX_OCAS], int* tope, coordenada_t posicion) {
	int pos_eliminar = buscar_oca (ocas, (*tope), posicion);
	if (pos_eliminar == NO_ENCONTRADX) {
		return;
	}
	for (int i = pos_eliminar; i < (*tope); i++) {
		ocas [i] = ocas [i+1];
	}
	(*tope)--;
}

//deberian ser constantes definidaas con parametros del tablero el max alto y ancho
bool esta_dentro_tablero (coordenada_t posicion, int max_alto, int max_ancho) {
	int i = posicion.col;
	int j = posicion.fila;
	bool fuera_de_juego = ((i < 2 || i > 4) && (j < 2 || j > 4));
	return ((j < max_alto)
		&& (j >= LIMITE_MIN_TABLERO)
		&& (i < max_ancho)
		&& (i >= LIMITE_MIN_TABLERO)
		&& !fuera_de_juego);
}

/*hace lo mismo que buscar oca pero con letra por ahora todas ocas son irreconocibles*/
/*int buscar_oca_por_letra (oca_t* ocas, int tope, char letra_oca) {
	int indice_oca = NO_ENCONTRADX;
    int i = 0;
    while ((i < tope) && (indice_oca == NO_ENCONTRADX)) {
    	if (ocas[i].nombre == letra_oca) {
          	indice_oca = i;
        }
        i ++;
    }
    return indice_oca;
}*/

/*
void pedir_oca (char* ref_letra_oca) {
	printf ("\tLe toca a las ocas:\n\tIngresá la letra de la oca que querés mover (MENOS LA 'X'):  ");
	scanf (" %c", ref_letra_oca);
	while ((*ref_letra_oca) > (CANT_OCAS+64) || (*ref_letra_oca) < 65) {
		printf ("\n\tNo existe esa oca en este juego.\n\tIngresá una letra de oca válido (LA 'X' NO):  ");
		scanf (" %c", ref_letra_oca);
	}
}*/


bool es_movimiento_valido (char movimiento, bool es_turno_del_zorro) {
	bool movimiento_cardinal = (
		(movimiento == ABAJO) ||
		(movimiento == IZQUIERDA) ||
		(movimiento == DERECHA));
	bool movimiento_zorro = (
		(movimiento == ARRIBA) ||
		(movimiento == ARRIBA_IZQUIERDA) ||
		(movimiento == ARRIBA_DERECHA) ||
		(movimiento == ABAJO_IZQUIERDA) ||
		(movimiento == ABAJO_DERECHA));
	bool direccion_valida = (movimiento_cardinal || (movimiento_zorro && es_turno_del_zorro));
	return direccion_valida;
}


void pedir_movimiento (char* ref_movimiento, bool es_turno_del_zorro) {
	printf ("\t¡A jugar!\n\tIngresá tu movimiento:  ");
	scanf (" %c", ref_movimiento);
	while (!es_movimiento_valido (*ref_movimiento, es_turno_del_zorro)) {
		printf ("\n\tCon eso no hacés nada!\n\tIngresá un movimiento válido:  ");
		scanf (" %c", ref_movimiento);
	}
}


bool zorro_no_puede_moverse (juego_t juego) {
	coordenada_t zorro = juego.zorro.posicion;
	coordenada_t auxiliar;
	for (int i = zorro.col-2; i <= zorro.col+2; i++) {
		for (int j = zorro.fila-2; j <= zorro.fila+2; j++) {
			if (!(((i == zorro.col-2 || i == zorro.col+2) && (j == zorro.fila-1 || j == zorro.fila+1)) ||
				((i == zorro.col-1 || i == zorro.col+1) && (j == zorro.fila-2 || j == zorro.fila+2)) ||
				(i == zorro.col && j == zorro.fila))) {
				auxiliar.col = i;
				auxiliar.fila = j;
				if (esta_dentro_tablero(auxiliar, MAX_FILAS, MAX_COLUMNAS) /*|| buscar_oca(juego.ocas, juego.tope_ocas, auxiliar) != NO_ENCONTRADX*/) {
					return false;
				}
			}
		}
	}
	return true;
}


bool comer_oca (juego_t* juego, char movimiento, coordenada_t posicion) {
	coordenada_t auxiliar = posicion;
	bool devoro = false;
	int indice_oca = 0 ;/*buscar_oca ((*juego).ocas, (*juego).tope_ocas, auxiliar);*/
	if (indice_oca != NO_ENCONTRADX) {
		switch (movimiento) {
			case ARRIBA:
			auxiliar.fila --;
			break;
		case ABAJO:
			auxiliar.fila ++;
			break;
		case IZQUIERDA:
			auxiliar.col --;
			break;
		case DERECHA:
			auxiliar.col ++;
			break;
		case ARRIBA_IZQUIERDA:
			auxiliar.col --;
			auxiliar.fila --;
			break;
		case ARRIBA_DERECHA:
			auxiliar.col ++;
			auxiliar.fila --;
			break;
		case ABAJO_IZQUIERDA:
			auxiliar.col ++;
			auxiliar.fila ++;
			break;
		case ABAJO_DERECHA:
			auxiliar.col ++;
			auxiliar.fila ++;
			break;
		}
		if (esta_dentro_tablero (auxiliar, MAX_FILAS, MAX_COLUMNAS) /*&& (buscar_oca ((*juego).ocas, (*juego).tope_ocas, auxiliar) == NO_ENCONTRADX)*/) {
			(*juego).zorro.posicion = auxiliar;
			/*eliminar_oca ((*juego).ocas, &(*juego).tope_ocas, posicion);*/
			(*juego).zorro.ocas_capturadas ++;
			if ((*juego).zorro.ocas_capturadas >= OCAS_PARA_GANAR) {
				(*juego).zorro.comio_suficientes_ocas = true;
			}
			devoro = true;
		}
	}
	return devoro;
	}


//mover y comer oca no lo mismo?
bool mover_zorro (juego_t* juego, char movimiento) {
	coordenada_t auxiliar = (*juego).zorro.posicion;
	switch (movimiento) {
		case ARRIBA:
			auxiliar.fila --;
			break;
		case ABAJO:
			auxiliar.fila ++;
			break;
		case IZQUIERDA:
			auxiliar.col --;
			break;
		case DERECHA:
			auxiliar.col ++;
			break;
		case ARRIBA_IZQUIERDA:
			auxiliar.col --;
			auxiliar.fila --;
			break;
		case ARRIBA_DERECHA:
			auxiliar.col ++;
			auxiliar.fila --;
			break;
		case ABAJO_IZQUIERDA:
			auxiliar.col --;
			auxiliar.fila ++;
			break;
		case ABAJO_DERECHA:
			auxiliar.col ++;
			auxiliar.fila ++;
			break;
	}
	if (esta_dentro_tablero (auxiliar, MAX_FILAS, MAX_COLUMNAS)) {
		/*if (buscar_oca ((*juego).ocas, (*juego).tope_ocas, auxiliar) == NO_ENCONTRADX) {
			(*juego).zorro.posicion = auxiliar;
			return true;
		}*/
		return comer_oca (juego, movimiento, auxiliar);
	}
	return false;
}


bool mover_oca (juego_t* juego, char movimiento, int indice_oca) {
	coordenada_t pos_zorro = (*juego).zorro.posicion;
	coordenada_t auxiliar = (*juego).ocas[indice_oca].posicion;
	switch (movimiento) {
		case ABAJO:
			auxiliar.fila ++;
			break;
		case IZQUIERDA:
			auxiliar.col --;
			break;
		case DERECHA:
			auxiliar.col ++;
			break;
	}
	if (esta_dentro_tablero (auxiliar, MAX_FILAS, MAX_COLUMNAS) && (!coordenadas_iguales(auxiliar, pos_zorro)) /*&& (buscar_oca ((*juego).ocas, (*juego).tope_ocas, auxiliar) == NO_ENCONTRADX)*/) {
		(*juego).ocas[indice_oca].posicion = auxiliar;
		return true;
	}
	return false;
}


void inicializar_piezas (zorro_t* ref_zorro, oca_t ocas[CANT_OCAS], int* tope) {
	coordenada_t pos_zorro;
	coordenada_t pos_oca;
	pos_zorro.col = ZORRO_COL_INICIAL;
	pos_zorro.fila = ZORRO_FIL_INICIAL;
	(*ref_zorro).posicion = pos_zorro;
	for (int i = 0; i < MAX_COLUMNAS; i++) {
		for (int j = 0; j < MAX_FILAS; j++) {
			if ((i > 1 && i < 5 && (j == 0 || j == 1)) || (j == 2) || ((i == 0 || i == 6) &&(j == 3 || j == 4))){
				pos_oca.col = i;
				pos_oca.fila = j;
				// if (buscar_oca (ocas, (*tope), pos_oca) == NO_ENCONTRADX) {
					ocas[(*tope)].posicion = pos_oca;
					(*tope)++;
				// }
			}
		}
	}
}


void inicializar_juego (juego_t* juego) {
	juego->es_turno_del_zorro = true;
	juego->zorro.ocas_capturadas = 0;
	juego->zorro.comio_suficientes_ocas = false;
	juego->tope_ocas = 0;
	inicializar_piezas (&(juego->zorro), juego->ocas, &juego->tope_ocas);
	for (int i = 0; i < juego->tope_ocas; i++) {
		juego->ocas[i].nombre = (char)(i+65);
	}
}


int estado_juego (juego_t juego) {
	if (juego.zorro.comio_suficientes_ocas) {
		return GANO_ZORRO;
	}
	else if (zorro_no_puede_moverse(juego)) {
		return GANARON_OCAS;
	}
	else {
		return JUEGO_EN_CURSO;
	}
}


void realizar_jugada (juego_t* juego) {
	char movimiento;
	int indice_oca;
	if (!juego->es_turno_del_zorro) {
		printf ("\tEs turno de las OCAS\n");
		/*char letra_oca = 0;
		pedir_oca(&letra_oca);
		indice_oca = buscar_oca_por_letra(juego->ocas, juego->tope_ocas, letra_oca);*/
		indice_oca = 1; //para probar 
		mover_oca (juego, movimiento, indice_oca);
		
	}else{
		printf ("\tEs turno del ZORRO\n");
		pedir_movimiento (&movimiento, (*juego).es_turno_del_zorro);
		mover_zorro (juego, movimiento);

		/*if ((*juego).es_turno_del_zorro) {
		se_movio_pieza = mover_zorro (juego, movimiento);
		}
		else if (indice_oca != NO_ENCONTRADX) {
			se_movio_pieza = mover_oca (juego, movimiento, indice_oca);
		}
		if (se_movio_pieza) {
			(*juego).es_turno_del_zorro = !(*juego).es_turno_del_zorro;
		}*/
	}

	juego->es_turno_del_zorro = !juego->es_turno_del_zorro;
	
}


void rellenar_cuadricula (juego_t juego, char tablero_vacio [MAX_FILAS][MAX_COLUMNAS]) {
	coordenada_t casillero;
	for (int i = 0; i < MAX_FILAS; i++) {
		for (int j = 0; j < MAX_COLUMNAS; j++) {
			if ((i < 2 || i > 4) && (j < 2 || j > 4)) {
				tablero_vacio [i][j] = FUERA_TABLERO;
			}
			else {
				tablero_vacio [i][j] = LUGAR_VACIO;
				casillero.fila = i;
				casillero.col = j;
				int oca_en_casillero = 0; /*buscar_oca (juego.ocas, juego.tope_ocas, casillero);*/
				if (coordenadas_iguales (casillero, juego.zorro.posicion)) {
					tablero_vacio [i][j] = ZORRO;
				}
				else if (oca_en_casillero != NO_ENCONTRADX) {
					tablero_vacio [i][j] = OCA;
					// tablero_vacio [i][j] = (char)((short)(juego.ocas[oca_en_casillero].numero));
					tablero_vacio [i][j] = juego.ocas[oca_en_casillero].nombre;
					// printf("%i\n", juego.ocas[oca_en_casillero].numero);
				}
			}
		}
	}
}


void imprimir_tablero (juego_t juego) {
	char tablero [MAX_FILAS][MAX_COLUMNAS];
	rellenar_cuadricula (juego, tablero);

	printf ("\n\n\n\t¡Bienvenidxs al Juego de la Oca!\n\tSi el zorro come 12 ocas gana (?\n\n\n \
	Ocas capturadas:  %i\n", juego.zorro.ocas_capturadas);

	for (int i = 0; i < MAX_FILAS; i++) {
		printf("\n\n\t");
		for (int j = 0; j < MAX_COLUMNAS; j++) {
			printf ("%c   ", tablero [i][j]);
		}
	}
	printf ("\n\n\tInstrucciones de juego (masomenos):\n\n \
	Con la letra (A)  -->  Te movés a la IZQUIERDA. \n \
	Con la letra (D)  -->  Te movés a la DERECHA.   \n \
	Con la letra (W)  -->  Te movés hacia ARRIBA.   \n \
	Con la letra (S)  -->  Te movés hacia ABAJO.   \n \
	Con la letra (Q)  -->  Te movés hacia ARRIBA IZQUIERDA.   \n \
	Con la letra (E)  -->  Te movés hacia ARRIBA DERECHA.   \n \
	Con la letra (Z)  -->  Te movés hacia ABAJO IZQUIERDA.   \n \
	Con la letra (X)  -->  Te movés hacia ABAJO DERECHA.   \n\n\n\n");
}