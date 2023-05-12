// Class for a simple spring with no damping
public class Spring
{
   PVector _pos1;   // First end of the spring (m)
   PVector _pos2;   // Second end of the spring (m)
   float _Ke;       // Elastic constant (N/m)
   float _l0;       // Rest length (m)

   PVector _F;      // Force applied by the spring towards pos1 (the force towards pos2 is -_F) (N)
   float _energy;   // Energy (J)

   Spring(PVector pos1, PVector pos2, float Ke, float l0)
   {
      _pos1 = pos1;
      _pos2 = pos2;
      _Ke = Ke;
      _l0 = l0;

      _F = new PVector(0.0, 0.0);
      _energy = 0.0;
   }

   void setPos1(PVector pos1)
   {
      _pos1 = pos1;
   }

   void setPos2(PVector pos2)
   {
      _pos2 = pos2;
   }

   void setKe(float Ke)
   {
      _Ke = Ke;
   }

   void setRestLength(float l0)
   {
      _l0 = l0;
   }

   void update()
   {
      PVector dir = PVector.sub(_pos1, _pos2);
      float l = dir.mag() - _l0;
      dir.normalize();
 
      _F = PVector.mult(dir, _Ke * l);
      
      updateEnergy();
   }

   void updateEnergy()
   {
      PVector dir = PVector.sub(_pos1, _pos2);
      float l = dir.mag() - _l0;
      _energy = _Ke * l * l * .5;
   }

   PVector getForce()
   {
      return _F;
   }

   float getEnergy()
   {
      return _energy;
   }
}
