static int _lastParticleId = 0;

public class Particle
{
   int _id;            // Unique id for each particle

   PVector _s;         // Position (m)
   PVector _v;         // Velocity (m/s)
   PVector _a;         // Acceleration (m/(s*s))
   PVector _F;         // Force (N)
   float _m;           // Mass (kg)
   PVector _N;         // Normales promedio

   boolean _noGravity; // If true, the particle will not be affected by gravity
   boolean _clamped;   // If true, the particle will not move


   Particle(PVector s, PVector v, float m, boolean noGravity, boolean clamped)
   {
      _id = _lastParticleId++;

      _s = s.copy();
      _v = v.copy();
      _m = m;

      _noGravity = noGravity;
      _clamped = clamped;

      _a = new PVector(0.0, 0.0, 0.0);
      _F = new PVector(0.0, 0.0, 0.0);
      _N = new PVector(0.0, 0.0, 0.0);
   }

   void update(float simStep)
   {
      if (_clamped || _s.z < -8)
         return;

      if (!_noGravity)
         updateWeightForce();

      _a = PVector.div(_F, _m);
      _v.add(PVector.mult(_a, simStep));
      _s.add(PVector.mult(_v, simStep));
      _F.set(0.0, 0.0, 0.0);
   }

   int getId()
   {
      return _id;
   }

   PVector getPosition()
   {
      return _s;
   }

   void setPosition(PVector s)
   {
      _s = s.copy();
      _a.set(0.0, 0.0, 0.0);
      _F.set(0.0, 0.0, 0.0);
   }
   
   void setNormalP(PVector n){
     _N = n.copy();
   }

   void setVelocity(PVector v)
   {
      _v = v.copy();
   }

   void updateWeightForce()
   {
      PVector weigthForce = new PVector(0, 0, -G*_m);
      _F.add(weigthForce);
   }
   
   void updateWindForce(){
     float viento;
     PVector WindForce = new PVector(0, 0, 10);
     viento = _N.dot(WindForce);
    
     WindForce.mult(viento);
     _F.add(WindForce);
   }
   
   void addExternalForce(PVector F)
   {
      _F.add(F);
   }
}
