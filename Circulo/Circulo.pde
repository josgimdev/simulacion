// Variables to be solved:
PVector p1;
PVector p2;
float r1;
float r2;
float ult;
float a;
float t;
float f;
float w;
float dif;

void setup()
{
  size(600,600);
  p1 = new PVector(width/2, height/2);
  p2 = new PVector(p1.x + r1*2, p1.y);
  ult = millis();
  a = 1;
  t = 1;
  f = 1/t;
  w = 2*PI*f;
}

void draw()
{
  background(0);
  
  fill(255,0,0);
  circle(p1.x, p1.y, r1);
  
  stroke(255,0,0);
  fill(255,0,255);
  circle(p2.x, p2.y, r2);
  
  p2.x = r1*2 * cos(a) + p1.x;
  p2.y = r1*2 * sin(a) + p1.y;
  
  dif = (millis()-ult)/1000;
  a += w * dif;
  ult = millis();
}
