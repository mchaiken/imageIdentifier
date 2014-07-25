  int reds = 0;
  int thresh=30;
/*int reds;
 int croppedHeight;
 int croppedWidth;
 
 void getSmallest(PImage a, PImage b) {
 if (a.height > b.height) {
 croppedHeight = a.height;
 } else {
 croppedHeight = b.height;
 }
 if (a.width > b.width) {
 croppedWidth = a.width;
 } else {
 croppedWidth =b.width;
 }
 }
 void formatImage(PImage img) {
 
 img.resize(640, img.height* (640/img.width));
 imageMode(CENTER);
 image(img, 320, 240);
 PImage imageIn, croppedImage;
 }
 color[] highContrast(PImage img) {
 formatImage(img);
 loadPixels();
 color[] temp=new color[pixels.length];
 
 for (int i=0; i<pixels.length; i++) {
 color c=pixels[i];
 int colorval= (int)((red(c)+blue(c)+green(c))/3);
 if (colorval > 75) {
 colorval=255;
 } else {
 colorval=0;
 }
 temp[i]=color(colorval);
 }
 return temp;
 }
 
 color[] differenceDetect(color[] a1, color[] a2) {
 reds=0;
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
  */
 int isSame(PImage a, PImage b) {
  setUp(a,b);
 differenceDetect(a,b);
 return reds;
 }


void setUp(PImage img1, PImage img2) {
  
  img2.resize(img1.width, img1.height);
  size(img1.width, img2.height);
  img1 = edgeDetect(img1);
  img2 = edgeDetect(img2);
  int one = avg(img1);
  int two = avg(img2);

  if (one>two) {
    img1 = adjust(img1, one-two);
  } else {
    img2 = adjust(img2, two-one);
  }
}
PImage edgeDetect(PImage a) {
  a.loadPixels();
  PImage b = createImage(width,height,RGB);
  b.loadPixels();
  for (int x=1;x<width-1;x++) {
    for (int y=1;y<height-1;y++) {
      color here = a.pixels[y*width+x];
      color left = a.pixels[y*width+(x-1)];
      color right = a.pixels[y*width+(x+1)];
      color above = a.pixels[(y-1)*width+x];
      color below = a.pixels[(y+1)*width+x];
      float newR = sqrt(sq(red(left) - red(right)) + sq(red(above) - red(below)));
      float newG = sqrt(sq(green(left) - green(right)) + sq(green(above) - green(below)));
      float newB = sqrt(sq(blue(left) - blue(right)) + sq(blue(above) - blue(below)));
      b.pixels[y*width+x] = color((newR + newG + newB)/3);
    }
  }
  b.updatePixels();
  return b;
}

int avg (PImage img) {
  img.loadPixels();
  int sum = 0;
  for (int i = 0;i<img.pixels.length;i++) {
    if (red(img.pixels[i]) != 0) {
      sum+=red(img.pixels[i]);
    }
  }
  return (sum/img.pixels.length);
}

PImage adjust(PImage img, int s) {
  img.loadPixels();
  for (int i=0;i<img.pixels.length;i++) {
    if (red(img.pixels[i]) != 0) {
      try {
      img.pixels[i] = color(red(img.pixels[i]) - s);
      } catch(Exception e) {
      }
    }
  }
  img.updatePixels();
  return img;
}

int differenceDetect(PImage a, PImage b) {
  reds=0;
  a.loadPixels();
  b.loadPixels();
  //PImage c = createImage(width,height,RGB);
  //c.loadPixels();
  for (int i=0;i<a.pixels.length;i++) {
    if (abs(red(a.pixels[i]) - red(b.pixels[i])) >= thresh) {
      reds++;
      //c.pixels[i] = color(255,0,0);
    }
  }
  //c.updatePixels();
  println(reds);
  return reds;
}


