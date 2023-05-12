// Display and output parameters:
final int DRAW_FREQ = 100;                             // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                       // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                       // Display height (pixels)
final int [] BACKGROUND_COLOR = {220, 200, 210};       // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                   // Text color (RGB)

// Parameters of the problem:
final float TS = 0.1;     // Initial simulation time step (s)
final float M = 1;        // Particles' mass (kg)
final float G = 9.801;    // Módulo del vector aceleración de la gravedad (m/s^2)
final float R = 0.5;      // Radio de las partículas (m)
final float Kd = 0.005;   // Constante de fricción cuadrática (kg/m)
final float Cr = 1;       // Valor entre 0 y 1, perdida de energia en cada colision (-)
final float Ke = 2;       // Constante elástica de los muelles de colisión (N/m)

// Constants of the problem:
final color PARTICLES_COLOR = color(120, 160, 220);  // Color de las particulas
final float DISTANCIA_X = (DISPLAY_SIZE_X) * 0.01;   // Distancia de la pantalla en el eje x (m)
final float DISTANCIA_Y = (DISPLAY_SIZE_Y) * 0.01;   // Distancia de la pantalla en el eje y (m)
