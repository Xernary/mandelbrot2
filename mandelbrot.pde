
int threshold = 20;
int iterations = 500;

void setup(){
  size(1000, 1000);
  background(255);
  
  smooth();
  
}




void draw(){
  
  
  for(int i = 0; i < width; i++)
    for(int j = 0; j < height; j++){
      set(i, j, color((new Complex(i/((float)width), -j/((float)height))).converges()/5,
                      (new Complex(i/((float)width), -j/((float)height))).converges(), 
                      (new Complex(i/((float)width), -j/((float)height))).converges()/5)
                      );
    }
    
  
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
        if(Math.abs(this.im + this.re) > 10) return 1;
        Complex z = new Complex(0, 0);
        for(int i = 0; i < iterations; i++){
            if(Math.abs(z.im + z.re) > 10) return i;
            z = z.product(z);
            z = z.sum(this);
        }
        return 0;
  }
  
}
