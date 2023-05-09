PVector pos,pos2;
float r1 = 80;
float r2 = 40;
float ult,a,t,f,w,dif;//cambiar

void setup(){
  size(600,600);
  pos = new PVector(width/2, height/2);
  pos2 = new PVector(pos.x + r1*2, pos.y);
  ult =millis();
  a=1;
  t=1;
  f=1/t;
  w= 2*PI*f;
}
void draw(){
  background(0);
  
  fill(255,0,0);
  ellipse(pos.x, pos.y, r1, r1);
  
  stroke(255,0,0);
  fill(255,0,255);
  ellipse(pos2.x, pos2.y, r2, r2);
  
  pos2.x = r1*2 * cos(a) + pos.x;
  pos2.y = r1*2 * sin(a) + pos.y;
  
  dif = (millis()-ult)/1000;
  a += w* dif;
  ult= millis();
}
