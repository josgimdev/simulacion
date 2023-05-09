float i;
float dt= 0.3;
void setup() {
  size(600, 600);
}
void draw() {
  background(255);
  fill(0);
  stroke(0);
  ellipse(width/2, height/2, 100, 100);
  
  pushMatrix();
  translate(width/2, height/2);
  rotate(-PI/2 +i  * 2*PI/20);
  stroke(255, 0, 0);
  strokeWeight(5);
  line(0, 0, 50, 0);
  popMatrix();
  
  i +=dt;
}
