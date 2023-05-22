abstract class Wave
{
  float _a;
  float _vp;
  float _w;
  float _q;
  float _phi;
  
  PVector _dir = new PVector();
  
   public Wave(float a, PVector dir, float l, float vp)
   {
      _vp = vp;
      _a = a; 
      _w = PI * 2.0 / l; 
      _q = PI * _a * _w;
      _phi = _vp * _w;
      
      _dir = dir.copy();
    }
    
    abstract PVector getVariation(PVector pos, float time);
}  
  
class WaveDirectional extends Wave 
{
  public WaveDirectional(float a, PVector dir, float l, float vp)
  {
    super(a, dir, l, vp);
    _dir.normalize();
  }
  
  public PVector getVariation(PVector pos, float time)
  {
    float variation = _a * sin((_dir.x * pos.x + _dir.z * pos.z) * _w + time * _phi);
    
    PVector wave = new PVector(0, variation, 0);
    
    return wave;
  }
}

class WaveRadial extends Wave
{
  public WaveRadial(float a, PVector dir, float l, float vp)
  {
    super(a, dir, l, vp);
  }
  
  public PVector getVariation(PVector pos, float time)
  {
    float dist = PVector.sub(pos, _dir).mag();
    
    float variation = _a * cos(_w * dist - _phi * time);
    
    PVector wave = new PVector(0, variation, 0);
    
    return wave;
  }

}

class WaveGerstner extends Wave
{
  public WaveGerstner(float a, PVector dir, float l, float vp)
  {
    super(a, dir, l, vp);
    _dir.normalize();
  }
  public PVector getVariation(PVector pos, float time)
  {
    PVector wave = new PVector(
      _q * _a * _dir.x * cos(_w * (_dir.x * pos.x + _dir.z * pos.z) + time * _phi),
      _a * sin(_w * (_dir.x * pos.x + _dir.z * pos.z) + time * _phi),
      _q * _a * _dir.z * cos(_w * (_dir.x * pos.x + _dir.z * pos.z) + time * _phi)
    );
    
    return wave;
  }
}
