// fractal visualization parameters
double centreX = -0.5;
double centreY = 0;
float zoom = 1;
float zoomFactor = 0.1;
int colorAdjustRateo = 20;
//MAX ZOOM 82K

// numbers convercence parameters
long threshold = 4;
float iterations = 50;// map(log(zoom), log(1), log(40000000000000L), 50, 10024);//(int) 50*map(zoom, 1, 10000, 1, 10000*1000); // 50 is the minimum
int iterationsJump = 50;
int maxIterations = 1024 / 2;
float iterationsFactor = 0;

// threads
int nThreads = Runtime.getRuntime().availableProcessors();
RenderThread[] threads;
Thread[] rThreads;
RenderRunnable[] runnables;
long firstThreadId;

boolean firstFrame = true;


void setup(){
  size(1008/2, 1008/2);
  background(255);
  frameRate(30);
  
  smooth();
  firstFrame = true;
  threads = new RenderThread[nThreads];
  rThreads = new Thread[nThreads];
  runnables = new RenderRunnable[nThreads];
  
}




void draw(){
  
  
  
  iterations = map(log(zoom), log(1), log(40000000000000L), 50+iterationsFactor, maxIterations+iterationsFactor);
  // move image  
  // to refactor
  if(mousePressed && mouseButton == LEFT){   
      centreX = (centreX + map(mouseX, 0, width, 2/zoom, -2/zoom) - map(lastMouseX, 0, width, 2/zoom, -2/zoom));
      centreY = (centreY + map(mouseY, 0, height, -2/zoom, 2/zoom) - map(lastMouseY, 0, height, -2/zoom, 2/zoom));      
      lastMouseX = mouseX;
      lastMouseY = mouseY;
    }
  
  loadPixels();
  
  // normal method
  //normalRendering();
  
  // multi-threads method
  threadsRendering();
  
  // runnable method
  //runnableRendering();
  
  // threads pool method
  //threadsPoolRendering();
  
  updatePixels();

  firstFrame = false;
}

double lastMouseX = 0;
double lastMouseY = 0;

void drawFractal(int i, int j, double centreX_, double centreY_){
  
  double re = -map(j, 0, height, (2)/zoom - centreX_, (-2)/zoom - centreX_);
  double im = map(i, 0, width, (-2 )/zoom - centreY_, (2 )/zoom - centreY_);
  
  color col = colorHSB((new Complex(re, im)).converges());
                    
  pixels[j+i*width] = col;       
}


color colorRGB(float c){
  colorMode(RGB,iterations);
  int col = (int) (c%iterations);
  return color(col, col, col);
}


color colorHSB(float c){
  colorMode(HSB, 1);
  float a = 0.1;
  return color(0.5 * sin(a*c) + 0.5, 0.5 * sin(a*c + 2.094) + 0.5, 0.5 * sin(a*c + 4.188) + 0.5); 
}


public class Complex{
  
  double re;
  double im;
  int iterations_;
  
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
            if(Math.abs(z.im*z.im + z.re*z.re) > threshold) return ((int) i);
            z = z.product(z);
            z = z.sum(this);
        }
        return 0;
  }
  
}

void normalRendering(){
 for(int i = 0; i < height; i++){
    for(int j = 0; j < width; j++){
      drawFractal(i, j, centreX, centreY);
      
      // applying mask for anti-aliasing
      
    }
  } 
}

void threadsRendering(){
  // create threads
   for(int i = 0; i < nThreads; i++){
     threads[i] = new RenderThread(i, nThreads);
     threads[i].start();
     print(threads[i].getId() + "\n");
   }
   
   // join threads
   for(int i = 0; i < nThreads; i++){
     try{
       threads[i].join();
     }catch(Exception e){
       e.printStackTrace();
     }
   }
  
   // kill threads
   for(int i = 0; i < nThreads; i++){
     threads[i] = new RenderThread(i, nThreads);
     threads[i].interrupt();
   }
}

void runnableRendering(){
  // create runnables and threads
   for(int i = 0; i < nThreads; i++){   
     rThreads[i].start();
   }
   
   // join threads
   for(int i = 0; i < nThreads; i++){
     try{
       rThreads[i].join();
     }catch(Exception e){
       e.printStackTrace();
     }
   }
}

void threadsPoolRendering(){
  if(firstFrame){
    // create threads
     for(int i = 0; i < nThreads; i++){
       threads[i] = new RenderThread(i, nThreads);     
     }
     firstThreadId = threads[0].getId();
  }
  
  //start threads
  for(long i = firstThreadId; i < nThreads; i++){
    //threads[i].start();
  }
  
   // join threads
   for(int i = 0; i < nThreads; i++){
     try{
       threads[i].join();
     }catch(Exception e){
       e.printStackTrace();
     }
   }
   
   //for (Thread t : Thread.getAllStackTraces().keySet()) 
    // if (t.getId()==id)
  
}


// INPUTS/COMMANDS

// zoom
void mouseWheel(MouseEvent event) {
  int e = event.getCount(); // 1 = down -1 = up
  //factor = factor - (e*zoomFactor);
  zoom = zoom - (e*zoomFactor);
  zoomFactor = zoomFactor - e*0.1*zoomFactor;
  
  print("zoomFactor: " + zoomFactor + "\n");
  print("zoom: " + zoom + "\n");
}

// drag start
void mousePressed(){
  if(mouseButton != LEFT) return;
  
  lastMouseX = mouseX;
  lastMouseY = mouseY;
}

// drag end
void mouseReleased(){
  if(mouseButton != LEFT) return;
}

double map(double oldValue, double oldMin, double oldMax, double newMin, double newMax){
  
  return (((oldValue - oldMin) * (newMax - newMin)) / (oldMax - oldMin)) + newMin;

}

// keyboard inputs
void keyPressed(){
  
  //increase iterations
  if(key == 'd'){
    iterationsFactor = iterationsFactor + iterationsJump;
    return;
  }
  
  //decrease iterations
  if(key == 'a'){
    iterationsFactor = iterationsFactor - iterationsJump;
        if(iterationsFactor < 0) iterationsFactor = 0;
    return;
  }
  
  //reset centre
  if(key == 'r'){
    centreX = -0.5;
    centreY = 0;
    zoom = 1;
    return;
  }
  return;
}




void antiAliasing(){
  
}
