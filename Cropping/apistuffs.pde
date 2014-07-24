import java.util.*;
import java.io.*;
import java.net.*;
ArrayList<File> tateFiles=new ArrayList<File>();
boolean foundMatch=false;
String[] files= {
  "lisa1.png", "scream1.png", "night3.png", "night1.png", "night4.png", "lunch1.png", "girl1.png"
};


Painting checkWalters(String url, PImage img) {
  foundMatch=false;
  JSONObject results=loadJSONObject(url);
  JSONArray items = results.getJSONArray("Items");
  int pred=0;
  int smallest=75000;
  JSONObject ret=items.getJSONObject(0);

  for (int i=0; i< items.size (); i++)
  {
  
    PImage temp;
    try {
      temp =loadImage(items.getJSONObject(i).getJSONObject("PrimaryImage").getString("Raw"));
    }
    catch(Exception e) {
      i++;
      temp=loadImage(items.getJSONObject(i).getJSONObject("PrimaryImage").getString("Raw"));
    }
    while (temp == null) {
      i++;
      temp=loadImage(items.getJSONObject(i).getJSONObject("PrimaryImage").getString("Raw"));
    }
    pred=isSame(temp, img);
    if (pred<50000 && pred<smallest) {
      ret= items.getJSONObject(i);
      smallest=pred;
      foundMatch=true;
    }
  }

  return new Painting(ret.getString("ObjectName"),ret.getString("Creator"),ret.getString("Description"),loadImage(ret.getJSONObject("PrimaryImage").getString("Raw")),"Walters Museum");
}



void addFiles(File f) {
  println(f);

  for (File x : f.listFiles ()) {
    if (x.isDirectory()) {
      addFiles(x);
    } else {
      tateFiles.add(x);
    }
  }
}


Painting checkTate(PImage img) {
  println(System.getProperty("user.dir"));
  File parent= new File("./Desktop/imageIdentifier/art/artworks");
  println(parent.exists());
  addFiles(parent);
  int pred=36096;
  JSONObject smallest=loadJSONObject(tateFiles.get(0));
  for (File x : tateFiles) {
    JSONObject art=loadJSONObject(x);
    try {
      PImage painting = loadImage(art.getString("thumbnailUrl"));
      if (sizeCompare(painting,img)) {
        int redCount=isSame(painting, img);
        println("going");
        if (redCount<pred) {
           smallest= art;
          foundMatch=true;
           break;
        }
      }
    }
    catch(Exception e) {
    }
  }
  if (foundMatch)
    return new Painting(smallest.getString("title"), smallest.getString("all_artists"), smallest.getString("medium"), loadImage(smallest.getString("thumbnailUrl")), "The Tate");
  return new Painting();
}
