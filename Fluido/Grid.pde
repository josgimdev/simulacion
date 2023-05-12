class ParticleList
{
   ArrayList<Particle> _vector;
   
   ParticleList()
   {
      _vector = new ArrayList<Particle>();
   }
}

class Grid
{
   float _cellSize;
   int _nRows;
   int _nCols;
   int _numCells;

   ParticleList [][] _cells;
   color [][] _colors;

   Grid(float cellSize)
   {
      _cellSize = cellSize;
      _nRows = int(height/_cellSize);
      _nCols = int(width/_cellSize);
      _numCells = _nRows*_nCols;

      _cells  = new ParticleList[_nRows][_nCols];
      _colors = new color[_nRows][_nCols];

      for (int i = 0; i < _nRows; i++)
      {
         for (int j = 0; j < _nCols; j++)
         {
            _cells[i][j] = new ParticleList();
            _colors[i][j] = color(int(random(0, 256)), int(random(0, 256)), int(random(0, 256)), 150);
         }
      }
   }
   
   void particleAdd(Particle p) 
   {
     int row = int(p._s.x / _cellSize);
     int col = int(p._s.y / _cellSize);
     
     if(row >= 0 && row < _nRows && col >= 0 && col < _nCols) 
     {
       p._color = _colors[row][col];
       _cells[row][col]._vector.add(p);
     }
     else 
     {
       row = int(random(0, _nRows - 1));
       col = int(random(0, _nCols - 1));
       _cells[row][col]._vector.add(p);
     }
   }

   void restart() 
   {
     for (int i = 0; i < _nRows; i++)
       for (int j = 0; j < _nCols; j++)
         _cells[i][j]._vector.clear();
   }
}
