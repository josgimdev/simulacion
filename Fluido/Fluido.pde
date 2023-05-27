// Simulation and time control:
float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)

// Output control:
boolean _computeParticleCollisions = true;
boolean _computePlaneCollisions = true;

// System variables:
ParticleSystem _ps;
ArrayList<PlaneSection> _planes;
HashTable _hs;
Grid _gd;

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

void keyPressed()
{
   if (key == 'r' || key == 'R')
      restartSimulation();
   else if (key == 'c' || key == 'C')
      _computeParticleCollisions = !_computeParticleCollisions;
   else if (key == 'p' || key == 'P')
      _computePlaneCollisions = !_computePlaneCollisions;
   else if (key == 'n' || key == 'N')
      _ps.setCollisionDataType(CollisionDataType.NONE);
   else if (key == 'g' || key == 'G')
      _ps.setCollisionDataType(CollisionDataType.GRID);
   else if (key == 'h' || key == 'H')
      _ps.setCollisionDataType(CollisionDataType.HASH);
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
}

void mousePressed()
{
   for(int i = 0; i < 50; i++) {
     PVector posInicial = new PVector(random(mouseX * 0.9, mouseX * 1.1), random(mouseY * 0.9, mouseY * 1.1));
     PVector velInicial = new PVector(.0, .0);
     _ps.addParticle(M, posInicial, velInicial, R * 100, PARTICLES_COLOR);
  }
}

void initSimulation()
{
   _simTime = 0.0;
   _timeStep = TS;

   initPlanes();
   initParticleSystem();
}

void initPlanes()
{
   _planes = new ArrayList<PlaneSection>();
   
   _planes.add(new PlaneSection(width * 0.5 - 300, height * 0.5 - 250, width * 0.5 - 500, height * 0.5 - 250, false));
   _planes.add(new PlaneSection(width * 0.5 - 500, height * 0.5 - 250, width * 0.5 - 500, height * 0.5 + 250, false));
   _planes.add(new PlaneSection(width * 0.5 - 500, height * 0.5 + 250, width * 0.5 - 400, height * 0.5 + 350, false));
   _planes.add(new PlaneSection(width * 0.5 - 400, height * 0.5 + 350, width * 0.5 + 400, height * 0.5 + 350, false));
   _planes.add(new PlaneSection(width * 0.5 + 400, height * 0.5 + 350, width * 0.5 + 500, height * 0.5 + 250, false));
   _planes.add(new PlaneSection(width * 0.5 + 500, height * 0.5 + 250, width * 0.5 + 500, height * 0.5 - 250, false));
   _planes.add(new PlaneSection(width * 0.5 + 300, height * 0.5 - 250, width * 0.5 + 300, height * 0.5 + 50, false));
   _planes.add(new PlaneSection(width * 0.5 + 300, height * 0.5 + 50, width * 0.5 + 200, height * 0.5 + 150, false));
   _planes.add(new PlaneSection(width * 0.5 + 200, height * 0.5 + 150, width * 0.5 - 200, height * 0.5 + 150, false));
   _planes.add(new PlaneSection(width * 0.5 - 200, height * 0.5 + 150, width * 0.5 - 300, height * 0.5 + 50, false));
   _planes.add(new PlaneSection(width * 0.5 - 300, height * 0.5 + 50, width * 0.5 - 300, height * 0.5 - 250, false));
}

void initParticleSystem()
{
   _ps = new ParticleSystem(new PVector());
}

void restartSimulation()
{
   initSimulation();
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
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
   for (int i = 0; i < _planes.size(); i++)
      _planes.get(i).render();
}

void drawMovingElements()
{
   _ps.render();
}

void updateSimulation()
{
  // TIME
   float time = millis();
   
   if (_computePlaneCollisions)
      _ps.computePlanesCollisions(_planes);
   _Tcol1 = millis() - time;

   time = millis();
   if (_computeParticleCollisions)
      _ps.updateCollisionData();
   _Tdata = millis() - time;

   time = millis();
   if (_computeParticleCollisions)
      _ps.computeParticleCollisions();
   _Tcol2 = millis() - time;

   time = millis();
   _ps.update(_timeStep);
   _simTime += _timeStep;
   _Tint = millis() - time;
}

void displayInfo()
{
   stroke(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   fill(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   textSize(20);
   text("Time integrating equations: " + _Tint + " ms", width*0.4, height*0.025);
   text("Time updating collision data: " + _Tdata + " ms", width*0.4, height*0.050);
   text("Time computing collisions (planes): " + _Tcol1 + " ms", width*0.4, height*0.075);
   text("Time computing collisions (particles): " + _Tcol2 + " ms", width*0.4, height*0.100);
   text("Total simulation time: " + _Tsim + " ms", width*0.4, height*0.125);
   text("Time drawing: " + _Tdraw + " ms", width*0.4, height*0.150);
   text("Total step time: " + (_Tsim + _Tdraw) + " ms", width*0.4, height*0.175);
   text("Fps: " + frameRate + "fps", width*0.4, height*0.200);
   text("Simulation time step = " + _timeStep + " s", width*0.4, height*0.225);
   text("Simulated time = " + _simTime + " s", width*0.4, height*0.250);
   text("Number of particles: " + _ps.getNumParticles(), width*0.4, height*0.275);
}
