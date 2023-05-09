// Class for a particle system controller
class ParticleSystem
{
   PVector _location;
   ArrayList<Particle> _particles;
   int _nextId;

   Grid _grid;
   HashTable _hashTable;
   CollisionDataType _collisionDataType;

   ParticleSystem(PVector location)
   {
      _location = location;
      _particles = new ArrayList<Particle>();
      _nextId = 0;

      _grid = new Grid(SC_GRID);
      _hashTable = new HashTable(SC_HASH, NC_HASH);
      _collisionDataType = CollisionDataType.NONE;
   }

   void addParticle(float mass, PVector initPos, PVector initVel, float radius, color c)
   {
      PVector s = PVector.add(_location, initPos);
      _particles.add(new Particle(this, _nextId, mass, s, initVel, radius, c));
      _nextId++;
   }

   void restart()
   {
      _particles.clear();
   }

   void setCollisionDataType(CollisionDataType collisionDataType)
   {
      _collisionDataType = collisionDataType;
   }

   int getNumParticles()
   {
      return _particles.size();
   }

   ArrayList<Particle> getParticleArray()
   {
      return _particles;
   }

   void updateCollisionData()
   {
      if(_collisionDataType == CollisionDataType.HASH)
        updateHashTable();
      else if(_collisionDataType == CollisionDataType.GRID)
        updateGrid();
   }

   void updateGrid()
   {
     _grid.restart();
     _grid.renderGrid();
     
     for (int i = 0; i < _particles.size(); i++)
        _grid.particleAdd(_particles.get(i));
    
     for (int i = 0; i < _particles.size(); i++)
        _particles.get(i).updateNeighborsGrid(_grid);
   }

   void updateHashTable()
   {
     _hashTable.restart();
     
     for (int i = 0; i < _particles.size(); i++)
        _hashTable.particleAdd(_particles.get(i));
    
     for (int i = 0; i < _particles.size(); i++)
        _particles.get(i).updateNeighborsHash(_hashTable);
   }

   void computePlanesCollisions(ArrayList<PlaneSection> planes)
   {
      for (int i = 0; i < _particles.size(); i++)
         _particles.get(i).planeCollision(planes);
   }

   void computeParticleCollisions(float timeStep)
   {
      for (int i = 0; i < _particles.size(); i++)
         _particles.get(i).particleCollision(timeStep);
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
