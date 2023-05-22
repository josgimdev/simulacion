// Simulation values:
final boolean REAL_TIME = true;   // To make the simulation run in real-time or not
final float TIME_ACCEL = 1.0;     // To simulate faster (or slower) than real-time

// Display and output parameters:
boolean DRAW_MODE = true;                             // True for wireframe
final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1200;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 900;                       // Display height (pixels)
final float FOV = 60;                                 // Field of view (º)
final float NEAR = 0.01;                              // Camera near distance (m)
final float FAR = 10000.0;                            // Camera far distance (m)
final color OBJ_COLOR = color(250, 240, 190);         // Object color (RGB)
final color BALL_COLOR = color(225, 127, 80);         // Ball color (RGB)
final color BACKGROUND_COLOR = color(190, 1800, 210); // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)

// Parameters of the problem:
final float TS = 0.001;     // Initial simulation time step (s)
final float G = 9.81;       // Acceleration due to gravity (m/(s·s))

final int N_X = 75;         // Number of nodes of the object in the X direction
final int N_Y = 75;         // Number of nodes of the object in the Y direction

final float D_X = 0.15;     // Separation of the object's nodes in the X direction (m)
final float D_Y = 0.15;     // Separation of the object's nodes in the Y direction (m)
