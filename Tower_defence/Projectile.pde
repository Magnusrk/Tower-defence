class Projectile {
  Tower owner;
  Enemy target;
  int sprite;

  int posX;
  int posY;
  float distance = 0;

  int damage = 0;


  void move() {
    if (!target.alive) AllProjectiles.remove(this);
    distance += .07;
    float x = lerp(owner.cellX * cellSize + cellSize/2, target.posX + cellSize/2, distance);
    float y = lerp(owner.cellY * cellSize + cellSize/2, target.posY + cellSize/2, distance);
    posX = round(x);
    posY = round(y); 

    image(ProjectileSprites[sprite], posX, posY, cellSize/6, cellSize/6);
    if (distance >= 1) hit();
  }

  void aamove() {
    distance -= 2;
    float tX = target.posX + cellSize/2;
    float tY = target.posY + cellSize/2;
    float dx = tX - posX;
    float dy = tY - posY;
    float angle1 = atan2(dy, dx);  
    posX = round(tX - (cos(angle1) * distance));
    posY = round(tY - (sin(angle1) * distance));

    image(ProjectileSprites[sprite], posX, posY, cellSize/6, cellSize/6);
    if (distance < 0) hit();
  }


  void hit() {
    target.hit(damage);
    AllProjectiles.remove(this);
  }

  Projectile(Tower o, Enemy t, int sprite, int dmg) {
    owner = o;
    target = t;
    posX = (int) round((owner.cellX * cellSize) + cellSize/2);
    posY = (int) round((owner.cellY * cellSize) + cellSize/2);
    distance = 0;
    damage = dmg;
  }
}
