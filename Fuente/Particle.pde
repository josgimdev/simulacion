// Class for a simple particle with no rotational motion
public class Particle
{
   ParticleSystem _ps;  // Reference to the parent ParticleSystem
   int _id;             // Id. of the particle (-)

   float _m;            // Mass of the particle (kg)
   PVector _s;          // Position of the particle (m)
   PVector _v;          // Velocity of the particle (m/s)
   PVector _a;          // Acceleration of the particle (m/(s·s))
   PVector _F;          // Force applied on the particle (N)
   float _energy;       // Energy (J)

   float _radius;       // Radius of the particle (m)
   color _color;        // Color of the particle (RGBA)
   float _lifeSpan;     // Total time the particle should live (s)
   float _timeToLive;   // Remaining time before the particle dies (s)

   Particle(ParticleSystem ps, int id, float m, PVector s, PVector v, float radius, color c, float lifeSpan)
   {
      _ps = ps;
      _id = id;

      _m = m;
      _s = s;
      _v = v;

      _a = new PVector(0.0, 0.0);
      _F = new PVector(0.0, 0.0);
      _energy = 0.0;

      _radius = radius;
      _color = c;
      _lifeSpan = lifeSpan;
      _timeToLive = _lifeSpan;
   }

   void setPos(PVector s)
   {
      _s = s;
   }

   void setVel(PVector v)
   {
      _v = v;
   }

   PVector getForce()
   {
      return _F;
   }

   float getEnergy()
   {
      return _energy;
   }

   float getRadius()
   {
      return _radius;
   }

   float getColor()
   {
      return _color;
   }

   float getTimeToLive()
   {
      return _timeToLive;
   }

   boolean isDead()
   {
      return (_timeToLive <= 0.0);
   }

   void update(float timeStep)
   {
      _timeToLive -= timeStep;

      updateSimplecticEuler(timeStep);
      updateEnergy();
   }

   void updateSimplecticEuler(float timeStep)
   {
      updateForce();  
      // v(t+h) = v(t) + h*a(s(t),v(t))
      // s(t+h) = s(t) + h*v(t)
  
      _a.add(PVector.div(_F, _m));
      _v.add(PVector.mult(_a, timeStep));
      _s.add(PVector.mult(_v, timeStep));
   }

   void updateForce()
   {
        PVector Fg = new PVector(0, G * _m);
        PVector Fr = PVector.mult(_v, -Kd);
        _F = PVector.add(Fg, Fr);
   }

   void updateEnergy()
   {
      float Ep = _m * G * (height * 0.01 - _s.y) ;
      float Ec = _m * _v.mag() * _v.mag() * 0.5;
      _energy = Ep + Ec;
   }

   void render(boolean useTexture)
   {
      if (useTexture)
      {
         //imageMode(CENTER);
         //image(TEXTURE_FILE, _s.x * 100, _s.y * 100);
      } 
      else
      {
         fill(_color);
         circle(_s.x * 100, _s.y * 100, _radius * 100);
      }
   }
}
