// Definitions:

// Spring Layout
enum SpringLayout
{
   STRUCTURAL,
   STRUCTURAL_AND_SHEAR,
   STRUCTURAL_AND_BEND
}

// Simulation values:

final boolean REAL_TIME = true;   // To make the simulation run in real-time or not
final float TIME_ACCEL = 1.0;     // To simulate faster (or slower) than real-time


// Display and output parameters:

boolean DRAW_MODE = false;                            // True for wireframe
final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1600;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 900;                      // Display height (pixels)
final float FOV = 60;                                 // Field of view (º)
final float NEAR = 0.01;                              // Camera near distance (m)
final float FAR = 10000.0;                            // Camera far distance (m)
final color STRUCT_COLOR = color(250, 240, 190);      // Object color (RGB)
final color BEND_COLOR = color(0, 240, 190);         // Object color (RGB)
final color SHEAR_COLOR = color(250, 240, 0);         // Object color (RGB)
final color BACKGROUND_COLOR = color(190, 1800, 210); // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables

// Parameters of the problem:

final float TS = 0.001;     // Initial simulation time step (s)
final float G = 9.81;       // Acceleration due to gravity (m/(s·s))

final int N_X = 25;         // Number of nodes of the object in the X direction
final int N_Y = 1;          // Number of nodes of the object in the Y direction
final int N_Z = 25;         // Number of nodes of the object in the Z direction

final float D_X = 0.18;     // Separation of the object's nodes in the X direction (m)
final float D_Y = 0;       // Separation of the object's nodes in the Y direction (m)
final float D_Z = 0.12;     // Separation of the object's nodes in the Z direction (m)

final float Ke_STRUCT = 400;    // Constante elástica de cada uno de los muelles de la malla en las direcciones X e Y (N/m).
final float Kd_STRUCT = 3.0;    // Constante de amortiguamiento lineal de cada uno de los muelles de la malla en las direcciones X e Y (kg/s).

final float Ke_BEND = 150;      // Constante elástica de cada uno de los muelles de la malla en las direcciones X e Y (N/m).
final float Kd_BEND = 2.0;      // Constante de amortiguamiento lineal de cada uno de los muelles de la malla en las direcciones X e Y (kg/s).

final float Ke_SHEAR = 300;     // Constante elástica de cada uno de los muelles de la malla en las direcciones X e Y (N/m).
final float Kd_SHEAR = 2.0;     // Constante de amortiguamiento lineal de cada uno de los muelles de la malla en las direcciones X e Y (kg/s).

final float m = 0.01;        // Masa de cada nodo de la estructura deformable (kg).

final float H = 12;       // Altura de la bandera
final float S = 8;       // Separación entre las banderas

final float AirForce = 10;  // Air force from the inside of the deformable object

boolean Gravedad = false;
boolean Viento = true;
