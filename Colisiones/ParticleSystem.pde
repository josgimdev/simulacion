// Class for a particle system controller
class ParticleSystem
{
   PVector _location;
   ArrayList<Particle> _particles;
   int _nextId;

   ParticleSystem(PVector location)
   {
      _location = location;
      _particles = new ArrayList<Particle>();
      _nextId = 0;
   }

   void addParticle(float m, PVector s, PVector v, float r, color c)
   {
      PVector _s = PVector.add(_location, s);
      _particles.add(new Particle(this, _nextId, m, _s, v, r, c));
      _nextId++;
   }

   void restart()
   {
      _particles.clear();
   }

   int getNumParticles()
   {
      return _particles.size();
   }

   ArrayList<Particle> getParticleArray()
   {
      return _particles;
   }

   void computePlanesCollisions(ArrayList<PlaneSection> planes)
   {
      for (int i = 0; i < _particles.size(); i++)
         _particles.get(i).planeCollision(planes);
   }

   void computeParticleCollisions()
   {
      for (int i = 0; i < _particles.size(); i++)
         _particles.get(i).particleCollision();
   }

   void update(float timeStep)
   {
      for (int i = 0; i < _particles.size(); i++)
         _particles.get(i).update(timeStep);
   }

   void render()
   {
      for (int i = 0; i < _particles.size(); i++)
         _particles.get(i).render();
   }
}
