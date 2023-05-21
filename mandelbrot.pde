// fractal visualization parameters
float zoom = 1;
float zoomFactor = 0.1;
//MAX ZOOM 82K

// numbers convercence parameters
long threshold = 10000000000000000L;
float iterations = (int) 50*map(zoom, 1, 10000, 1, 10000*1000); // 50 is the minimum




void setup(){
  size(1000, 1000);
  background(255);
  
  smooth();
}



void draw(){
  // move image  
  // to refactor
  if(mousePressed && mouseButton == LEFT){   
      centreX = (centreX + map(mouseX, 0, width, 2/zoom, -2/zoom) - map(lastMouseX, 0, width, 2/zoom, -2/zoom));//- cursorDistanceX;
      centreY = (centreY + map(mouseY, 0, height, -2/zoom, 2/zoom) - map(lastMouseY, 0, height, -2/zoom, 2/zoom));//+ cursorDistanceY;      
      lastMouseX = mouseX;
      lastMouseY = mouseY;
    }
  
  loadPixels();
  
  for(int i = 0; i < height; i++){
    for(int j = 0; j < width; j++){
      drawFractal(i, j, centreX, centreY);
      
      // applying mask for anti-aliasing
      
    }
  }
  
  updatePixels();
    
}


double centreX = 0;
double centreY = 0;

double lastMouseX = 0;
double lastMouseY = 0;


void drawFractal(int i, int j, double centreX_, double centreY_){
  
  double re = -map(j, 0, height, (2)/zoom - centreX_, (-2)/zoom - centreX_);
  double im = map(i, 0, width, (-2 )/zoom - centreY_, (2 )/zoom - centreY_);
  
  /*set(j, i, color( (new Complex(im, re)).converges()/1.6,
                    (new Complex(im, re)).converges()/1.4,
                    (new Complex(im, re)).converges()));*/
  pixels[j+i*width] = color(/*(new Complex(im, re)).converges()/1.6,
                            (new Complex(im, re)).converges()/1.4,*/
                            (new Complex(re, im)).converges(), (new Complex(re, im)).converges(), (new Complex(re, im)).converges());
                    
                    
}


public class Complex{
  
  double re;
  double im;
  
  Complex(double re, double im){
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
  zoomFactor = zoomFactor - e*0.1*zoomFactor;
  
  print("zoom: " + zoom + "\n");
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

double map(double oldValue, double oldMin, double oldMax, double newMin, double newMax){
  
  return (((oldValue - oldMin) * (newMax - newMin)) / (oldMax - oldMin)) + newMin;

}


void antiAliasing(){
  
}
