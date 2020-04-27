class Wave {
  ArrayList<Enemy> enemies;
  int spawnTimer;
  
  int nextSpawn = 0;
  
  void man() {
    if(millis() >= nextSpawn) {
      nextSpawn = millis() + spawnTimer;
      waveSpawn();
    }
  }
  
  void waveSpawn() {
    if(enemies.size() < 1 ) finishWave();
    else {
      Enemy e = enemies.get(0);
      enemies.remove(0);
      spawn(e);
    }
  }

  Wave(ArrayList<Enemy> e, int s) {
    enemies = e;
    spawnTimer = s;
  }
}
