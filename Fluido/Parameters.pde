// Definitions:
enum CollisionDataType
{
   NONE,
   GRID,
   HASH
}

// Display and output parameters:
final int DRAW_FREQ = 100;                             // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1600;                       // Display width (pixels)
final int DISPLAY_SIZE_Y = 900;                       // Display height (pixels)
final int [] BACKGROUND_COLOR = {220, 200, 210};       // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                   // Text color (RGB)
final String FILE_NAME = "data.csv";                   // File to write the simulation variables

// Parameters of the problem:
final float TS = 0.1;      // Initial simulation time step (s)
final float M = 1;         // Particles' mass (kg)
final float H = 8;         // Altura del recipiente (m)
final float G = 9.801;     // Módulo del vector aceleración de la gravedad (m/s^2)
final float R = 0.2;       // Radio de las partículas (m)
final float Kd = 0.01;     // Constante de fricción cuadrática (kg/m)
final float Cr = 0.9;      // Valor entre 0 y 1, perdida de energia en cada colision (-)
final float Ke = 2;        // Constante elástica de los muelles de colisión (N/m)

// Constants of the problem:
final color PARTICLES_COLOR = color(120, 160, 220);  // Color de las particulas
final int SC_GRID = 50;           // Cell size (grid) (m)
final int SC_HASH = 100;          // Cell size (hash) (m)
final int NC_HASH = 20;           // Number of cells (hash)
final float DISTANCIA_X = (DISPLAY_SIZE_X) * 0.01;  // Distancia de la pantalla en el eje x (m)
final float DISTANCIA_Y = (DISPLAY_SIZE_Y) * 0.01;  // Distancia de la pantalla en el eje y (m)
