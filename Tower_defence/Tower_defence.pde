int HEIGHT = 512;
int WIDTH = 640;
float playWindowHeight = WIDTH *0.65;
float cellSize = WIDTH/20;
float menuPosY = playWindowHeight + 1;
float menuHeight = HEIGHT - menuPosY;

Cell [][] Grid = new Cell[20][13];

PImage path;

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
  
  mouseCheck();
}

void mouseCheck()
{
  int x = (int)(mouseX/ cellSize);
  int y = (int)(mouseY/ cellSize);
  
  if(x<Grid.length && y<Grid[0].length)
  {
    Grid[x][y].outlineSelected();
  }
}

class Cell{
  int x;
  int y;
  
  void outlineSelected()
  {
    noFill();
    stroke(250,0,0);
    rect(x * cellSize, y* cellSize, cellSize, cellSize);
  }
  
  
  Cell (int _x, int _y)
  {
    x=_x;
    y=_y;
  }
}
