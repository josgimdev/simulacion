// Problem description:
//
//
//

// Simulation and time control:

float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)

// Output control:

boolean _writeToFile = true;
PrintWriter _output;
boolean _computeParticleCollisions = true;
boolean _computePlaneCollisions = true;

// System variables:
ParticleSystem _ps;
// Performance measures:
float _Tint = 0.0;    // Integration time (s)
float _Tdata = 0.0;   // Data-update time (s)
float _Tcol1 = 0.0;   // Collision time particle-plane (s)
float _Tcol2 = 0.0;   // Collision time particle-particle (s)
float _Tsim = 0.0;    // Total simulation time (s) Tsim = Tint + Tdata + Tcol1 + Tcol2
float _Tdraw = 0.0;   // Rendering time (s)

// Main code:

void settings()
{
   size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
   frameRate(DRAW_FREQ);
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);

   initSimulation();
}

void stop()
{
   endSimulation();
}

void keyPressed()
{
   if (key == 'r' || key == 'R')
      restartSimulation();
   else if (key == 'c' || key == 'C')
      _computeParticleCollisions = !_computeParticleCollisions;
   else if (key == 'p' || key == 'P')
      _computePlaneCollisions = !_computePlaneCollisions;
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
}

void mousePressed()
{
   PVector mouse = new PVector(mouseX * .01 - DISTANCIA_X * .5, mouseY * .01 - DISTANCIA_Y * .5);
   float rango = .2;
   
   float m = random(Mmin, Mmax);
   PVector pos = new PVector(random(mouse.x - rango, mouse.x + rango), random(mouse.y - rango, mouse.y + rango));
   PVector v = new PVector(0, 0);
   float q = random(Qmin, Qmax);
   
   _ps.addParticle(m, pos, v, q, R, PARTICLES_COLOR);
}

void initSimulation()
{
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, n, Tsim");
   }

   _simTime = 0.0;
   _timeStep = TS;

   initParticleSystem();
}


void initParticleSystem()
{
   _ps = new ParticleSystem(new PVector(DISTANCIA_X * .5, DISTANCIA_Y * .5));
   
   if(Nebulosa) {
     
     float m = random(Mmin, Mmax);
     PVector pos = new PVector(0, 0);
     PVector v = new PVector(0, 0);
     float q =random(Qmin, Qmax);
     _ps.addParticle(m, pos, v, q, R, PARTICLES_COLOR1);
     
     for(int i = 1; i < P; i += 1) {
       m = random(Mmin, Mmax);
       pos = new PVector(random(-DISTANCIA_X, DISTANCIA_X), random(-DISTANCIA_Y, DISTANCIA_Y));
       v = new PVector(0, 0);
       q = random(Qmin, Qmax);
       _ps.addParticle(m, pos, v, q, R, PARTICLES_COLOR);
     }
   }
   else {
     for(int i = 0; i < P; i += 1) {
       float m = random(Mmin, Mmax);
       PVector pos = new PVector(random(-DISTANCIA_X, DISTANCIA_X), random(-DISTANCIA_Y, DISTANCIA_Y));
       PVector v = new PVector(0, 0);
       float q = random(Qmin, Qmax);
       _ps.addParticle(m, pos, v, q, R, PARTICLES_COLOR);
     }
   }
}

void restartSimulation()
{
   //
   //
   //
}

void endSimulation()
{
   if (_writeToFile)
   {
      _output.flush();
      _output.close();
   }
}

void draw()
{
   float time = millis();
   drawStaticEnvironment();
   drawMovingElements();
   _Tdraw = millis() - time;

   time = millis();
   updateSimulation();
   _Tsim = millis() - time;

   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + ", " + _ps.getNumParticles() + "," + _Tsim);
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
}

void drawMovingElements()
{
   _ps.render();
}

void updateSimulation()
{
   float time = millis();
   _ps.update(_timeStep);
   _simTime += _timeStep;
   _Tint = millis() - time;
}

void writeToFile(String data)
{
   _output.println(data);
}

void displayInfo()
{
   stroke(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   fill(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   textSize(20);
   text("Time integrating equations: " + _Tint + " ms", width*0.3, height*0.025);
   text("Time updating collision data: " + _Tdata + " ms", width*0.3, height*0.050);
   text("Time computing collisions (planes): " + _Tcol1 + " ms", width*0.3, height*0.075);
   text("Time computing collisions (particles): " + _Tcol2 + " ms", width*0.3, height*0.100);
   text("Total simulation time: " + _Tsim + " ms", width*0.3, height*0.125);
   text("Time drawing: " + _Tdraw + " ms", width*0.3, height*0.150);
   text("Total step time: " + (_Tsim + _Tdraw) + " ms", width*0.3, height*0.175);
   text("Fps: " + frameRate + "fps", width*0.3, height*0.200);
   text("Simulation time step = " + _timeStep + " s", width*0.3, height*0.225);
   text("Simulated time = " + _simTime + " s", width*0.3, height*0.250);
   text("Number of particles: " + _ps.getNumParticles(), width*0.3, height*0.275);
}
