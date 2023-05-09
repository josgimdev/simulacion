// Display and output parameters:

final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final int [] BACKGROUND_COLOR = {20, 30, 40};         // Background color (RGB)
final int [] TEXT_COLOR = {255, 255, 0};              // Text color (RGB)
final String FILE_NAME = "data.csv";  // File to write the simulation variables 
final float POS_X = DISPLAY_SIZE_X * 0.01 * 0.5;
final float POS_Y = DISPLAY_SIZE_Y * 0.01 * 0.5;

// Parameters of the problem:

final float TS = 0.005;     // Initial simulation time step (s)
final float NT = 100.0;   // Rate at which the particles are generated (number of particles per second) (1/s)           
final float L = 5.0;       // Particles' lifespan (s)
final float G = 9.801;
final float Kd = 0.01;
final float M = 1;
final float R = 0.05;

final PVector POS_INICIAL = new PVector(.0, .0);
final float V_INICIAL = 20;
final float APERTURA = 15;

// Constants of the problem:

final String TEXTURE_FILE = "texture.png";
final color C = color(180, 180, 180);
