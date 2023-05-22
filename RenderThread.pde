class RenderThread extends Thread{
  
  int tId, nThreads;
  
  public RenderThread(int tId, int nThreads){
    this.tId = tId;
    this.nThreads = nThreads;
  }
  
  @Override
  void run(){
    renderArea();
  }
  
  private void renderArea(){
    // render a region of the window
    for(int i = 0; i < height; i++)
      for(int j = tId*width/nThreads; j < tId*width/nThreads + width/nThreads; j++){
        drawFractal(i, j, centreX, centreY);
        
      // applying mask for anti-aliasing
      
    }
  }
  
  void drawFractal(int i, int j, double centreX_, double centreY_){
  
    double re = -map(j, 0, height, (2)/zoom - centreX_, (-2)/zoom - centreX_);
    double im = map(i, 0, width, (-2 )/zoom - centreY_, (2 )/zoom - centreY_);
    
    color col = colorHSB((new Complex(re, im)).converges());
                      
    pixels[j+i*width] = col;                                 
  }
  
}
