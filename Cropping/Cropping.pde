

import processing.video.*;

Capture cam;

boolean takingPics, corner1, corner2, adjusting, findPainting;
PImage currentPic;
int pics;
int x1, y1, x2, y2;
int infoX=250;
int infoY=350;
PImage img;
Painting match;
dragRect d;
PFont font2= createFont("Impact", 20);
float rotation;


void setup() {
  size(640, 480);
  PFont font= createFont("Georgia", 20);
  fill(0);
  textFont(font);
  rotation = 0;

  takingPics = true;

  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
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
    text("Click to take a picture", 200, 30);
  } else if (corner1) {
    image(currentPic, 0, 0);
    text("Click the top left corner, release and move the mouse to crop", 60, 30);
  } else if (corner2) {
    image(currentPic, 0, 0);
    noFill();
    rect(x1, y1, mouseX-x1, mouseY-y1);
  } else if (adjusting) {
    background(255);
    translate(currentPic.width/2,currentPic.height/2);
    rotate(radians(rotation));
    translate(-currentPic.width/2,-currentPic.height/2);
    image(currentPic,0,0);
    
    translate(currentPic.width/2,currentPic.height/2);
    rotate(radians(-rotation));
    translate(-currentPic.width/2,-currentPic.height/2);    
    d.display();
    text("Hold the arrow key corresponding to the side to ajust", 80, 30);
    text("move the mouse to change position. Press Space when done", 75, 50);
    text("Press 'a' to rotate image clockwise, 's' for counterclockwise",80,70);

  } else if (findPainting) {

    imageMode(CENTER);
    match.image.resize((match.image.height/480)*640,480);
    image(match.image, 320,240);
        size(640,480);
        match.info();
    
  }
}
void takePicture() {
  pics++;
  cam.read();
  image(cam, 0, 0);
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
    d = new dragRect(x1, y1, x2, y2);
  }
  else if(findPainting){
    if (match.overDescription())
      match.displayDescription=!match.displayDescription;
  }
}

void keyPressed() {
  if (adjusting && keyCode == 65) {
    rotation += 5;
  } else if (adjusting && keyCode == 83) {
    rotation -= 5;
  } else if (adjusting && keyCode == 32) {
    translate(currentPic.width/2,currentPic.height/2);
    rotate(radians(rotation));
    translate(-currentPic.width/2,-currentPic.height/2);
    image(currentPic,0,0);
    PImage cropped = createImage(abs(d.getW()), abs(d.getH()), RGB);
    cropped = get(d.getX(), d.getY(), d.getW(), d.getH());
    cropped.save(pics + "-cropped.jpg");
    adjusting = false;
        findPainting();
    findPainting=true;
    //background(255);
    //text("Searching for match...", 200, 300);

  }
}
void findPainting() {

  String walters="http://api.thewalters.org/v1/objects?";
  walters+="classification=painted&pageSize=500";
  walters+="&apikey=ixtKD8sehL003wsd31zUzJOtIvYG7jvyUXHKEBIrSh96R9fhsC7w9ZGPZ02HabWy";
  img=loadImage("1-cropped.jpg");

  match = checkTate(img);
  if (!foundMatch) {
    match = checkWalters(walters, img);
  }
}
void mouseDragged(){
  if (findPainting){
    infoX=mouseX+5;
        infoY=mouseY+5;
    if (infoY < 20+(30*match.titleLength)){
        infoY=20+(30*match.titleLength);
    }
    match.resizeText(infoX-5);
  }
}

