int reds;
int croppedHeight;
int croppedWidth;
void setup() {
  size(640, 480);
  PImage a= loadImage("krishna1.png");
  PImage b= loadImage("krishna1.png");
  getSmallest(a,b);
  updateImage("scream1.png", differenceDetect(highContrast(a), highContrast(b)));
  println(isSame());
}

void draw() {
}
void getSmallest(PImage a, PImage b) {
  if (a.height > b.height){
    croppedHeight = a.height;
    
  }
  else{
    croppedHeight = b.height;
  }
  if(a.width > b.width){
    croppedWidth = a.width;
  }
  else{
    croppedWidth =b.width;
  }
}
  void formatImage(PImage img){
      
    img.resize(640, img.height* (640/img.width));
    imageMode(CENTER);
    image(img, 320, 240);
    PImage imageIn, croppedImage;

  }
  color[] highContrast(PImage img){
         formatImage(img);
     loadPixels();
     color[] temp=new color[pixels.length];

     for (int i=0; i<pixels.length;i++){
       color c=pixels[i];
       int colorval= (int)((red(c)+blue(c)+green(c))/3);
       if (colorval > 75){
         colorval=255;
       }
       else{
         colorval=0;
       }
       temp[i]=color(colorval);
     }
     return temp;
  }
     
  color[] differenceDetect(color[] a1, color[] a2) {
    if (a1.length != a2.length) {
      println("The images must be the same size");
      return new color[0];
    }
    color[] ret= new color[a1.length];
    for (int i=1; i< a1.length-1; i++) {
      if ((red(a2[i])-45) <= red(a1[i]) && red(a1[i]) <= (red(a2[i])+45) ) {
        ret[i]= color(0);
      } else {
        ret[i]=color(255, 0, 0);
        reds++;
      }
    }
    println(reds);
    return ret;
  }
  void updateImage(String img, color[] temp) {     
    image(loadImage(img), 0, 0);
    loadPixels();
    for (int i=0; i< pixels.length; i++) {
      pixels[i]=temp[i];
    }
    updatePixels();
  }

  boolean isSame() {

    return reds <= 70000;
  }

