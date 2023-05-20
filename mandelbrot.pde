// numbers convercence parameters
long threshold = 10000000000000000L;
float zoom = 1;
float iterations = (int) 50*zoom; // 50 is the minimum

// fractal visualization parameters
float factor = 0.4;
float xOffset = -0.75;
float yOffset = 0.5;

float zoomFactor = 0.1;

boolean firstPress= true;
boolean moving = false;
float mousePressX = 0;
float mousePressY = 0;

float prevXOffset = xOffset;
float prevYOffset = yOffset;


void setup(){
  size(1000, 1000);
  background(255);
  
  smooth();
  
}




void draw(){
  // move image
  if(moving){
    
    xOffset = (mousePressX - mouseX)/100 + prevXOffset;
    
  }else{
    prevXOffset = xOffset;
  }
  // to refactor
  for(int i = 0; i < height; i++){
    for(int j = 0; j < width; j++){
      
      drawFractal(i, j);
      /*
      // set pixel color based on whether or not it converges
      set(i, j, color((new Complex((i/((float)width)+xOffset)/factor, (-j/((float)height)+yOffset)/factor)).converges()/1.6,
                      (new Complex((i/((float)width)+xOffset)/factor, (-j/((float)height)+yOffset)/factor)).converges()/1.4, 
                      (new Complex((i/((float)width)+xOffset)/factor, (-j/((float)height)+yOffset)/factor)).converges())
                      );
                      
      // applying mask for anti-aliasing
      */
      
    }
  }
     print("x: " + centreX + " y: " + centreY + "\n");

    
}

float xOff = -width/2;
float yOff = height/2;


float centreX = 0;
float centreY = 0;

float cameraLeftBound = 0;
float cameraRightBound = 0;
float cameraUpBound = 0;
float cameraDownBound = 0;

float cursorDistanceX = centreX;
float cursorDistanceY = centreY;


void drawFractal(int i, int j){
  
  if(mousePressed && mouseButton == LEFT){
    
    
      centreX = map(mouseX, 0, width, 2, -2) - cursorDistanceX;
      centreY =  map(mouseY, 0, height, -2, 2) + cursorDistanceY;
    }
  
  
  cameraLeftBound = (2 - centreX*2)/zoom;
  cameraRightBound = (-2 - centreX*2)/zoom;
  cameraDownBound = (-2 - centreY*2)/zoom;
  cameraUpBound = (2 - centreY*2)/zoom;
  
  float re = map(i, 0, width, (-2 - centreY)/zoom, (2 - centreY)/zoom);
  float im = -map(j, 0, height, (2 - centreX)/zoom, (-2 - centreX)/zoom);
  
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
  moving = true;
  
  mousePressX = mouseX;
  mousePressY = mouseY;
  firstPress = false;
  cursorDistanceX = map(mouseX, 0, width, 2, -2) + cursorDistanceX;
  cursorDistanceY = map(mouseY, 0, height, 2, -2) - cursorDistanceY;
  print("first press\n");
  
}

void mouseReleased(){
  if(mouseButton != LEFT) return;
  
  mousePressX = 0;
  mousePressY = 0;
  
  //cursorDistanceX = map(mouseX, 0, width, 2, -2) - centreX;
  //cursorDistanceY = map(mouseY, 0, height, 2, -2) - centreY;
  
  moving = false;
  firstPress = true;  
}


void antiAliasing(){
  
}
