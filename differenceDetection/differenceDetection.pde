int reds;
void setup() {
  size(640, 480);
  println(isSame("night1.png","night2.png"));
  updateImage("night2.png",differenceDetect(edgeDetect("night2.png"), edgeDetect("night1.png")));
 
}

void draw() {
}

color[] edgeDetect(String img) {
  imageMode(CORNERS);
  image(loadImage(img), 0, 0, 640,640);
  loadPixels();
  color[]temp=new color[480*640];
  color[]temp2=new color[480*640];
  float up ;
  float down;
  float left;
  float right ;
  int val;
  int thresh=255;
  for (int y = 1; y < 478; y++) {
    for (int x= 1; x < 638; x++) {
      color w= pixels[y*640+x];
      w=color((int)(red(w)+green(w)+blue(w)) / 3);
      temp2[y*640+x]=w;
    }
  }
  for (int y = 1; y < 478; y++) {
    for (int x= 1; x < 638; x++) {
      up = red(temp2[(y*640)+(x-1)]);
      down = red(temp2[y*640+(x+1)]);
      left = red(temp2[((y-1)*640)+x]);
      right = red(temp2[((y+1)*640)+x]); 
      val=(int)sqrt(sq(left-right)+sq(up-down));
      if (val>thresh) {
        val=255;
      }

      temp[y*640+x]=color(val);
    }
  
  }

  for (int y = 1; y < 478; y++) {
    for (int x= 1; x < 638; x++) {

      pixels[y*640+x]=temp[y*640+x];
    }
  }
  updatePixels();
  println("Done");
  return temp;
}

color[] differenceDetect(color[] a1, color[] a2) {
  if (a1.length != a2.length) {
    println("The images must be the same size");
    return new color[0];
  }
  color[] ret= new color[a1.length];
  for (int i=1; i< a1.length-1; i++) {
    if ((red(a2[i])-100) <= red(a1[i]) && red(a1[i]) <= (red(a2[i])+100) ) {
      ret[i]= a1[i];
    } else {
      ret[i]=color(255,0,0);
      reds++;
     
    }
  }
  println(reds);
  println("sijdfhugjdefuh");
  return ret;
}
void updateImage(String img, color[] temp) {     
  image(loadImage(img), 0, 0);
  loadPixels();
  for (int i=0; i< pixels.length; i++) {
    pixels[i]=temp[i];
  }
  updatePixels();
  println("updated");
}

boolean isSame(String img1, String img2){
  /*int reds=0;
  color[]diff=differenceDetect(edgeDetect("Spot_the_difference1.png"), edgeDetect("Spot_the_difference2.png"));
  for(int i=0; i<diff.length; i++){
    if (diff[i] == color(255,0,0)){
      reds++;
    }
  } 
  println("done");
  */
  return reds <= 30000;
}
