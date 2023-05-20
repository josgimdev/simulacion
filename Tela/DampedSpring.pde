// Damped spring between two particles:
//
//    Fp1 = Fe - Fd
//    Fp2 = -Fe + Fd = -(Fe - Fd) = -Fp1
//
//    Fe = Ke·(l - l0)·eN
//    Fd = -Kd·eN·v
//
//    e = s2 - s1  : current elongation vector between the particles
//    l = |e|      : current length
//    eN = e/l   : current normalized elongation vector
//    v = dl/dt    : rate of change of length

public class DampedSpring
{
   Particle _p1;   // First particle attached to the spring
   Particle _p2;   // Second particle attached to the spring

   float _Ke;      // Elastic constant (N/m)
   float _Kd;      // Damping coefficient (kg/m)

   float _l0;      // Rest length (m)
   float _l;       // Current length (m)
   float _v;       // Current rate of change of length (m/s)

   PVector _e;     // Current elongation vector (m)
   PVector _eN;    // Current normalized elongation vector (no units)
   PVector _F;     // Force applied by the spring on particle 1 (the force on particle 2 is -_F) (N)


   DampedSpring(Particle p1, Particle p2, float Ke, float Kd, float l0)
   {
     _p1 = p1;
     _p2 = p2;
     
     _Ke = Ke;
     _Kd = Kd;
     
     _l0 = l0;
     _v = .0;
     
     _e = PVector.sub(p2._s, p1._s);
     _l = _e.mag();
     
     _F = new PVector(.0, .0, .0);
   }

   Particle getParticle1()
   {
      return _p1;
   }

   Particle getParticle2()
   {
      return _p2;
   }

   void update(float simStep)
   {
      calculateForces(simStep);
      applyForces();
   }
   
   void calculateForces(float simStep) 
   {
      float lant, incl, dl;
      PVector Fe, Fd;
      
      lant = _l;
       
      _e = PVector.sub(_p2._s, _p1._s);
      _l = _e.mag();
      _eN = PVector.div(_e, _l);
      
      incl = _l - _l0;
      
      dl = lant - _l;
      _v = dl / simStep;
      
      Fe = PVector.mult(_eN, _Ke * incl);
      Fd = PVector.mult(_eN, _Kd * _v);
      
      _F = PVector.sub(Fe, Fd);
   }
   
   void applyForces()
   {
      _p1.addExternalForce(_F);
      _p2.addExternalForce(PVector.mult(_F, -1.0));
   }
}
