// Problem description:
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

// Control olas
float _amplitude = 0.0;
float _wavelength = 0.0;
float _speed = 0.0;
PVector _dir = new PVector(0.0, 0.0, 0.0);

boolean keyA, keyL, keyV, keyX, keyY, keyZ;

// System variables:
HeightMap _map;
PImage _img;

// Main code:
public void settings()
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
   _camera.rotateX(QUARTER_PI / -2.0);
   _camera.rotateZ(PI);
   _camera.setDistance(10);

   initSimulation();
}

void keyPressed()
{
  if (key == 's' || key == 'S')
  {
    _map.addWave(new WaveDirectional(_amplitude, _dir, _wavelength, _speed));
  }
  
  if (key == 'w' || key == 'W')
  {
    _map.addWave(new WaveRadial(_amplitude, _dir, _wavelength, _speed));
  }
  
  if (key == 'g' || key == 'G')
  {
    _map.addWave(new WaveGerstner(_amplitude, _dir, _wavelength, _speed));
  }
  
  if (key == 't' || key == 'T')
  {
    DRAW_MODE = !DRAW_MODE;
  }
  
  if (key == 'r' || key == 'R')
  {
    _map._waves.clear();
  }
  
  if (keyA)
      if (keyCode == UP)
        _amplitude += 0.05;
      else if (keyCode == DOWN)
        _amplitude -= 0.05;
  
  if (keyL)
    if (keyCode == UP)
      _wavelength += 0.5;
    else if (keyCode == DOWN)
      _wavelength -= 0.5;
  
  if (keyV)
    if (keyCode == UP)
      _speed += 0.5;
    else if (keyCode == DOWN)
      _speed -= 0.5;
  
  if (keyX)
    if (keyCode == UP)
      _dir.x += 1;
    else if (keyCode == DOWN)
      _dir.x -= 1;
    
  if (keyY)
    if (keyCode == UP)
      _dir.y += 1;
    else if (keyCode == DOWN)
      _dir.y -= 1;
    
  if (keyZ)
    if (keyCode == UP)
      _dir.z += 1;
    else if (keyCode == DOWN)
      _dir.z -= 1;
  
  if (key == 'a' || key == 'A')
    keyA = true;
  if (key == 'l' || key == 'L')
    keyL = true;
  if (key == 'v' || key == 'V')
    keyV = true;
  if (key == 'x' || key == 'X')
    keyX = true;
  if (key == 'y' || key == 'Y')
    keyY = true;  
  if (key == 'z' || key == 'Z')
    keyZ = true;
  
}

void keyReleased() 
{
  if (key == 'a' || key == 'A')
    keyA = false;
  if (key == 'l' || key == 'L')
    keyL = false;
  if (key == 'v' || key == 'V')
    keyV = false;
  if (key == 'x' || key == 'X')
    keyX = false;
  if (key == 'y' || key == 'Y')
    keyY = false;  
  if (key == 'z' || key == 'Z')
    keyZ = false;
}

void initSimulation()
{
   _simTime = 0.0;
   _timeStep = TS*TIME_ACCEL;
   _elapsedTime = 0.0;
   
   keyA = keyL = keyV = keyX = keyY = keyZ = false;
   
   _img = loadImage("textura.jpg");
   
   _map = new HeightMap(N_X, N_Y, D_X, D_Y);
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
   //drawAxis();
}

void drawDynamicEnvironment()
{
   _map.render();
}

void updateSimulation()
{       
   _map.update(_simTime);

   _simTime += _timeStep;
}

void displayInfo()
{  
   float textSize = 20;
   
   pushMatrix();
   {          
      camera();
      noStroke();
      textSize(textSize);
      fill(0xff000000);
      
      float offsetX = width * 0.525;
      float offsetY = height * 0.025;
      
      int i = 0;
      
      text ("Amplitud: " + _amplitude, offsetX, offsetY + textSize * (++i));
      text ("Longitud de onda: " + _wavelength , offsetX, offsetY + textSize * (++i));
      text ("Velocidad de propagación: " + _speed, offsetX, offsetY + textSize * (++i)); 
      text ("Dirección: " + _dir, offsetX, offsetY + textSize * (++i)); 
      i++;
      text ("l + 'up' or 'down': aumentar o disminuir la longitud", offsetX, offsetY + textSize * (++i));
      text ("v + 'up' or 'down': aumentar o disminuir la 'velocidad'", offsetX, offsetY + textSize * (++i));
      text ("a + 'up' or 'down': aumentar o disminuir la amplitud", offsetX, offsetY + textSize * (++i));
      text ("'(x, y, z)' + 'up' or 'down': modificar la dirección", offsetX, offsetY + textSize * (++i));
   }
   popMatrix();
   
   pushMatrix();
   {
      camera();
      fill(0);
      textSize(textSize);
      
      float offsetX = width * 0.025;
      float offsetY = height * 0.025;
      
      int i = 0;
      
      text("Frame rate = " + 1.0/_deltaTimeDraw + " fps", offsetX, offsetY + textSize * (++i));
      text("Elapsed time = " + _elapsedTime + " s", offsetX, offsetY + textSize * (++i));
      text("Simulated time = " + _simTime + " s ", offsetX, offsetY + textSize * (++i));
      i++;
      text ("s: Onda sinusoidal", offsetX, offsetY + textSize * (++i));
      text ("w: Onda radial", offsetX, offsetY + textSize * (++i));
      text ("g: Onda de Gerstner", offsetX, offsetY + textSize * (++i));
      text ("t: Textura o malla", offsetX, offsetY + textSize * (++i));
      text ("r: Reset", offsetX, offsetY + textSize * (++i));
   }
   popMatrix();
}

void drawAxis()
{
  stroke(255, 0, 0);
  line(0, 0, 0, 0, 200, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, -200, 0, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 200);
}
