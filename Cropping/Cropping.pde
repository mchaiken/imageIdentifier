import processing.video.*;

Capture cam;

boolean takingPics, corner1, corner2, adjusting, findPainting;

PImage currentPic;
int x1, y1, x2, y2;
PImage img;
dragRect d;
float rotation;

Painting match;
int infoX;
int infoY;

PFont font= createFont("Georgia", 20);
PFont font2= createFont("Impact", 20);



void setup() {
  size(640, 480);
  frame.setResizable(true);
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
    text("Click the top left corner, then the bottom right to crop", 60, 30);
  } else if (corner2) {
    image(currentPic, 0, 0);
    text("Click the top left corner, then the bottom right to crop", 60, 30);
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
   
    String s = "Hold the arrow key corresponding to the side to ajust. Move the mouse to change its position. Press 'a' to rotate image clockwise, 's' for counterclockwise. Press space when done.";
    text(s, 30, 10, 600,400);

  } else if (findPainting) {
    image(match.image,0,0);
    match.info(infoX,infoY);
    match.description();
    /*
    imageMode(CENTER);
    match.image.resize((match.image.height/480)*640,480);
    image(match.image, 320,240);
    size(640,480);
    match.info(infoX, infoY);
    */
    
  }
}
void takePicture() {
  cam.read();
  image(cam, 0, 0);
  saveFrame("uncropped.png");
  currentPic = loadImage("uncropped.png");
}

void mouseClicked() {
  if (takingPics) {
    takePicture();
    takingPics = false;
    corner1 = true;
    cam.stop();
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
    cropped.save("cropped.jpg");
    adjusting = false;
    findPainting();
    if (match.image.width<match.image.height) {
      match.image.resize(0,700);
    }
    else {
      match.image.resize(700,0);
    }
    frame.setSize(match.image.width,match.image.height);
    infoX = match.image.width/3;
    infoY = match.image.height/3;
    findPainting=true;


  }
}
void findPainting() {
  background(255);
  text("Searching for match...", 200, 300);
  String walters="http://api.thewalters.org/v1/objects?";
  walters+="classification=painted&pageSize=500";
  walters+="&apikey=ixtKD8sehL003wsd31zUzJOtIvYG7jvyUXHKEBIrSh96R9fhsC7w9ZGPZ02HabWy";
  img=loadImage("cropped.jpg");

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
  }
}

