class EnemySprite{
  PImage[] up = new PImage[2];
  PImage[] down = new PImage[2];
  PImage[] left = new PImage[2];
  PImage[] right = new PImage[2];
  
  EnemySprite(String name)
  {
    String path = "enemies/" + name + "/" + name + "_";
    up[0] = loadImage (path + "u0.png");
    up[1] = loadImage (path + "u1.png");
    down[0] = loadImage (path + "d0.png");
    down[1] = loadImage (path + "d1.png");
    left[0] = loadImage (path + "l0.png");
    left[1] = loadImage (path + "l1.png");
    right[0] = loadImage (path + "r0.png");
    right[1] = loadImage (path + "r1.png");
    
  }
}
