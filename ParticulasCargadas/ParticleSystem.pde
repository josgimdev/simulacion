// Class for a particle system controller
class ParticleSystem
{
   PVector _location;
   ArrayList<Particle> _particles;
   int _nextId;

   CollisionDataType _collisionDataType;

   ParticleSystem(PVector location)
   {
      _location = location;
      _particles = new ArrayList<Particle>();
      _nextId = 0;

      _collisionDataType = CollisionDataType.NONE;
   }

   void addParticle(float mass, PVector initPos, PVector initVel, float q, float radius, color c)
   {
      PVector s = PVector.add(_location, initPos);
      _particles.add(new Particle(this, _nextId, mass, s, initVel, q, radius, c));
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

   void update(float timeStep)
   {
      for (int i = 0; i < _particles.size(); i++)
         _particles.get(i).update(timeStep);
   }

   void render()
   {
      for (int i = _particles.size() - 1; i >= 0 ; i--)
         _particles.get(i).render();
   }
}
