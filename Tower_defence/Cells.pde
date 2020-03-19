class Cell {
  int x;
  int y;

  Tower occupant = null;

  void buildOn(Tower t)
  {
    if(buildable())
    {
      occupant = t;
      AllTowers.add(occupant);
    }
  }

  boolean buildable()
  {
    if (occupant == null)
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
    stroke(250, 0, 0);
    rect(x * cellSize, y* cellSize, cellSize, cellSize);
  }


  Cell (int _x, int _y)
  {
    x=_x;
    y=_y;
  }
}
