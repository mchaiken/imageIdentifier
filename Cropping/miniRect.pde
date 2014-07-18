class miniRect {
  
  int x;
  int y;
  boolean flexibleY;
  
  public miniRect(int x1, int y1,boolean fy) {
    x = x1;
    y = y1;
    flexibleY = fy;

  }

  
  int getX() {
    return x;
  }
  
  int getY() {
    return y;
  }
  
  void setX(int n) {
    x = n;
  }
  
  void setY(int n) {
    y = n;
  }
  
  void display() {
    fill(0);
    rect(x,y,6,6);
    noFill();
    

    /*
    if (mousePressed == true && 
        mouseX>=x && mouseX<=x+6 &&
        mouseY>=y && mouseY<=y+6) {
          if (flexibleY) {
            y = mouseY;
          } else {
            x = mouseX;
          }
        }
   */     
  }
  
}

