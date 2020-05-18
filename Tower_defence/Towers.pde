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
  

  Tower(int x, int y, int sprite)
  {
    spriteIndex = sprite;
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

    for (int i = 0; i < AllEnemies.size(); i++) { //attack the next enemy
      if (getDistance(this, AllEnemies.get(i)) < range) {
        attack(AllEnemies.get(i));
        i = AllEnemies.size();
      }
    }
  }

  void attack(Enemy e) {
    target = e;
    lastAttack = millis();    
    AllProjectiles.add(new Projectile(this, e, projectileSprite, (int)random(damage, damage)));
  }
  Tower() {
  }
}

class RocketTower extends Tower {
  // 6 skud til at dræbe 1
    void init() {
    type = TowerTypes.rocketTower;
    spriteIndex = 0;
    projectileSprite = 0;
    range = 200;
    reloadTime = 1000;
    cost = 25;
    damage = 2;
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
  // 11 skud til at dræbe 1
    void init() {
    type = TowerTypes.gunTower;
    spriteIndex = 1;
    projectileSprite = 1;
    range = 400;
    reloadTime = 300;
    cost = 50;
    damage = 1;
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

class SniperTower extends Tower {
  // 1 skud til at dræbe 1
    void init() {
    type = TowerTypes.sniperTower;
    spriteIndex = 2;
    projectileSprite = 1;
    range = 750;
    reloadTime = 3000;
    cost = 75;
    damage = 10;
  }  

  SniperTower(int x, int y) {
    cellX = x;
    cellY = y;
    init();
  }

  SniperTower() {
    init();
  }
}

class RailTower extends Tower {
  // 1 skud til at dræbe 1
    void init() {
    type = TowerTypes.railTower;
    spriteIndex = 3;
    projectileSprite = 2;
    range = 750;
    reloadTime = 1000;
    cost = 200;
    damage = 10;
  }  

  RailTower(int x, int y) {
    cellX = x;
    cellY = y;
    init();
  }

  RailTower() {
    init();
  }
}
