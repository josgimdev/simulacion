// Problem description: //<>//
// PRACTICA 1-  PROBLEMA 2
// Sistemas de 2 particulas con carga (+ y -).
//

// Differential equations:
//
// dr/dt = (K *(q*Q)/r(t)^2)
// ds/dt = v(t)
//


// Simulation and time control:

IntegratorType _integrator = IntegratorType.NONE;   // ODE integration method
float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)


// Output control:

boolean _writeToFile = false;
PrintWriter _output;


// Variables to be solved:

PVector _s = new PVector();   // Position of the particle (m)
PVector _v = new PVector();   // Velocity of the particle (m/s)
PVector _a = new PVector();   // Accleration of the particle (m/(s*s))
float _energy;                // Total energy of the particle (J)


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

void mouseClicked()
{
   //Vector que contiene las coordenadas del click
   PVector mouse = new PVector(mouseX, mouseY);
   
   //Posicion particula = posicion del raton
   _s.set(mouse.x, mouse.y);
   
   //Velocidad =0
   _v = V0.copy();
   
   //Aceleracion =0
   _a.set(0,0);
   
}

void keyPressed()
{
   if (key == 'r' || key == 'R')
      restartSimulation();
   else if (key == ' ')
      _integrator = IntegratorType.NONE;
   else if (key == '1')
      _integrator = IntegratorType.EXPLICIT_EULER;
   else if (key == '2')
      _integrator = IntegratorType.SIMPLECTIC_EULER;
   else if (key == '3')
      _integrator = IntegratorType.RK2;
   else if (key == '4')
      _integrator = IntegratorType.RK4;
   else if (key == '5')
      _integrator = IntegratorType.HEUN;
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
      writeToFile("t, E, sx, sy, vx, vy, ax, ay");
   }

   _simTime = 0.0;
   _timeStep = TS;

   _s = S0.copy(); 
   _v = V0.copy();
   _a = A0.copy();  
   _energy=0.0;
}

void restartSimulation()
{
   initSimulation();
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
   calculateEnergy();
   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + ", " + _energy + ", " + _s.x + ", " + _s.y + ", " + _v.x + ", " + _v.y + "," + _a.x + ", " + _a.y);
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
   fill(STATIC_ELEMENTS_COLOR[0], STATIC_ELEMENTS_COLOR[1], STATIC_ELEMENTS_COLOR[2]);
   circle(C.x,C.y, OBJECTS_SIZE);
}

void drawMovingElements()
{
   fill(MOVING_ELEMENTS_COLOR[0], MOVING_ELEMENTS_COLOR[1], MOVING_ELEMENTS_COLOR[2]);
    circle(_s.x,_s.y, OBJECTS_SIZE);
}

void updateSimulation()
{
   switch (_integrator)
   {
      case EXPLICIT_EULER:
         updateSimulationExplicitEuler();
         break;
   
      case SIMPLECTIC_EULER:
         updateSimulationSimplecticEuler();
         break;
   
      case HEUN:
         updateSimulationHeun();
         break;
   
      case RK2:
         updateSimulationRK2();
         break;
   
      case RK4:
         updateSimulationRK4();
         break;
   
      case NONE:
      default:
   }

   _simTime += _timeStep;
}

void calculateEnergy()
{
   //1- Energia cinetica
   float Ek = M * _v.magSq()*0.5;
   //2- Energia potencial electroestática
   //2.1- Calculo de la distancia entre particulas
   PVector dir= PVector.sub(_s,C);
   float dis = dir.mag();
   //2.2- Aplicamos la formula de la energia potencial electroestática
   float Ee = (K*Q*q/dis);
   
   //3- Suma de la energia total del sistema
   _energy = Ek + Ee;
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
   text("Integrator: " + _integrator.toString(), width*0.025, height*0.075);
   text("Simulation time step = " + _timeStep + " s", width*0.025, height*0.1);
   text("Simulated time = " + _simTime + " s", width*0.025, height*0.125);
   text("Energy: " + _energy/1000.0 + " kJ", width*0.025, height*0.15);
   text("Speed: " + _v.mag()/1000.0 + " km/s", width*0.025, height*0.175);
   text("Acceleration: " + _a.mag()/1000.0 + " km/s2", width*0.025, height*0.2);
}

