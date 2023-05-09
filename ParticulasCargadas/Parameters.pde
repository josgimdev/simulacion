// Definitions:

enum CollisionDataType
{
   NONE,
   GRID,
   HASH
}

// Display and output parameters:

final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 900;                       // Display width (pixels)
final int DISPLAY_SIZE_Y = 900;                       // Display height (pixels)
final int [] BACKGROUND_COLOR = {220, 200, 210};      // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables

// Parameters of the problem:

final float TS = 0.01;         // Initial simulation time step (s)
final float P = 1000;          // Numero de partículas (-)
final float Mmin = 0.1;        // Valor mínimo que pueden tener las masas de las partículas (kg)
final float Mmax = 0.9;        // Valor máximo que pueden tener las masas de las partículas (kg)
final float Qmin = 0.01;       // Valor mínimo que pueden tener las cargas de las partículas (C)
final float Qmax = 0.09;       // Valor máximo que pueden tener las cargas de las partículas (C)
final float Ka = 1;            // Constante de atracción eléctrica (N·m/C^2)
final float Kd = 0.1;         // Constante de fricción (kg/s)
final float R = 0.2;           // Radio de cada partícula (m)

final boolean Nebulosa = true;
// Constants of the problem:

final color PARTICLES_COLOR = color(120, 160, 220);
final color PARTICLES_COLOR1 = color(0, 0,0);
final int SC_GRID = 50;             // Cell size (grid) (m)
final int SC_HASH = 50;             // Cell size (hash) (m)
final int NC_HASH = 1000;           // Number of cells (hash)
final float DISTANCIA_X = (DISPLAY_SIZE_X - 100) * 0.01;  // Distancia en x (m)
final float DISTANCIA_Y = (DISPLAY_SIZE_Y - 100) * 0.01;  // Distancia en y (m)
