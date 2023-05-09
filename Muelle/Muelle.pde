// Condiciones o parametros del problema:
final float   M  = 70.0;   // Particle mass (kg)
final float   Gc = 9.8;   // Gravity constant (m/(s*s))
final PVector G  = new PVector(0.0, Gc);   // Acceleration due to gravity (m/(s*s))
final float   Kd  = 5;     // Coefieciente de rozamiento
final float   Ks = 10; //costante elastica del muelle

PVector _s  = new PVector();   // Position of the particle (pixels)
PVector _v  = new PVector();   // Velocity of the particle (pixels/s)
PVector _a  = new PVector();   // Accleration of the particle (pixels/(s*s))
PVector posl1 = new PVector(300,0);
float Lreposo = 50;
PVector posl2 = new PVector(300,Lreposo);


/////////////////////////////////////////////////////////////////////
// Parameters of the numerical integration:
float         SIM_STEP = .05;   // dt = Simulation time-step (s)
float         _simTime;
////////////////////////////////////////////////////////////////////////////77

PVector calculateAcceleration(PVector s, PVector v)
{
  //Fuerza muelle
  PVector Fm = PVector.mult(PVector.sub(s,posl2),-Ks);
  PVector Fmr = PVector.mult(v,-Kd);
  Fm.add(Fmr);
  PVector Fp = PVector.mult(G,M);
  PVector Fsum = PVector.add(Fm,Fp);
  PVector a  = Fsum.div(M);

  return a;
}

void settings()
{
    size(600, 600);
}

void setup()
{
  _s = posl2.copy();
  _v.set(.0, .0);
  _a.set(.0, .0);
  _simTime = 0;
}

void draw()
{
  background(255);
 
  drawScene();
  updateSimulation();
  
  if(_s.y < 0){
    println(_s);
  }
}

void drawScene()
{
  strokeWeight(3);
  noFill();
  circle(_s.x, _s.y, 25);
  
  strokeWeight(1);
  fill(200,0,0);
  line(posl1.x, posl1.y, _s.x, _s.y);
}


void updateSimulation()
{
  updateSimulationExplicitEuler();
  
  _simTime += SIM_STEP;
}

void updateSimulationExplicitEuler()
{
  PVector acel = calculateAcceleration(_s,_v);  
  
  _s.add(PVector.mult(_v,SIM_STEP));
  _v.add(PVector.mult(acel,SIM_STEP));
  
}

void keyPressed()
{
  if (key == 'r' || key == 'R')
  {
    setup();
  }
 
}