void updateSimulationExplicitEuler()
{
   // s(t+h) = s(t) + h*v(t)
   // v(t+h) = v(t) + h*a(s(t),v(t))

   _a = calculateAcceleration(_s, _v);
   
   _s.add(PVector.mult(_v, _timeStep));
   _v.add(PVector.mult(_a, _timeStep));
}

void updateSimulationSimplecticEuler()
{
   // v(t+h) = v(t) + h*a(s(t),v(t))
   // s(t+h) = s(t) + h*v(t)
   
   _a = calculateAcceleration(_s, _v);
   
   _v.add(PVector.mult(_a, _timeStep));
   _s.add(PVector.mult(_v, _timeStep));
}

void updateSimulationRK2()
{
    PVector s1, v1, s2, v2;
    
    _a = calculateAcceleration(_s, _v);
    
    // K1
    v1 = PVector.mult(_a, _timeStep);
    s1 = PVector.mult(_v, _timeStep);
    
    v2 = PVector.add(_v, PVector.mult(v1, .5));
    s2 = PVector.add(_s, PVector.mult(s1, .5));
    _a = calculateAcceleration(_s, _v);
  
    // K2
    v2 = PVector.mult(_a, _timeStep);
    s2 = PVector.mult(PVector.add(_v, PVector.mult(v1, .5)), _timeStep);
    
    // Update
    _s.add(s2);
    _v.add(v2);
}

void updateSimulationRK4()
{
    PVector s1, v1, a1, s2, v2, a2, s3, v3, a3, s4, v4, sA, vA;
    
    _a = calculateAcceleration(_s, _v);
    
    // K1
    v1 = PVector.mult(_a, _timeStep);
    s1 = PVector.mult(_v, _timeStep);
    
    // A1
    sA = PVector.add(_s, PVector.mult(s1, .5));
    vA = PVector.add(_v, PVector.mult(v1, .5));
    a1 = calculateAcceleration(sA, vA);
    
    // K2
    v2 = PVector.mult(a1, _timeStep);
    s2 = PVector.mult(PVector.add(_v, PVector.mult(v1, .5)), _timeStep);
    
    // A2
    sA = PVector.add(_s, PVector.mult(s2, .5));
    vA = PVector.add(_v, PVector.mult(v2, .5));
    a2 = calculateAcceleration(sA, vA);
  
    // K3
    v3 = PVector.mult(a2, _timeStep);
    s3 = PVector.mult(PVector.add(_v, PVector.mult(v2, .5)), _timeStep);
    
    // A3
    sA = PVector.add(_s, s3);
    vA = PVector.add(_v, v3);
    a3 = calculateAcceleration(sA, vA);
    
    // K4
    v4 = PVector.mult(a3, _timeStep);
    s4 = PVector.mult(PVector.add(_v, v3), _timeStep);
    
    // Update
    _v.add(PVector.add(PVector.add(v1, PVector.mult(v2, 2)), PVector.add(PVector.mult(v3, 2), v4)).div(6));
    _s.add(PVector.add(PVector.add(s1, PVector.mult(s2, 2)), PVector.add(PVector.mult(s3, 2), s4)).div(6));
}



void updateSimulationHeun()
{
    PVector s1, v1, a1, s2, v2, a2;
    
    _a = calculateAcceleration(_s, _v);
    
    s1 = _s;
    v1 = _v;
    
    a1 = calculateAcceleration(_s, _v);
    
    s2 = PVector.add(s1, PVector.mult(v1, _timeStep));
    v2 = PVector.add(v1, PVector.mult(a1, _timeStep));
    
    a2 = calculateAcceleration(s2, v2);
  
    // Update
    _s.add(PVector.mult(PVector.add(v1, v2), _timeStep * .5));
    _v.add(PVector.mult(PVector.add(a1, a2), _timeStep * .5));
}

PVector calculateAcceleration(PVector s, PVector v)
{
   PVector a = new PVector();
   //Vector para la Fuerza
   PVector F = new PVector();
   //Vector direccion de la fuerza (entre las dos particulas)
   PVector dir= PVector.sub(s,C);
   //modulo de la direccion para saber la distancia
   float dis = dir.mag();
   //normalizo la direccion para saber el vecto unitario de la fuerza
   dir.normalize();
   //Calculo de la fuerza segun la ley de coulomb
   F = dir.mult((K *q*Q) /(dis*dis));
   //Calculo de la aceleracion (Newton)
   a= PVector.div(F,M);

   return a;
}
