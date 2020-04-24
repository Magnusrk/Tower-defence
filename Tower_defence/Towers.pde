class Tower
{
  TowerTypes type = null;
  int cellX;
  int cellY;

  int spriteIndex;
  int cost = 0;
  int range = 200;
  int reloadTime = 1000;
  int lastAttack = 0;
  Enemy target = null;
  ArrayList<Enemy> attackThisRound;

  int projectileSprite = 0;

  int damage = 0;

  Tower(int x, int y)
  {
    cellX = x;
    cellY = y;
  }

  void drawTower()
  {
    image(TowerSprites[spriteIndex], cellX * cellSize, cellY * cellSize, cellSize, cellSize);
  }

  void action() {
    if (millis() < lastAttack + reloadTime) return; //still on cooldown

    if (target != null) { //check our current target
      if (getDistance(this, target) < range) { //attack them if we can
        attack(target);
        return;
      }
    }

    for (int i = 0; i < AllEnemies.size(); i++) { //attack the next creep
      if (getDistance(this, AllEnemies.get(i)) < range) {
        attack(AllEnemies.get(i));
        i = AllEnemies.size();
      }
    }
  }

  void attack(Enemy e) {
    target = e;
    lastAttack = millis();    
    AllProjectiles.add(new Projectile(this, e, projectileSprite, (int)random(1, 10)));
  }
  
    Tower(int x, int y, int sprite) {
    cellX = x;
    cellY = y;
    spriteIndex = sprite;
  }

  Tower() {
  }
}

class RocketTower extends Tower {
  
    void init() {
    type = TowerTypes.rocketTower;
    spriteIndex = 0;
    range = 200;
    reloadTime = 1000;
    cost = 25;
    damage = 20;
  }  

  RocketTower(int x, int y) {
    cellX = x;
    cellY = y;
    init();
  }

  RocketTower() {
    init();
  }
}

class GunTower extends Tower {
  
    void init() {
    type = TowerTypes.rocketTower;
    spriteIndex = 1;
    range = 400;
    reloadTime = 300;
    cost = 50;
    damage = 10;
  }  

  GunTower(int x, int y) {
    cellX = x;
    cellY = y;
    init();
  }

  GunTower() {
    init();
  }
}
