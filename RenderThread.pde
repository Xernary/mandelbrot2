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
  
  
}
