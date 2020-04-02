class Tower
{
  int cellX;
  int cellY;
  
  Tower(int x, int y)
  {
    cellX = x;
    cellY = y;
  }
  
    
  void drawTower()
  {
    image(rocketTower, cellX * cellSize , cellY * cellSize, cellSize, cellSize);
  }
}
