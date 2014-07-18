PImage img1, img2;
int thresh;
void setup() {
  thresh = 30;
  
  img1 = loadImage("scream1.png");
  img2 = loadImage("scream2.png");
  img2.resize(img1.width,img1.height);
  size(img1.width,img2.height);
  img1 = edgeDetect(img1);
  img2 = edgeDetect(img2);
  int one = avg(img1);
  int two = avg(img2);
  
  if (one>two) {
    img1 = adjust(img1,one-two);
  } else {
    img2 = adjust(img2,two-one);
  }

  image(differenceDetect(img1,img2),0,0);
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

PImage differenceDetect(PImage a, PImage b) {
  int reds = 0;
  a.loadPixels();
  b.loadPixels();
  PImage c = createImage(width,height,RGB);
  c.loadPixels();
  for (int i=0;i<a.pixels.length;i++) {
    if (abs(red(a.pixels[i]) - red(b.pixels[i])) >= thresh) {
      reds++;
      c.pixels[i] = color(255,0,0);
    }
  }
  c.updatePixels();
  println(reds);
  return c;
}

void draw() {
}
