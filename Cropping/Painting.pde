class Painting {
  String title="";
  String formattedTitle="";
  String artist;
  String formattedArtist="";
  String description="";
  PImage image;
  int titleLength=3;
  int descriptionLength=1;
  String museum;
  boolean displayDescription=false;
  


  Painting() {
    String title="";
    String artist="";
    String description="";
    String museum="";
  }


  Painting(String t, String a, String d, PImage i, String m) {
    int x=0;
    for (x=0; x< (t.length ()-25); x+=25) {
      println(t.substring(x, x+25)+"\n");
      formattedTitle+=t.substring(x, x+25)+"\n";
      titleLength++;
    }
    formattedTitle+=t.substring(x, t.length());
    title=t;
    artist=a;
    formattedArtist=a;
    //description= d;
    int wdth=0;
    
    for (int c=0; c<d.length (); c++) {
      wdth+=textWidth(d.substring(c, c+1));
      if (wdth > 640) {
        wdth=0;
        description+="\n";
        descriptionLength++;
      }
      description+=d.substring(c, c+1);
    }
    println(description);
    
    image=i;
    museum=m;
  }
  
  
  
  void info() {
    textFont(font2);
    fill(225,85);
    rect(5, 5, infoX, infoY);
    fill(0);
    text("Title:\n "+formattedTitle, 10, 25);
    text("Artist: "+formattedArtist, 10, 20+(30*titleLength));
    description();
  }
  
  
  void resizeText(int windowSize) {
    formattedTitle="";
    int wdth=0;
    titleLength=3;
    for (int i=0; i<title.length (); i++) {
      wdth+=textWidth(title.substring(i, i+1));
      if (wdth > windowSize-20) {
        wdth=0;
        formattedTitle+="\n";
        titleLength++;
      }
      formattedTitle+=title.substring(i, i+1);
    }
    formattedArtist="";
    wdth=0; 
    for (int i=0; i<artist.length (); i++) {
      wdth+=textWidth(artist.substring(i, i+1));
      if (wdth > windowSize) {
        wdth=0;
        formattedArtist+="\n";
        titleLength++;
      }
      formattedArtist+=artist.substring(i, i+1);
    }
  }
  void description(){
    overDescription();
    if (displayDescription){
      fill(225);
      rect(0,480-(descriptionLength*40),640,40*descriptionLength);
      fill(0);
      text(description,10,480-20*descriptionLength);
    }
    else{
      fill(255);
      rect(545,445,82,30);
      fill(0);
      text("More Info",545+3,445+23);
    }
  }
  
  void overDescription(){
    if (!displayDescription &&
        (mouseX>=545) && (mouseX<=627) &&
        (mouseY>=445) && (mouseY<=475)) {
          displayDescription = true;
        }
    if (displayDescription && !(mouseY>=445)) {
      displayDescription = false;
    }
  }
}


