// Class for a simple particle with no rotational motion
public class Particle
{
   ParticleSystem _ps;  // Reference to the parent ParticleSystem
   int _id;             // Id. of the particle

   float _m;            // Mass of the particle (kg)
   PVector _s;          // Position of the particle (m)
   PVector _v;          // Velocity of the particle (m/s)
   PVector _a;          // Acceleration of the particle (m/(s·s))
   PVector _F;          // Force applied on the particle (N)

   float _radius;       // Radius of the particle (m)
   color _color;        // Color of the particle (RGBA)
  
   float _q;
          
   Particle(ParticleSystem ps, int id, float m, PVector s, PVector v, float q, float radius, color c)
   {
      _ps = ps;
      _id = id;

      _m = m;
      _s = s;
      _v = v;
      _q = q;

      _a = new PVector(0.0, 0.0);
      _F = new PVector(0.0, 0.0);

      _radius = radius;
      _color = c;
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

   float getRadius()
   {
      return _radius;
   }

   float getColor()
   {
      return _color;
   }

   void update(float timeStep)
   {
      updateForce();

      _v.add(PVector.mult(_a, timeStep));
      _s.add(PVector.mult(_v, timeStep));
   }

   void updateForce()
   {
      PVector Fe = new PVector(0, 0);
      ArrayList<Particle> particulas = _ps.getParticleArray();
      
      if(Nebulosa) {
        if(_id != 0) {
            Particle p = particulas.get(0);
            if(_id != p._id) {
              PVector dir = PVector.sub(p._s, _s);
              float dist = dir.mag();
              dir.normalize();
              
              if(dist > _radius)
                Fe.add(dir.mult((Ka * _q * p._q) / dist));
              else
                Fe.add(new PVector(0, 0));
            }
         }
      }
      else {
       for(int i = 0; i < particulas.size(); i += 1) {
          Particle p = particulas.get(i);
          if(_id != p._id) {
            PVector dir = PVector.sub(p._s, _s);
            float dist = dir.mag();
            dir.normalize();
            
            if(dist > _radius)
              Fe.add(dir.mult((Ka * _q * p._q) / dist));
            else
              Fe.add(new PVector(0, 0));
          }
        }
      }
      
      PVector Froz = PVector.mult(_v, -Kd * _v.mag());
      
      _F = PVector.add(Fe, Froz);
      
      _a = PVector.div(_F, _m);
   }
   
   void render()
   {
      fill(_color);
      circle(_s.x * 100, _s.y * 100, _radius * 100);
   }
}
