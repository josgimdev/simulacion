// Definitions:
enum IntegratorType 
{
   NONE, 
   EXPLICIT_EULER, 
   SIMPLECTIC_EULER, 
   RK2, 
   RK4,
   HEUN 
}

// Display and output parameters:
final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1600;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 900;                      // Display height (pixels)
final int [] BACKGROUND_COLOR = {200, 220, 180};      // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)
final int [] STATIC_ELEMENTS_COLOR = {0, 255, 0};     // Color of non-moving elements (RGB)
final int [] MOVING_ELEMENTS_COLOR = {255, 0, 0};     // Color of moving elements (RGB)
final float OBJECTS_SIZE = 20.0;                      // Size of the objects (m)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables 

// Parameters of the problem:

final float TS = 0.0005;      // Initial simulation time step (s)
final float M = 1.0;         // Particle mass (kg)
final float G = 9.801;       // Acceleration due to gravity (m/(s·s))
final float D = 200.0;       // Square's half size (m)

final float K1e = 10000.0;        // Constante elástica del muelle i (N/m).
final float K2e = 10000.0;
final float K3e = 10000.0;
final float K4e = 10000.0;

final float L01 = 50.0;        // Elongación de reposo del muelle i (m).
final float L02 = 50.0;
final float L03 = 50.0;
final float L04 = 50.0;

final float Kd = 0.001;         // Constante de fricción con el aire (kg/m).

// Constants of the problem:
final PVector C = new PVector(DISPLAY_SIZE_X * 0.5, DISPLAY_SIZE_Y * 0.5);  // Center of the spring system (m)
final PVector S0 = PVector.add(C, new PVector(0.0, -D));  // Particle's start position (m)

// Puntos del cuadrado
final PVector C1 = new PVector(C.x - D, C.y - D);
final PVector C2 = new PVector(C.x + D, C.y - D); 
final PVector C3 = new PVector(C.x - D, C.y + D); 
final PVector C4 = new PVector(C.x + D, C.y + D); 
