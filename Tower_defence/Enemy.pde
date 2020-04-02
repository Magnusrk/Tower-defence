class EnemySprite{
  PImage[] up = new PImage[2];
  PImage[] down = new PImage[2];
  PImage[] left = new PImage[2];
  PImage[] right = new PImage[2];
  
  PImage getImage(Direction dir, int anim)
  {
    if(dir == Direction.up)
    {
      return up[anim];
    } else if(dir == Direction.down)
    {
      return down[anim];
    } else if(dir == Direction.left)
    {
      return left[anim];   
    } else
    {
      return right[anim];
    }
  }
  
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

class Enemy{
  int posX;
  int posY;
  int onLane = 0;
  Direction dir;
  
  int speed = 3;
  int hitPoints = 1;
  
  int spriteIndex;
  int anim = 0;
  
  int animTimer = 0;
  int animDelay = 2;
  
  boolean alive = true;
  
  Enemy(int sprite, int hp){
    hitPoints = hp;
    spriteIndex = sprite;
    Vector p = Level.getSpawn();
    posX = p.x;
    posY = p.y;
    dir = Level.getDir(0);
    alive = true;
  }
  
    void hit(int damage) {
    hitPoints -= damage;
    if (hitPoints < 1) death(this);
  }
  
  void move()
  {
    PathStatus status = Level.checkPos(new Vector(posX, posY), onLane);
    if(status == PathStatus.finished)
    {
      leak(this);
      return;
    } else if(status == PathStatus.next)
    {
      onLane ++;
      dir = Level.getDir(onLane);
    }
    
    if(dir == Direction.up) posY -= speed;
    else if(dir == Direction.down) posY += speed;
    else if(dir == Direction.left) posX -= speed;
    else posX += speed;
    
    image(EnemySprites[spriteIndex].getImage(dir, anim), posX, posY, cellSize, cellSize);
    
    animTimer++;
    if(animTimer > animDelay)
    {
      animTimer = 0;
      if (anim == 0) anim = 1;
      else anim = 0;
    }
  }
}
