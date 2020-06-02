class Path {

  Vector[] Pathway;
  Lane[] allLanes;
  Vector spawnPos;
  
  Vector getSpawn()
  {
    return spawnPos;
  }
  
  Direction getDir(int i)
  {
    if(i < allLanes.length)
    {
      return allLanes[i].dir;
    } else
    {
      return allLanes[allLanes.length - 1].dir;
    }
  }

  PathStatus checkPos(Vector v, int lane)
  {
    if(lane > allLanes.length - 1) //Path færdig
    {
      return PathStatus.finished;
    }
    boolean check = allLanes[lane].checkPos(v);
    if(check)
    {
      return PathStatus.next; // Drej
    } else
    {
      return PathStatus.stay; //Fortsæt lige ud
    }
  }

  class Lane {
    int endPos;
    Direction dir;
    
    boolean checkPos(Vector v) {
      if (dir == Direction.up) {
        if (endPos > v.y) return true;
        else return false;
      } 
      else if (dir == Direction.down) {
        if (endPos < v.y) return true;
        else return false;
      } 
      else if (dir == Direction.left) {
        if (endPos > v.x) return true;
        else return false;
      } 
      else {
        if (endPos < v.x) return true;
        else return false;
      }
    }

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
    spawnPos = new Vector(round(v[0].x * cellSize), round(v[0].y * cellSize)); 

    for (int i = 0; i < v.length - 1; i++)
    {
      Grid[v[i].x][v[i].y].isPath = true;

      int difference = v[i].x - v[i + 1].x;
      if (difference != 0)
      {
        for (int z = 0; z < abs(difference); z++)
        {
          if (difference < 0) //til højre
          {
            Grid[v[i].x + z][v[i].y].isPath = true;
            directions[i] = Direction.right;
          } else //til venstre
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
