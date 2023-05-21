// fractal visualization parameters
float zoomFactor = 0.1;
float zoom = 1;

// numbers convercence parameters
long threshold = 10000000000000000L;
float iterations = (int) 50*zoom; // 50 is the minimum




void setup(){
  size(1000, 1000);
  background(255);
  
  smooth();
  
}



void draw(){
  // move image  
  // to refactor
  if(mousePressed && mouseButton == LEFT){   
      centreX = centreX + map(mouseX, 0, width, 2, -2) - map(lastMouseX, 0, width, 2, -2);//- cursorDistanceX;
      centreY = centreY + map(mouseY, 0, height, -2, 2) - map(lastMouseY, 0, height, -2, 2);//+ cursorDistanceY;      
      lastMouseX = mouseX;
      lastMouseY = mouseY;
    }
  
  //loadPixels();
  
  for(int i = 0; i < height; i++){
    for(int j = 0; j < width; j++){
      drawFractal(i, j, centreX, centreY);
      
      // applying mask for anti-aliasing
      
    }
  }
  
  //updatePixels();
    
}


float centreX = 0;
float centreY = 0;

float lastMouseX = 0;
float lastMouseY = 0;


void drawFractal(int i, int j, float centreX_, float centreY_){
  
  float re = map(i, 0, width, (-2 - centreY_)/zoom, (2 - centreY_)/zoom);
  float im = -map(j, 0, height, (2 - centreX_)/zoom, (-2 - centreX_)/zoom);
  set(j, i, color( (new Complex(im, re)).converges()/1.6,
                    (new Complex(im, re)).converges()/1.4,
                    (new Complex(im, re)).converges()));             
}


public class Complex{
  
  float re;
  float im;
  
  Complex(float re, float im){
    this.re = re;
    this.im = im;
  }
  
  public Complex sum(Complex c){
    return new Complex(this.re + c.re, this.im + c.im);
  }
  
  public Complex product(Complex c){
    return new Complex(this.re * c.re - this.im * c.im, 
                         this.re * c.im + this.im * c.re);
  }
  
  public void show(){
    print(this.re + "+" + this.im + "i");
  }
  
  int converges(){
        if(Math.abs(this.im + this.re) > threshold) return 1;
        Complex z = new Complex(0, 0);
        for(long i = 0; i < iterations; i++){
            if(Math.abs(z.im + z.re) > threshold) return ((int) i*10);
            z = z.product(z);
            z = z.sum(this);
        }
        return 0;
  }
  
}

// on mouse wheel moved
void mouseWheel(MouseEvent event) {
  int e = event.getCount(); // 1 = down -1 = up
  //factor = factor - (e*zoomFactor);
  zoom = zoom - (e*zoomFactor);
}

// on mouse pressed
void mousePressed(){
  if(mouseButton != LEFT) return;
  
  lastMouseX = mouseX;
  lastMouseY = mouseY;
}

void mouseReleased(){
  if(mouseButton != LEFT) return;
}


void antiAliasing(){
  
}
