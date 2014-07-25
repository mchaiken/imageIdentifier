import java.util.*;
ArrayList<String> files=new ArrayList<String>();

Painting checkImages(PImage img) {
  //int imgWeight = edgeWeight(img);

  float best=MAX_INT;
  int weight;
  int comparison;
  float ratio;
  float smallestRatio=MAX_INT;
  int weightDifference;
  Painting ret;


  BlobDetection b=new BlobDetection(img.width, img.height);
  b.setPosDiscrimination(false);
  b.setThreshold(1.0f);
  b.computeBlobs(img.pixels);
  int blobs= b.getBlobNb();

  if (blobs!=0) {
    File parent1 = new File("Desktop/PaintingsByBlobCount/"+(blobs-1));
    addFiles(parent1);
  }
  File parent2 = new File("Desktop/PaintingsByBlobCount/"+blobs);
  if (blobs!=1000) {
    File parent3 = new File("Desktop/PaintingsByBlobCount/"+(blobs+1));
    addFiles(parent3);
  }

  addFiles(parent2);


  String closestMatch=files.get(0);
  for (int i=0; i<files.size (); i++) {
    println(i);
    PImage dataBaseImage;
    try {
      if (files.get(i).indexOf("tate") != -1) {
        dataBaseImage=loadImage(loadJSONObject(files.get(i)).getString("thumbnailURL"));
      } else if (files.get(i).indexOf("brooklyn") != -1) {
        dataBaseImage=loadImage(loadJSONObject(files.get(i)).getString("image_uri"));
      } else {
        dataBaseImage=loadImage(loadJSONObject(files.get(i)).getJSONObject("PrimaryImage").getString("Raw"));
      }
      //weight=edgeWeight(dataBaseImage);
      //comparison= isSame(img, dataBaseImage);
      //weightDifference= isSame(img, dataBaseImage);
      ratio= abs((dataBaseImage.width/dataBaseImage.height) - (img.width/img.height));
      best= ratio;
      if (ratio < smallestRatio) {
        smallestRatio= ratio;
        closestMatch=files.get(i);
      }
    }
  catch(Exception e) {
  }
}
JSONObject smallest=loadJSONObject(closestMatch);
if (closestMatch.indexOf("tate") != -1) {
  ret=new Painting(smallest.getString("title"), smallest.getString("all_artists"), smallest.getString("medium"), loadImage(smallest.getString("thumbnailUrl")), "The Tate");
} else if (closestMatch.indexOf("brooklyn") != -1) {
  ret= new Painting(smallest.getString("caption"), smallest.getString("credit"), smallest.getString("notes"), loadImage(smallest.getString("image_uri")), "The Brooklyn Museum");
} else {
  ret=new Painting(smallest.getString("ObjectName"), smallest.getString("Creator"), smallest.getString("Description"), loadImage(smallest.getJSONObject("PrimaryImage").getString("Raw")), "Walters Museum");
}

return ret;
}

void addFiles(File f) {

  for (File x : f.listFiles ()) {
    if (x.isDirectory()) {
      addFiles(x);
    } else if (!x.getName().equals(".DS_Store")) {
      files.add(x.getAbsolutePath());
    }
  }
}

