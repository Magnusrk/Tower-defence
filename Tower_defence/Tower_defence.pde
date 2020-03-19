int HEIGHT = 512;
int WIDTH = 640;
float playWindowHeight = WIDTH *0.65;
float cellSize = WIDTH/20;
float menuPosY = playWindowHeight + 1;
float menuHeight = HEIGHT - menuPosY;

Cell [][] Grid = new Cell[20][13];

PImage path;

Cell hoverCell = null;

ArrayList<Tower> AllTowers = new ArrayList<Tower>();

void setup()
{
  size(640, 512);
  
  for(int x=0; x<Grid.length; x++)
  {
    for (int y=0; y< Grid[0].length; y++)
    {
      Grid[x][y] = new Cell(x,y);
    }
  }
  
  path = loadImage("map.png");
  
}

void draw()
{
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
  
  if(x<Grid.length && y<Grid[0].length)
  {
   hoverCell = Grid[x][y];
   hoverCell.outlineSelected();
  }
}

void mousePressed()
{
  if(hoverCell != null)
  {
    if (hoverCell.buildable())
    {
      hoverCell.buildOn(new Tower (hoverCell.x,hoverCell.y));
    }
  }
}
