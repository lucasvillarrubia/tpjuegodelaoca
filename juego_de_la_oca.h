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



/*
*   Devuelve true si el caracter recibido corresponde a alguna acción válida en el juego ('A', 'W', 'D', 'S' para mover el personaje,
*           o 'V' para comprar una vida extra).
*/
bool es_movimiento_valido (char movimiento, bool es_turno_del_zorro);

/*
*   PRE: Recibe un vector de elementos inicializado con su respectivo tope y una posición para verificar.
*   POST: Devuelve -1 si la coordenada de ningún elemento coincide con la coordenada recibida, de lo contrario
*           devuelve la posición del vector en donde se encuentra el elemento con coordenada coincidente.
*/
int buscar_oca (oca_t ocas [MAX_OCAS], int tope, coordenada_t posicion);



int buscar_oca_por_letra (oca_t ocas [MAX_OCAS], int tope, char letra_oca);



void pedir_oca (char* ref_letra_oca);



/*
*   PRE: Recibe un vector de elementos inicializado con su respectivo tope y la coordenada de un elemento del vector para eliminar.
*   POST: Elimina el elemento de coordenada coincidente con la recibida y disminuye el tope.
*/
void eliminar_oca (oca_t ocas [MAX_OCAS], int* tope, coordenada_t posicion);

/*
*   PRE: Recibe la dirección del movimiento válida, un juego inicializado para editar y
*           una posición en donde hay una pared.
*   POST: Ubica al personaje en una posición salteada si pudo utilizar una o más escaleras
*           (el personaje no puede quedar sobre la escalera ni moverse por pared, y sólo se puede
*           mover en línea recta por las escaleras).
*/
bool comer_oca (juego_t* juego, char movimiento, coordenada_t posicion);

/*
*   PRE: Recibe dos enteros (máximos) positivos.
*   POST: Devuelve true si la fila y columna de la coordenada recibida se encuentran dentro de los máximos recibidos.
*/
bool esta_dentro_tablero (coordenada_t posicion, int max_alto, int max_ancho);

/*
*   PRE: Recibe un vector de obstáculos inicializado con su respectivo tope y la posición de la sombra del juego.
*   POST: Devuelve true si la distancia Manhattan entre la sombra y la posición de al menos una vela del vector recibido
*           es menor o igual a 2. De lo contrario, devuelve false.
*/
bool zorro_no_puede_moverse (juego_t juego);



//------------------------------------------------------------------------------------------------------



/*
*   PRE: Recibe un nivel inicializado.
*   POST: Ubica al personaje y la sombra en posiciones aleatorias en el juego. Ninguna de las posiciones
*           tiene que coincidir con ningún elemento o pared del nivel que se está jugando.
*/
void inicializar_piezas (zorro_t* ref_zorro, oca_t ocas[CANT_OCAS], int* tope);

/*
*   PRE: Recibe una dirección de movimiento válida y un juego inicializado para editar.
*   POST: Ubica a la sombra en la posición donde se apuntó, si el movimiento es posible
*           (la sombra debe estar viva, no traspasa paredes y se mueve dentro de los límites del terreno).
*           De lo contrario, no se modifica su posición.
*/
bool mover_oca (juego_t* juego, char movimiento, int indice_oca);

/*
*   PRE: Recibe una dirección de movimiento válida y un juego inicializado para editar.
*   POST: Ubica al personaje en la posición donde se apuntó, si el movimiento es posible
*           (si no hay una pared y está dentro de los límites del terreno). De lo contrario,
*           no se modifica su posición.
*/
bool mover_zorro (juego_t* juego, char movimiento);

/*
*   Pide un movimiento (caracter) al usuario hasta que sea uno válido para continuar el juego.
*/
void pedir_movimiento (char* ref_movimiento, bool es_turno_del_zorro);

/*
*   PRE: Recibe un juego inicializado y una matriz vacía del tamaño del terreno de juego deseado.
*   POST: Llena la matriz completa según los datos del juego (personajes y lugares vacíos)
*           lista para mostrar.
*/
void rellenar_cuadricula (juego_t juego, char tablero_vacio [MAX_FILAS][MAX_COLUMNAS]);



//-----------------------------------------------------------------------------------------------------



/*
 * Procedimiento que recibe el juego e imprime toda su información por pantalla.
 */
void imprimir_tablero(juego_t juego);

/* 
 *Inicializará el juego, cargando toda la información inicial, los datos del personaje, y los 3 niveles.
 */
void inicializar_juego(juego_t* juego);

/*
 * Recibe un juego con todas sus estructuras válidas.
 *
 * El juego se dará por ganado, si terminó todos los niveles. O perdido, si el personaje queda
 * sin vida. 
 * Devolverá:
 * -> 0 si el estado es jugando. 
 * -> -1 si el estado es perdido.
 * -> 1 si el estado es ganado.
 */
int estado_juego(juego_t juego);

/*
 * Moverá el personaje, y realizará la acción necesaria en caso de chocar con un elemento
 */
void realizar_jugada(juego_t* juego);

#endif