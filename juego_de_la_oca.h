#ifndef __JUEGO_DE_LA_OCA__
#define __JUEGO_DE_LA_OCA__

#include <stdbool.h>

#define MAX_FILAS 7
#define MAX_COLUMNAS 7
#define CANT_OCAS 17
#define MAX_OCAS 48


typedef struct coordenada {
    int fila;
    int col;
}coordenada_t;

typedef struct zorro {
    coordenada_t posicion;
    int ocas_capturadas;
    bool comio_suficientes_ocas;
}zorro_t;

typedef struct oca {
    coordenada_t posicion;
    int numero;
    char nombre;
}oca_t;

typedef struct juego {
    zorro_t zorro;
    oca_t ocas[CANT_OCAS];
    int tope_ocas;
    bool es_turno_del_zorro;
}juego_t;



//------------------------------------------------------------------------------------------------------



/*
*   Devuelve true si las coordenadas son iguales (coinciden en fila y columna).
*/
bool coordenadas_iguales (coordenada_t a, coordenada_t b);



//------------------------------------------------------------------------------------------------------



bool es_movimiento_valido (char movimiento, bool es_turno_del_zorro);


int buscar_oca (oca_t ocas [MAX_OCAS], int tope, coordenada_t posicion);


int buscar_oca_por_letra (oca_t ocas [MAX_OCAS], int tope, char letra_oca);


void pedir_oca (char* ref_letra_oca);


 
void eliminar_oca (oca_t ocas [MAX_OCAS], int* tope, coordenada_t posicion);


bool comer_oca (juego_t* juego, char movimiento, coordenada_t posicion);


bool esta_dentro_tablero (coordenada_t posicion, int max_alto, int max_ancho);


bool zorro_no_puede_moverse (juego_t juego);



//------------------------------------------------------------------------------------------------------




void inicializar_piezas (zorro_t* ref_zorro, oca_t ocas[CANT_OCAS], int* tope);


bool mover_oca (juego_t* juego, char movimiento, int indice_oca);


bool mover_zorro (juego_t* juego, char movimiento);


void pedir_movimiento (char* ref_movimiento, bool es_turno_del_zorro);


void rellenar_cuadricula (juego_t juego, char tablero_vacio [MAX_FILAS][MAX_COLUMNAS]);



//-----------------------------------------------------------------------------------------------------



/*
 * Procedimiento que recibe el juego e imprime toda su información por pantalla.
 */
void imprimir_tablero(juego_t juego);


void inicializar_juego(juego_t* juego);


int estado_juego(juego_t juego);


void realizar_jugada(juego_t* juego);

#endif
