class Cell {
  int x;
  int y;

  boolean isPath = false;

  Tower occupant = null;

  void buildOn(Tower t)
  {
    if (buildable())
    {
      occupant = t;
      AllTowers.add(occupant);
    }
  }

  boolean buildable()
  {
    if (occupant == null && !isPath)
    {
      return true;
    } else
    {
      return false;
    }
  }

  void outlineSelected()
  {
    noFill();
    if (buildable())
    {
      stroke(0, 255, 0);
      tint(255, 126);
      if(selectedTower==1)
      {
      image(TowerSprites[0], x * cellSize, y * cellSize, cellSize, cellSize);
      }
      if(selectedTower==2)
      {
      image(TowerSprites[1], x * cellSize, y * cellSize, cellSize, cellSize);
      }
      if(selectedTower==3)
      {
      image(TowerSprites[2], x * cellSize, y * cellSize, cellSize, cellSize);
      }
      if(selectedTower==4)
      {
      image(TowerSprites[3], x * cellSize, y * cellSize, cellSize, cellSize);
      }
      noTint();
    } else
    {
      stroke(255, 0, 0);
    }
    rect(x * cellSize, y* cellSize, cellSize, cellSize);
  }


  Cell (int _x, int _y)
  {
    x=_x;
    y=_y;
  }
}
