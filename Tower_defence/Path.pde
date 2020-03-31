class Path {

  Vector[] Pathway;
  Lane[] allLanes;
  Vector spawnPos;

  class Lane {
    int endPos;
    Direction dir;

    Lane(Direction _dir, Vector cell)
    {
      dir = _dir;
      if (_dir == Direction.up || _dir == Direction.down)
      {
        endPos = round(cellSize * cell.y);
      } else
      {
        endPos = round(cellSize * cell.x);
      }
    }
  }

  Path(Vector[] v)
  {
    Pathway = v;
    Direction[] directions = new Direction[v.length - 1];

    for (int i = 0; i < v.length - 1; i++)
    {
      Grid[v[i].x][v[i].y].isPath = true;

      int difference = v[i].x - v[i + 1].x;
      if (difference != 0)
      {
        for (int z = 0; z < abs(difference); z++)
        {
          if (difference < 0)
          {
            Grid[v[i].x + z][v[i].y].isPath = true;
            directions[i] = Direction.right;
          } else
          {
            Grid[v[i].x - z][v[i].y].isPath = true;
            directions[i] = Direction.left;
          }
        }
      } else
      {
        difference = v[i].y - v[i + 1].y;

        for (int z = 0; z < abs(difference); z++)
        {
          if (difference < 0)
          {
            Grid[v[i].x][v[i].y + z].isPath = true;
            directions[i] = Direction.down;
          } else
          {
            Grid[v[i].x][v[i].y - z].isPath = true;
            directions[i] = Direction.up;
          }
        }
      }
    }
    if (v.length > 0)
    {
      Grid[v[v.length - 1].x][v[v.length - 1].y].isPath = true;
    }

    allLanes = new Lane[directions.length];
    for (int i = 0; i < allLanes.length; i++)
    {
      allLanes[i] = new Lane(directions[i], v[i + 1]);
    }
  }
}
