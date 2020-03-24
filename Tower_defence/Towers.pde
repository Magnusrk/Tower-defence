class Tower
{
  int cellX;
  int cellY;
  
  void drawTower()
  {
    fill(255,0,0);
    stroke(255);
    ellipseMode(CORNER);
    ellipse(cellX * cellSize , cellY * cellSize, cellSize, cellSize);
  }
  
  Tower(int x, int y)
  {
    cellX = x;
    cellY = y;
  }
}
