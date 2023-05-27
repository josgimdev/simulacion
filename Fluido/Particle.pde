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
     for(int i = 0; i < planes.size(); i += 1) 
     {
       PlaneSection p = planes.get(i);
       
       float dist = p.getDistance(_s);
       boolean limit = p.checkLimits(_s);
       
       if(dist < _radius * .5 && limit) 
       {
         PVector n = p.getNormal();
         PVector pos = PVector.mult(n, _radius * .5 - dist);
         _s.add(pos);
         
         PVector Vn = PVector.mult(n, _v.dot(n));
         PVector Vt = PVector.sub(_v, n);
         PVector Vf = PVector.sub(Vt, PVector.mult(Vn, -Cr));
         _v.sub(Vf);
       }
     }
   }

   void particleCollision()
   {
      ArrayList<Particle> particles = _ps.getParticleArray();
      
      if(_ps._collisionDataType == CollisionDataType.GRID) {
        for(int i = 0; i < _vecinos.size(); i++) {
          Particle p = _vecinos.get(i);
          float dist = PVector.sub(_s, p._s).mag();
          if(dist < _radius) { 
            PVector dir = PVector.sub(_s, p._s);
            float l = dir.mag() - _radius;
            dir.normalize();
            PVector F = PVector.mult(dir, -Ke * l);
            _v.add(F);
            p._v.sub(F);
          }
        }
      }
      else if(_ps._collisionDataType == CollisionDataType.HASH) {
        for(int i = 0; i < _vecinos.size(); i++) {
          Particle p = _vecinos.get(i);
          float dist = PVector.sub(_s, p._s).mag();
          if(dist < _radius) { 
            PVector dir = PVector.sub(_s, p._s);
            float l = dir.mag() - _radius;
            dir.normalize();
            PVector F = PVector.mult(dir, -Ke * l);
            _v.add(F);
            p._v.sub(F);
          }
        }
      }
      else {
        for(int i = 0; i < particles.size(); i ++) {
          Particle p = particles.get(i);
          p._color = PARTICLES_COLOR;
          if(_id != p._id) {
            float dist = PVector.sub(_s, p._s).mag();
            if(dist < _radius) { 
              PVector dir = PVector.sub(_s, p._s);
              float l = dir.mag() - _radius;
              dir.normalize();
              PVector F = PVector.mult(dir, -Ke * l);
              _v.add(F);
              p._v.sub(F);
            }
          }
        }
      }
   }

   void updateNeighborsGrid(Grid grid)
   {
      _vecinos.clear();
      ArrayList<Particle> cell;
      int row, col;
      
      row = int(_s.x / SC_GRID);
      col = int(_s.y / SC_GRID);
      
      if (row >= 0 && row < grid._nRows && col >= 0 && col < grid._nCols) {
        // Vecinas en la misma celda
        cell = grid._cells[row][col]._vector;
        for (int i = 0; i < cell.size(); i++) {
          Particle p = cell.get(i);
          if (_id != p._id) {
            _vecinos.add(p);
          }
        }
      
        // Vecinas de arriba
        if (row - 1 >= 0) {
          cell = grid._cells[row - 1][col]._vector;
          for (int i = 0; i < cell.size(); i++) {
            _vecinos.add(cell.get(i));
          }
        }
        
        // Vecinas de abajo
        if (row + 1 < grid._nRows) {
          cell = grid._cells[row + 1][col]._vector;
          for (int i = 0; i < cell.size(); i++) {
            _vecinos.add(cell.get(i));
          }
        }
        
        // Vecinas de izquierda
        if (col - 1 >= 0) {
          cell = grid._cells[row][col - 1]._vector;
          for (int i = 0; i < cell.size(); i++) {
            _vecinos.add(cell.get(i));
          }
        }
        
        // Vecinas de derecha
        if (col + 1 < grid._nCols) {
          cell = grid._cells[row][col + 1]._vector;
          for (int i = 0; i < cell.size(); i++) {
            _vecinos.add(cell.get(i));
          }
        }
      }
   }

   void updateNeighborsHash(HashTable hashTable)
   {
      _vecinos.clear();
      ArrayList<Particle> cell;
      int cellPosition;
      PVector particleLocation = new PVector();
      
      particleLocation = _s;
      cellPosition = hashTable.hash(particleLocation);
      cell = hashTable._table.get(cellPosition);
      for(int i = 0; i < cell.size(); i++) 
      {
        Particle p = cell.get(i);
        if(_id != p._id)
          _vecinos.add(p);
      }
      
      particleLocation = new PVector(_s.x, _s.y - SC_HASH);
      cellPosition = hashTable.hash(particleLocation);
      cell = hashTable._table.get(cellPosition);
      for(int i = 0; i < cell.size(); i++) 
        _vecinos.add(cell.get(i));
      
      particleLocation = new PVector(_s.x, _s.y + SC_HASH);
      cellPosition = hashTable.hash(particleLocation);
      cell = hashTable._table.get(cellPosition);
      for(int i = 0; i < cell.size(); i++)
        _vecinos.add(cell.get(i));
      
      particleLocation = new PVector(_s.x + SC_HASH, _s.y);
      cellPosition = hashTable.hash(particleLocation);
      cell = hashTable._table.get(cellPosition);
      for(int i = 0; i < cell.size(); i++)
        _vecinos.add(cell.get(i));
      
      particleLocation = new PVector(_s.x - SC_HASH, _s.y);
      cellPosition = hashTable.hash(particleLocation);
      cell = hashTable._table.get(cellPosition);
      for(int i = 0; i < cell.size(); i++)
        _vecinos.add(cell.get(i));
   }

   void render()
   {
      stroke(0, 0, 0);
      strokeWeight(1);
      fill(_color);
      circle(_s.x, _s.y, _radius);
   }
}
