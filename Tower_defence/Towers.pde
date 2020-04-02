class Tower
{
  int cellX;
  int cellY;

  int cost = 25;
  int range = 200;
  int reloadTime = 1000;
  int lastAttack = 0;
  Enemy target = null;
  ArrayList<Enemy> attackThisRound;
  
    int projectileSprite = 0;

  int damage = 10;

  Tower(int x, int y)
  {
    cellX = x;
    cellY = y;
  }

  void drawTower()
  {
    image(rocketTower, cellX * cellSize, cellY * cellSize, cellSize, cellSize);
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
}
