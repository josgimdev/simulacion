// Simulation and time control:
float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)

// Output control:
boolean _writeToFile = true;
boolean _useTexture = false;
PrintWriter _output;


// Variables to be monitored:
float _energy;                // Total energy of the system (J)
int _numParticles;            // Total number of particles
PVector _sInicial;
PVector _vInicial;
float _tiempoI;
ParticleSystem _ps;

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
   else if (key == 't' || key == 'T')
      _useTexture = !_useTexture;
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
}

void initSimulation()
{
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, E, n, m");
   }

   _simTime = 0.0;
   _timeStep = TS;
   
   _ps = new ParticleSystem(new PVector(POS_X, POS_Y + POS_Y/2));
   
   _sInicial = POS_INICIAL;
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
   drawStaticEnvironment();
   drawMovingElements();

   updateSimulation();
   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + ", " + _energy + ", " + _numParticles + ", "+ _tiempoI);
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
}

void drawMovingElements()
{
   _ps.render(_useTexture);
}

void updateSimulation()
{
   for(int i = 0; i < NT * _timeStep; i = i + 1) {
     _vInicial = new PVector(random(-APERTURA, APERTURA), V_INICIAL * -1);
     _ps.addParticle(M, _sInicial, _vInicial, R, C, L);
   }
   _ps.update(_timeStep);
   _energy = _ps.getTotalEnergy();
   _simTime += _timeStep;
   _numParticles = _ps._particles.size();
   
   _tiempoI = millis();
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
   text("Draw: " + frameRate + "fps", width*0.025, height*0.05);
   text("Simulation time step = " + _timeStep + " s", width*0.025, height*0.075);
   text("Simulated time = " + _simTime + " s", width*0.025, height*0.1); 
   text("Number of particles: " + _numParticles, width*0.025, height*0.125);
   text("Total energy: " + _energy/1000.0 + " kJ", width*0.025, height*0.15);
}
