class HeightMap
{
  private final int _numNodesX;
  private final int _numNodesY;
  private final float _sepX;
  private final float _sepY;
  
  private PVector[][] _initialPos;
  private PVector[][] _actualPos;
  private PVector[][] _texture;
  
  protected ArrayList<Wave> _waves;
  
  public HeightMap(int numNodesX, int numNodesY, float sepX, float sepY)
  {
    _numNodesX = numNodesX;
    _numNodesY = numNodesY;
    _sepX = sepX;
    _sepY = sepY;
    
    generateNodes();
    generateTexture();
  }
  
  public void update(float simTime)
  {   
    for (int i = 0; i < _numNodesX; i++)
    {
      for (int j = 0; j < _numNodesY; j++)
      {
        _actualPos[i][j] = _initialPos[i][j].copy();
        
        for (int k = 0; k < _waves.size(); k++)
        {
          Wave w = _waves.get(k);
          PVector v = w.getVariation(_actualPos[i][j], simTime);
          _actualPos[i][j].add(v);
        }
      }  
    }
  }
  
  public void generateNodes()
  {
    float nx = -_numNodesX * _sepX * .5;
    float ny = -_numNodesY * _sepY * .5;
    
    _actualPos = new PVector[_numNodesX][_numNodesY];
    _initialPos = new PVector[_numNodesX][_numNodesY];

    _waves = new ArrayList<Wave>();
    
    for (int i = 0; i < _numNodesX; i++)
    {
      for (int j = 0; j < _numNodesY; j++)
      {
        _actualPos[i][j] = new PVector(nx + i * _sepX, 0, ny + j * _sepY);
        _initialPos[i][j] = _actualPos[i][j].copy();
      }
    }
  }
  
  public void generateTexture()
  {
    _texture = new PVector[_numNodesX][_numNodesY];
    
    for (int i = 0; i < _numNodesX; i++)
    {
      for (int j = 0; j < _numNodesY; j++)
      {
        _texture[i][j] = new PVector(
          i / (float)_numNodesX * _img.width,
          j / (float)_numNodesY * _img.height
        );  
      }
    }
  } //<>//

  public void addWave(Wave wave)
  {
    _waves.add(wave);
  }
  
  public void render()
  {
      if (DRAW_MODE)
         renderWithTexture();
      else
         renderWithQuads();
  }
  
  public void renderWithTexture(){
    noStroke();
    for (int i = 0; i < _numNodesX - 1; i++) 
    {
      beginShape(QUAD_STRIP);
      texture(_img);
      for (int j = 0; j < _numNodesY; j++) 
      {
        vertex(_actualPos[i][j].x, _actualPos[i][j].y, _actualPos[i][j].z, _texture[i][j].x, _texture[i][j].y);
        vertex(_actualPos[i+1][j].x, _actualPos[i+1][j].y, _actualPos[i+1][j].z, _texture[i+1][j].x, _texture[i][j].y);
      }
      endShape();
    }
  }
  
  public void renderWithQuads()
  {
    stroke(0, 0, 0);
    
    for (int i = 0; i < _numNodesX; i++)
    {
      for (int j = 0; j < _numNodesY; j++) 
      {
         if (i < _numNodesX - 1) 
         {
           line(_actualPos[i][j].x, _actualPos[i][j].y, _actualPos[i][j].z, _actualPos[i+1][j].x, _actualPos[i+1][j].y, _actualPos[i+1][j].z);
         }
         
         if (j < _numNodesY - 1) 
         {
            line(_actualPos[i][j].x, _actualPos[i][j].y, _actualPos[i][j].z, _actualPos[i][j+1].x, _actualPos[i][j+1].y, _actualPos[i][j+1].z);
         }
         
         if (i < _numNodesX - 1 && j < _numNodesY - 1) 
         {
           line(_actualPos[i][j].x, _actualPos[i][j].y, _actualPos[i][j].z, _actualPos[i+1][j+1].x, _actualPos[i+1][j+1].y, _actualPos[i+1][j+1].z);
         }
      }
    }
  }
}
