class Painting {
  String title;
  String artist;
  String description;
  PImage image;
  String museum;


  Painting() {
    String title="";
    String artist="";
    String description="";
    String museum="";
  }
  
  
    Painting(String t, String a, String d, PImage i, String m) {
      title=t;
      artist=a;
      description= d;
      image=i;
      museum=m;
    }
  }

