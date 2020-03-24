int HEIGHT = 512;
int WIDTH = 640;
float playWindowHeight = WIDTH *0.65;
float cellSize = WIDTH/20;
float menuPosY = playWindowHeight + 1;
float menuHeight = HEIGHT - menuPosY;

Cell [][] Grid = new Cell[20][13];

PImage path;

Cell hoverCell = null;

Vector[] Pathway;

ArrayList<Tower> AllTowers = new ArrayList<Tower>();

void setup()
{
  size(640, 512);

  for (int x=0; x<Grid.length; x++)
  {
    for (int y=0; y< Grid[0].length; y++)
    {
      Grid[x][y] = new Cell(x, y);
    }
  }

  Vector[]_path = new Vector[]
    {   
    new Vector(0, 2), 
    new Vector(13, 2), 
    new Vector(13, 6), 
    new Vector(2, 6), 
    new Vector(2, 11), 
    new Vector(7, 11), 
    new Vector(7, 9), 
    new Vector(19, 9), 
  };
  initializePath(_path);

  path = loadImage("map.png");
}

void draw()
{
  background(255,0,0);
  image(path,0,0, width, playWindowHeight);
  
  for(int i = 0; i< AllTowers.size(); i++)

  {
    AllTowers.get(i).drawTower();
  }

  mouseCheck();
}

void mouseCheck()
{
  int x = (int)(mouseX/ cellSize);
  int y = (int)(mouseY/ cellSize);

  if (x<Grid.length && y<Grid[0].length)
  {
    hoverCell = Grid[x][y];
    hoverCell.outlineSelected();
  }
}

void mousePressed()
{
  if (hoverCell != null)
  {
   // println("new Vector(" + hoverCell.x + ", " + hoverCell.y + "),");
    if (hoverCell.buildable())
    {
      hoverCell.buildOn(new Tower (hoverCell.x, hoverCell.y));
    }
  }
}

void initializePath(Vector[] v)
{
  Pathway = v;

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
        } else
        {
          Grid[v[i].x - z][v[i].y].isPath = true;
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
        } else
        {
          Grid[v[i].x][v[i].y - z].isPath = true;
        }
      }
    }
  }
  if (v.length > 0)
  {
    Grid[v[v.length - 1].x][v[v.length - 1].y].isPath = true;
  }
}

void setUnbuildable(Vector v)
{
  Grid[v.x][v.y].isPath = true;
}
