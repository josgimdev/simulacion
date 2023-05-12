// Simulation and time control:
float _timeStep;        // Simulation time-step (s)
float _simTime;         // Simulated time (s)

// Output control:
boolean _computeParticleCollisions = true;
boolean _computePlaneCollisions = true;

// System variables:
ParticleSystem _ps;
ArrayList<PlaneSection> _planes;

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
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
}

void mousePressed()
{
   PVector s = new PVector(mouseX, mouseY);
   PVector v = new PVector(.0, .0);
   _ps.addParticle(M, s, v, R * 100, PARTICLES_COLOR);
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
   
   _planes.add(new PlaneSection(200, 500, 500, 200, true));
   _planes.add(new PlaneSection(500, 200, 800, 500, true));
   _planes.add(new PlaneSection(800, 500, 500, 800, true));
   _planes.add(new PlaneSection(500, 800, 200, 500, true));
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
   drawStaticEnvironment();
   drawMovingElements();
   
   updateSimulation();
   
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
   if (_computePlaneCollisions)
      _ps.computePlanesCollisions(_planes);

   if (_computeParticleCollisions)
      _ps.computeParticleCollisions();

   _ps.update(_timeStep);
   _simTime += _timeStep;
}

void displayInfo()
{
   stroke(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   fill(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   textSize(20);
   text("Para que activar/desactivar las colisiones con el plano pulsa la tecla P", width*0.3, height*0.025);
   text("Para que activar/desactivar las colisiones entre las particulas pulsa la tecla C", width*0.3, height*0.050);
}
