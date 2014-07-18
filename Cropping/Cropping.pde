

import processing.video.*;

Capture cam;

boolean takingPics, corner1, corner2,adjusting;
PImage currentPic;
int pics;
int x1,y1,x2,y2;
dragRect d;

void setup() {
  size(640, 480);
  
  takingPics = true;

  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    cam = new Capture(this, cameras[0]);

    cam.start();
  }
}

void draw() {
  if (takingPics) {
    if (cam.available() == true) {
      cam.read();
    }
    image(cam, 0, 0);
  } else if (corner1) {
    image(currentPic,0,0);
  } else if (corner2) {
    image(currentPic,0,0);
    noFill();
    rect(x1,y1,mouseX-x1,mouseY-y1);
  } else if (adjusting) {
    image(currentPic,0,0);
    d.display();
  }
}

void takePicture() {
  pics++;
  saveFrame(pics + "-uncropped.png");
  currentPic = loadImage(pics + "-uncropped.png");
}

void mouseClicked() {
  if (takingPics) {
    takePicture();
    takingPics = false;
    corner1 = true;
  } else if (corner1) {
    x1 = mouseX;
    y1 = mouseY;
    corner1 = false;
    corner2 = true;
  } else if (corner2) {
    x2 = mouseX;
    y2 = mouseY;
    corner2 = false;
    adjusting = true;
    d = new dragRect(x1,y1,x2,y2);
  }
}

void keyPressed() {
  if (adjusting && keyCode == 32) {
    image(currentPic,0,0);
    PImage cropped = createImage(abs(d.getW()),abs(d.getH()),RGB);
    cropped = get(d.getX(),d.getY(), d.getW(),d.getH());
    cropped.save(pics + "-cropped.jpg");
    adjusting = false;
    takingPics = true;
  }
}

