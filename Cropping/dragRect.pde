class dragRect {
  
  int x,y;
  int w,h;
  miniRect top, bottom, left, right;



  
  public dragRect(int x1, int y1, int x2, int y2) {
    if (x2>=x1 && y2>=y1) {
    x = x1;
    y = y1;
    w = x2-x1;
    h = y2-y1;
    } else if (x2<x1 && y2>y1) {
      x = x2;
      y = y1;
      w = x1-x2;
      h = y2-y1;
    } else if (x2>x1 && y2<y1) {
      x = x1;
      y = y2;
      w = x2-x1;
      h = y1-y2;
    } else if (x2<x1 && y2<y1) {
      x = x2;
      y = y2;
      w = x1-x2;
      h = y1-y2;
    }
    top = new miniRect(x+(w/2)-3,y-3,true);
    bottom = new miniRect(x+(w/2)-3,y+h-3,true);
    left = new miniRect(x-3,y+(h/2)-3,false);
    right = new miniRect(x+w-3,y+(h/2)-3,false);
  }


  int getX() {
    return x;
  }
  int getY () {
    return y;
  } 
  int getW() {
    return w;
  }
  int getH() {
    return h;
  }
 
 void display() {
   
   x = left.getX()+3;
   y = top.getY()+3;
   w = right.getX()+3- x;
   h = bottom.getY()+3 - y;
   
   top.setX(x+(w/2)-3);
   bottom.setX(x+(w/2)-3);
   left.setY(y+(h/2)-3);
   right.setY(y+(h/2)-3);
   
   size(640,480);
   rect(x,y,w,h);
   top.display();
   bottom.display();
   left.display();
   right.display();
   
  
  if (keyPressed) {

    if (keyCode == 37) {
      left.setX(mouseX);
    } else if (keyCode == 38) {
      top.setY(mouseY);
    } else if (keyCode == 39) {
      right.setX(mouseX);
    } else if (keyCode == 40) {
      bottom.setY(mouseY);
    }

    
  }
  
 }
 
}
