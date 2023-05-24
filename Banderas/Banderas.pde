// Deformable object simulation
import peasy.*;

// Display control:
PeasyCam _camera;   // Mouse-driven 3D camera

// Simulation and time control:
float _timeStep;              // Simulation time-step (s)
int _lastTimeDraw = 0;        // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;         // Simulated time (s)
float _elapsedTime = 0.0;     // Elapsed (real) time (s)

// System variables:
DeformableObject _structFlag, _bendFlag, _shearFlag;
PVector _airForce = new PVector(1.0, .0, .0);

// Main code:

void settings()
{
   size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y, P3D);
}

void setup()
{
   frameRate(DRAW_FREQ);
   _lastTimeDraw = millis();

   float aspect = float(DISPLAY_SIZE_X)/float(DISPLAY_SIZE_Y);
   perspective((FOV*PI)/180, aspect, NEAR, FAR);
   _camera = new PeasyCam(this, 0);
   _camera.rotateX(PI + HALF_PI);
   _camera.setDistance(20);
   _camera.pan(S, H * -0.5);

   initSimulation();
}

void keyPressed()
{
   if (key == 'R' || key == 'r')
     initSimulation();
  
   if (key == 'V' || key == 'v')
      Viento = !Viento;

   if (key == 'G' || key == 'g')
      Gravedad = !Gravedad;
      
   if (key == 'D' || key == 'd')
     DRAW_MODE = !DRAW_MODE;
}

void initSimulation()
{
   _simTime = 0.0;
   _timeStep = TS*TIME_ACCEL;
   _elapsedTime = 0.0;
   
   _airForce.mult(AirForce);
   
   _structFlag = new DeformableObject(N_X, N_Y, N_Z, D_X, D_Y, D_Z, SpringLayout.STRUCTURAL, STRUCT_COLOR, 0, Ke_STRUCT, Kd_STRUCT);
   _bendFlag = new DeformableObject(N_X, N_Y, N_Z, D_X, D_Y, D_Z, SpringLayout.STRUCTURAL_AND_SHEAR, SHEAR_COLOR, 1, Ke_BEND, Kd_BEND);
   _shearFlag = new DeformableObject(N_X, N_Y, N_Z, D_X, D_Y, D_Z, SpringLayout.STRUCTURAL_AND_BEND, BEND_COLOR, 2, Ke_SHEAR, Kd_SHEAR);
}

void draw()
{
   int now = millis();
   _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
   _elapsedTime += _deltaTimeDraw;
   _lastTimeDraw = now;

   background(BACKGROUND_COLOR);
   drawStaticEnvironment();
   drawDynamicEnvironment();

   if (REAL_TIME)
   {
      float expectedSimulatedTime = TIME_ACCEL*_deltaTimeDraw;
      float expectedIterations = expectedSimulatedTime/_timeStep;
      int iterations = 0;

      for (; iterations < floor(expectedIterations); iterations++)
         updateSimulation();

      if ((expectedIterations - iterations) > random(0.0, 1.0))
      {
         updateSimulation();
         iterations++;
      }
   } 
   else
      updateSimulation();

   displayInfo();
}

void drawStaticEnvironment()
{
   
}

void drawDynamicEnvironment()
{
   _structFlag.render();
   _bendFlag.render();
   _shearFlag.render();
}

void updateSimulation()
{
   _structFlag.update(_timeStep);
   _bendFlag.update(_timeStep);
   _shearFlag.update(_timeStep);

   _simTime += _timeStep;
}

void displayInfo()
{
  String viento = "desactivado", gravedad = "desactivada";
  
  if(Viento)  
    viento = "activado";
    
  if(Gravedad)
    gravedad = "activada";
    
   pushMatrix();
   {
      camera();
      fill(0);
      textSize(20);

      text("INSTRUCCIONES", width * 0.025, height * 0.05);
      text("Pulsa la tecla 'V' para activar/desactivar el viento", width * 0.025, height * 0.075);
      text("Pulsa la tecla 'G' para activar/desactivar la gravedad", width * 0.025, height * 0.1);
      
      text("FUERZAS EXTERNAS:", width * 0.725, height * 0.05);
      text("Viento " + viento, width * 0.725, height * 0.075);
      text("Gravedad " + gravedad, width * 0.725, height * 0.1);
      
      text("Malla de tipo STRUCTURED(Marrón)", width * 0.025, height * 0.25);
      text("Malla de tipo BEND(Amarillo)", width * 0.025, height * 0.275);
      text("Malla de tipo SHEAR(Verde)", width * 0.025, height * 0.3);
   }
   popMatrix();
}
