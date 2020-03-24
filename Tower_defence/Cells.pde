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
