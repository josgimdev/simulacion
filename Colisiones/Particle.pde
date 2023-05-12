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
   
   ArrayList<Particle> _vecinos = new ArrayList<Particle>();
      
   Particle(ParticleSystem ps, int id, float m, PVector s, PVector v, float radius, color c)
   {
      _ps = ps;
      _id = id;

      _m = m;
      _s = s;
      _v = v;

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
      
      _a = PVector.div(_F, _m);
      _v.add(PVector.mult(_a, timeStep));
      _s.add(PVector.mult(_v, timeStep));
   }

   void updateForce()
   {
     PVector Fg = new PVector(.0, G * _m);
     PVector Froz = PVector.mult(_v, -Kd * _v.mag());
     
     _F = PVector.add(Fg, Froz);
   }

   void planeCollision(ArrayList<PlaneSection> planes)
   {
     for(int i = 0; i < planes.size(); i++) 
     { 
       // Para cada plano
       PlaneSection p = planes.get(i);
       // Calculamos la distancia entre el plano y la particula
       float dist = p.getDistance(_s);
       // Comprobamos si la particula esta en el limite del plano
       boolean limit = p.checkLimits(_s);
       // Detectamos
       if(dist < _radius * .5 && limit) 
       {
         // Recolocamos
         PVector n = p.getNormal();
         float Drest = _radius * .5 - dist;
         _s = PVector.add(_s, PVector.mult(n, Drest));
         // Respondemos
         int nv = (int)_v.dot(n);
         PVector Vn = PVector.mult(n, nv);
         PVector Vt = PVector.sub(_v, Vn);
         _v = PVector.add(Vt, PVector.mult(Vn, -Cr));
       }
     }
   }

   void particleCollision()
   {
      ArrayList<Particle> particles = _ps.getParticleArray();
      
      for(int i = _id; i < particles.size(); i ++) 
      {
        // Para cada particula
        Particle p = particles.get(i);
        p._color = PARTICLES_COLOR;
        // Si no es ella misma
        if(_id != p._id) 
        {
          float dist = PVector.sub(_s, p._s).mag();
          // Detectamos
          if(dist < _radius) 
          { 
            PVector dir = PVector.sub(_s, p._s);
            float l = dir.mag() - _radius;
            dir.normalize();
            // Calculamos la fuerza
            PVector F = PVector.mult(dir, -Ke * l);
            // Separamos las particulas
            _v.add(F);
            p._v.sub(F);
          }
        }
      }
   }

   void render()
   {
      stroke(0, 0, 0);
      strokeWeight(1);
      fill(_color);
      circle(_s.x, _s.y, _radius);
   }
}
