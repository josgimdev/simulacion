class HashTable
{
   ArrayList<ArrayList<Particle>> _table;

   int _numCells;
   float _cellSize;
   color[] _colors;

   HashTable(float cellSize, int numCells)
   {
      _table = new ArrayList<ArrayList<Particle>>();
      _cellSize = cellSize;
      _numCells = numCells;
      _colors = new color[_numCells];

      for (int i = 0; i < _numCells; i++)
      {
         ArrayList<Particle> cell = new ArrayList<Particle>();
         _table.add(cell);
         _colors[i] = color(int(random(0, 256)), int(random(0, 256)), int(random(0, 256)), 150);
      }
   }
   
   int hash(PVector l) 
   {
     long xd = int(floor(l.x/_cellSize));
     long yd = int(floor(l.y/_cellSize));
     long zd = int(floor(l.z/_cellSize));
     
     long suma = 73856093*xd + 19349663*yd + 83492791*zd;
     int cell = int(suma % _numCells);
     
     if(cell < 0)
       cell = int(random(0, _numCells - 1));
     
     return cell;
   }
   
   void particleAdd(Particle p) 
   {
     int cellPosition = hash(p._s);
     ArrayList<Particle> cell = _table.get(cellPosition);
     p._color = _colors[cellPosition];
     cell.add(p);
   }
   
   void restart() 
   {
     for (int i = 0; i < _table.size(); i++)
         _table.get(i).clear();
   }
}
