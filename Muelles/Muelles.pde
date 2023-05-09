// Problem description:
// PRACTICA 1- PROBLEMA 1
// Simular el movimiento de una particula sostenida por 4 muelles.
//

// Differential equations:
//
// dr/dt= (M*G + Kd * v(t)^2 + Ki(Li(t)-L0i))/M
// ds/dt = v(t)
//


// Simulation and time control:

IntegratorType _integrator = IntegratorType.HEUN;   // ODE integration method
float _timeStep;        // Simulation time-step (s)
float _simTime;   // Simulated time (s)


// Output control:

boolean _writeToFile = false;
PrintWriter _output;


// Variables to be solved:
PVector _s = new PVector();   // Position of the particle (m)
PVector _v = new PVector();   // Velocity of the particle (m/s)
PVector _a = new PVector();   // Accleration of the particle (m/(s*s))
float _energy;                // Total energy of the particle (J)


// Springs:
Spring _spp[] = new Spring[4];

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
   _v.set(0,0);
   
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
   _v.set(0.0, 0.0, 0.0);
   _a.set(0.0, 0.0, 0.0);
    
   // Inicialización de los muelles
   _spp[0] = new Spring(C1, S0, K1e, L01);
   _spp[1] = new Spring(C2, S0, K2e, L02);
   _spp[2] = new Spring(C3, S0, K3e, L03);
   _spp[3] = new Spring(C4, S0, K4e, L04);
}

void restartSimulation()
{
   _simTime = 0.0;
   _timeStep = TS;

   _s = S0.copy();
   _v.set(0.0, 0.0, 0.0);
   _a.set(0.0, 0.0, 0.0);
    
   // Inicialización de los muelles
   _spp[0] = new Spring(C1, S0, K1e, L01);
   _spp[1] = new Spring(C2, S0, K2e, L02);
   _spp[2] = new Spring(C3, S0, K3e, L03);
   _spp[3] = new Spring(C4, S0, K4e, L04);
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
   // Cuadrado
   line(_spp[0]._pos1.x, _spp[0]._pos1.y, _spp[1]._pos1.x, _spp[1]._pos1.y);
   line(_spp[1]._pos1.x, _spp[1]._pos1.y, _spp[3]._pos1.x, _spp[3]._pos1.y);
   line(_spp[0]._pos1.x, _spp[0]._pos1.y, _spp[2]._pos1.x, _spp[2]._pos1.y);
   line(_spp[2]._pos1.x, _spp[2]._pos1.y, _spp[3]._pos1.x, _spp[3]._pos1.y);
   
   // Pintamos los muelles
   for(Spring sp:_spp) {
     line(sp._pos1.x, sp._pos1.y, sp._pos2.x, sp._pos2.y);
     circle(sp._pos1.x, sp._pos1.y, OBJECTS_SIZE);
   }
}

void drawMovingElements()
{
   fill(MOVING_ELEMENTS_COLOR[0], MOVING_ELEMENTS_COLOR[1], MOVING_ELEMENTS_COLOR[2]);
   circle(_s.x, _s.y, OBJECTS_SIZE);
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
   // 1- Energía cinética
   // 1.1- Calculamos el modulo de la velocidad
   //1.2- Aplicamos la formula de la energía cinética.
   float Ek = (M * _v.mag() * _v.mag()) * .5;
   
   // 2- Energía potencial gravitatoria
   // Aplicamos la formula de la Energía potencial gravitatoria,
   // calculamos h tomando como suelo la parte inferior de la ventana.
   float Eg = M * G * (height-_s.y);
   
   //3- Energía potencial elastica de los muelles
   float Ec = 0;
   // Recorremos los muelles llamado a la funcion 
   // que calcula la energía de cada muelle
   for(Spring sp : _spp) {
     Ec +=(sp.getEnergy());
   }
   // Suma de todas las energías
   _energy = Ek + Eg + Ec;
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
  // s(t+h) = s(t) + h*v(t)    (V ahora es v+1)
  
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

    // .5
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

   _a = calculateAcceleration(_s, _v);
  PVector K1v = PVector.mult(_a, _timeStep);
  PVector K1s = PVector.mult(_v, _timeStep);

  PVector sk1 = PVector.add(_s, PVector.mult(K1s,0.5));
  PVector vk1 = PVector.add(_v, PVector.mult(K1v,0.5));

  PVector ak1 = calculateAcceleration(sk1,vk1);

  PVector K2v = PVector.mult(ak1, _timeStep);
  PVector K2s = PVector.mult(PVector.add(_v, PVector.mult(K1v, 0.5)), _timeStep);

  PVector sk2 = PVector.add(_s, PVector.mult(K2s,0.5));
  PVector vk2 = PVector.add(_v, PVector.mult(K2v,0.5));

  PVector ak2 = calculateAcceleration(sk2,vk2);

  PVector K3v = PVector.mult(ak2, _timeStep);
  PVector K3s = PVector.mult(PVector.add(_v, PVector.mult(K2v, 0.5)), _timeStep);

  PVector sk3 = PVector.add(_s, K3s);
  PVector vk3 = PVector.add(_v, K3v);

  PVector ak3 = calculateAcceleration(sk3,vk3);

  PVector K4v = PVector.mult(ak3, _timeStep);
  PVector K4s = PVector.mult(PVector.add(_v, K3v), _timeStep);

  PVector v = PVector.add(K1v, PVector.mult(K2v, 2));
  v.add(PVector.mult(K3v, 2));
  v.add(K4v);
  v.div(6);
  _v.add(v);

  PVector s = PVector.add(K1s, PVector.mult(K2s, 2));
  s.add(PVector.mult(K3s, 2));
  s.add(K4s);
  s.div(6);
  _s.add(s);
}

void updateSimulationHeun() {
  
    _a = calculateAcceleration(_s, _v);
    
    // Predicción: 
    // s(t+h) = s(t) + h*v(t)
    // v(t+h) = v(t) + h*a(s(t),v(t))
    PVector sP = PVector.add(_s, PVector.mult(_v, _timeStep));
    PVector vP = PVector.add(_v, PVector.mult(_a, _timeStep));
    
    PVector aP = calculateAcceleration(sP, vP);
    
    // Corrección:
    // s(t+h) = s(t) + h*(v(t) + v(t+h))/2
    // v(t+h) = v(t) + h*(a(s(t),v(t)) + a(s(t+h),v(t+h)))/2
    PVector sC = PVector.add(_s, PVector.mult(PVector.add(_v, vP), _timeStep * .5));
    PVector vC = PVector.add(_v, PVector.mult(PVector.add(_a, aP), _timeStep * .5));

    // Actualización de los valores de posición y velocidad
    _s = sC;
    _v = vC;
}


PVector calculateAcceleration(PVector s, PVector v)
{    
    // Fuerza gravitatoria
    PVector Fg = new PVector(.0, G*M);
    
    // Fuerza elástica 
    PVector Fe = new PVector(.0, .0);
  
    for(Spring sp : _spp) {
      sp.setPos2(s);
      sp.update();
      Fe.add(sp.getForce());
    }
    
    // Fuerza de rozamiento con el aire
    PVector Froz = PVector.mult(v, -Kd * v.mag());
    
    // Fuerza neta
    PVector Fn = PVector.add(PVector.add(Fe, Fg), Froz);
    
    // Aceleración
    PVector a = PVector.div(Fn, M);
  
    return a;
}
