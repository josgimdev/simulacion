public class DeformableObject
{
   int _numNodesX;   // Number of nodes in X direction
   int _numNodesY;   // Number of nodes in Y direction
   int _numNodesZ;   // Number of nodes in Z direction

   float _sepX;      // Separation of the object's nodes in the X direction (m)
   float _sepY;      // Separation of the object's nodes in the Y direction (m)
   float _sepZ;      // Separation of the object's nodes in the Z direction (m)

   SpringLayout _springLayout;   // Physical layout of the springs that define the surface of each layer
   color _color;                 // Color (RGB)

   Particle[][][] _nodes;                             // Particles defining the object
   ArrayList<DampedSpring> _springs;                  // Springs joining the particles

   float _Ke = Ke;
   float _Kd = Kd;

   DeformableObject(int numNodesX, int numNodesY, int numNodesZ, float sepX, float sepY, float sepZ, SpringLayout springLayout, color c)
   {
     _numNodesX = numNodesX;
     _numNodesY = numNodesY;
     _numNodesZ = numNodesZ;
     _sepX = sepX;
     _sepY = sepY;
     _sepZ = sepZ;
     _springLayout = springLayout;
     _color = c;
     
     _nodes = new Particle[_numNodesX][_numNodesY][_numNodesZ];
     _springs = new ArrayList<DampedSpring>();
     
     createNodes();
     
     switch(_springLayout) {
       case STRUCTURAL:
         createStructSprings();
         break;
       case STRUCTURAL_AND_SHEAR:
         createStructSprings();
         createShearSprings();
         break;
       case STRUCTURAL_AND_BEND:
         createStructSprings();
         createBendSprings();
         break;
       case STRUCTURAL_AND_SHEAR_AND_BEND:
         createStructSprings();
         createShearSprings();
         createBendSprings();
         break;
     }
   }

   int getNumNodes()
   {
      return _numNodesX*_numNodesY*_numNodesZ;
   }

   int getNumSprings()
   {
      return _springs.size();
   }

   void update(float simStep)
   {
      for (int i = 0; i < _numNodesX; i++) 
      {
       for (int j = 0; j < _numNodesY; j++) 
       {
         for (int k = 0; k < _numNodesZ; k++) 
         {
           _nodes[i][j][k].update(simStep);
         }
        }
       }
      
      for (int i = 0; i < _springs.size(); i++)
        _springs.get(i).update(simStep);
   }
   
   void createNodes() {
     PVector s, v;
     boolean noGravity, clamped;
     
     for (int i = 0; i < _numNodesX; i++) {
       for (int j = 0; j < _numNodesY; j++) {
         for (int k = 0; k < _numNodesZ; k++) {
           
           s = new PVector(i * _sepX, j * _sepY, k * _sepZ);
           v = new PVector(0, 0, 0);
           
           clamped = false;
           noGravity = false;
           
           Particle p = new Particle(s, v, m, noGravity, clamped);
           _nodes[i][j][k] = p;
         }
       }
     }
   }
   
   void createStructSprings() {
     DampedSpring spring;
     
     for (int i = 0; i < _numNodesX; i++) 
     {
       for (int j = 0; j < _numNodesY; j++) 
       {
         for (int k = 0; k < _numNodesZ; k++) 
         {
           if (i < _numNodesX - 1) 
           {
             spring = new DampedSpring(_nodes[i][j][k], _nodes[i + 1][j][k], _Ke, _Kd, PVector.sub(_nodes[i + 1][j][k]._s, _nodes[i][j][k]._s).mag());
             _springs.add(spring);
           }
           if (j < _numNodesY - 1) 
           {
             spring = new DampedSpring(_nodes[i][j][k], _nodes[i][j + 1][k], _Ke, _Kd, PVector.sub(_nodes[i][j + 1][k]._s, _nodes[i][j][k]._s).mag());
             _springs.add(spring);
           }
           if (k < _numNodesZ - 1) 
           {
             spring = new DampedSpring(_nodes[i][j][k], _nodes[i][j][k + 1], _Ke, _Ke, PVector.sub(_nodes[i][j][k + 1]._s, _nodes[i][j][k]._s).mag());
             _springs.add(spring);
           }
         }
       }
     }
   }
   
   void createShearSprings() 
   {
     DampedSpring spring;
     
     for (int i = 0; i < _numNodesX; i++) 
     {
       for (int j = 0; j < _numNodesY; j++) 
       {
         for (int k = 0; k < _numNodesZ; k++) 
         {
           if (i < _numNodesX - 1 && j < _numNodesY - 1) 
           {
             spring = new DampedSpring(_nodes[i][j][k], _nodes[i + 1][j + 1][k], _Ke, _Kd, PVector.sub(_nodes[i + 1][j + 1][k]._s, _nodes[i][j][k]._s).mag());
             _springs.add(spring);
           }
           if (i - 1 >= 0 && j < _numNodesY - 1) 
           {
             spring = new DampedSpring(_nodes[i][j][k], _nodes[i - 1][j + 1][k], _Ke, _Kd, PVector.sub(_nodes[i - 1][j + 1][k]._s, _nodes[i][j][k]._s).mag());
             _springs.add(spring);
           }
           if (i < _numNodesX - 1 && k < _numNodesZ - 1) 
           {
             spring = new DampedSpring(_nodes[i][j][k], _nodes[i + 1][j][k + 1], _Ke, _Ke, PVector.sub(_nodes[i + 1][j][k + 1]._s, _nodes[i][j][k]._s).mag());
             _springs.add(spring);
           }
           if (i - 1 >= 0 && k < _numNodesZ - 1) 
           {
             spring = new DampedSpring(_nodes[i][j][k], _nodes[i - 1][j][k + 1], _Ke, _Ke, PVector.sub(_nodes[i - 1][j][k + 1]._s, _nodes[i][j][k]._s).mag());
             _springs.add(spring);
           }
         }
       }
     }
   }
   
   void createBendSprings() {
     DampedSpring spring;
     
     for (int i = 0; i < _numNodesX; i++) 
     {
       for (int j = 0; j < _numNodesY; j++) 
       {
         for (int k = 0; k < _numNodesZ; k++) 
         {
           if (i < _numNodesX - 2) 
           {
             spring = new DampedSpring(_nodes[i][j][k], _nodes[i + 2][j][k], _Ke, _Kd, PVector.sub(_nodes[i + 2][j][k]._s, _nodes[i][j][k]._s).mag());
             _springs.add(spring);
           }
           if (j < _numNodesY - 2) 
           {
             spring = new DampedSpring(_nodes[i][j][k], _nodes[i][j + 2][k], _Ke, _Kd, PVector.sub(_nodes[i][j + 2][k]._s, _nodes[i][j][k]._s).mag());
             _springs.add(spring);
           }
           if (k < _numNodesZ - 1) 
           {
             spring = new DampedSpring(_nodes[i][j][k], _nodes[i][j][k + 1], _Ke, _Ke, PVector.sub(_nodes[i][j][k + 1]._s, _nodes[i][j][k]._s).mag());
             _springs.add(spring);
           }
         }
       }
     }
   }
   
   // colision de particulas
   void colision(Ball p) 
   {
     PVector dir, F;
     float dist, l;
     
     for (int i = 0; i < _numNodesX; i++) 
       for (int j = 0; j < _numNodesY; j++) 
         for (int k = 0; k < _numNodesZ; k++) 
         {
           dist = PVector.sub(p._s, _nodes[i][j][k]._s).mag();
           if(dist < p._r) 
           { 
              dir = PVector.sub(p._s, _nodes[i][j][k]._s);
              l = dir.mag() + p._r;
              dir.normalize();
              
              F = PVector.mult(dir, -Ke * l);
              
              _nodes[i][j][k].addExternalForce(F);
              //p.addExternalForce(PVector.mult(F, -1.0));
           }
         }
   }
   
   void render()
   {
      if (DRAW_MODE)
         renderWithSegments();
      else
         renderWithQuads();
   }

   void renderWithSegments()
   {
      stroke(0);
      strokeWeight(0.5);

      for (DampedSpring s : _springs)
      {
         PVector pos1 = s.getParticle1().getPosition();
         PVector pos2 = s.getParticle2().getPosition();

         line(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z);
      }
   }

   void renderWithQuads()
   {
      int i, j, k;

      fill(_color);
      stroke(0);
      strokeWeight(1.0);

      for (j = 0; j < _numNodesY - 1; j++)
      {
         beginShape(QUAD_STRIP);
         for (i = 0; i < _numNodesX; i++)
         {
            if ((_nodes[i][j][0] != null) && (_nodes[i][j+1][0] != null))
            {
               PVector pos1 = _nodes[i][j][0].getPosition();
               PVector pos2 = _nodes[i][j+1][0].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }

      for (j = 0; j < _numNodesY - 1; j++)
      {
         beginShape(QUAD_STRIP);
         for (i = 0; i < _numNodesX; i++)
         {
            if ((_nodes[i][j][_numNodesZ-1] != null) && (_nodes[i][j+1][_numNodesZ-1] != null))
            {
               PVector pos1 = _nodes[i][j][_numNodesZ-1].getPosition();
               PVector pos2 = _nodes[i][j+1][_numNodesZ-1].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }

      for (j = 0; j < _numNodesY - 1; j++)
      {
         beginShape(QUAD_STRIP);
         for (k = 0; k < _numNodesZ; k++)
         {
            if ((_nodes[0][j][k] != null) && (_nodes[0][j+1][_numNodesZ-1] != null))
            {
               PVector pos1 = _nodes[0][j][k].getPosition();
               PVector pos2 = _nodes[0][j+1][k].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }

      for (j = 0; j < _numNodesY - 1; j++)
      {
         beginShape(QUAD_STRIP);
         for (k = 0; k < _numNodesZ; k++)
         {
            if ((_nodes[_numNodesX-1][j][k] != null) && (_nodes[_numNodesX-1][j+1][_numNodesZ-1] != null))
            {
               PVector pos1 = _nodes[_numNodesX-1][j][k].getPosition();
               PVector pos2 = _nodes[_numNodesX-1][j+1][k].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }

      for (i = 0; i < _numNodesX - 1; i++)
      {
         beginShape(QUAD_STRIP);
         for (k = 0; k < _numNodesZ; k++)
         {
            if ((_nodes[i][0][k] != null) && (_nodes[i+1][0][k] != null))
            {
               PVector pos1 = _nodes[i][0][k].getPosition();
               PVector pos2 = _nodes[i+1][0][k].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }

      for (i = 0; i < _numNodesX - 1; i++)
      {
         beginShape(QUAD_STRIP);
         for (k = 0; k < _numNodesZ; k++)
         {
            if ((_nodes[i][_numNodesY-1][k] != null) && (_nodes[i+1][_numNodesY-1][k] != null))
            {
               PVector pos1 = _nodes[i][_numNodesY-1][k].getPosition();
               PVector pos2 = _nodes[i+1][_numNodesY-1][k].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }
   }
}
