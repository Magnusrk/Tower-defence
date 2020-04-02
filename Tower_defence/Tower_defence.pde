int HEIGHT = 800;
int WIDTH = 1000;
float playWindowHeight = WIDTH *0.65;
float cellSize = WIDTH/20;
float menuPosY = playWindowHeight + 1;
float menuHeight = HEIGHT - menuPosY;

Cell [][] Grid = new Cell[20][13];

PImage path;
PImage rocketTower;
EnemySprite[] EnemySprites;

Cell hoverCell = null;

Path Level;

ArrayList<Tower> AllTowers = new ArrayList<Tower>();
ArrayList<Enemy> AllEnemies = new ArrayList<Enemy>();

int baseLives = 10;
int scrap = 100;

void setup()
{
  size(1000, 800);

  for (int x=0; x<Grid.length; x++)
  {
    for (int y=0; y< Grid[0].length; y++)
    {
      Grid[x][y] = new Cell(x, y);
    }
  }
  
  EnemySprites = new EnemySprite[]
  {
    new EnemySprite("ene1"),
  };

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
 
 Level = new Path(_path);

  path = loadImage("Levels/map.png");
  rocketTower = loadImage("Towers/rocketTower.png");
}

void draw()
{
  background(255,0,0);
  image(path,0,0, width, playWindowHeight);
  
  for(int i = 0; i< AllTowers.size(); i++)

  {
    AllTowers.get(i).drawTower();
  }
  
  for (int i = 0; i < AllEnemies.size(); i++)
  {
    AllEnemies.get(i).move();
  }

  mouseCheck();
  winloseCheck();
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

void keyPressed()
{
  if(key == 'a')
  {
    AllEnemies.add(new Enemy(0));
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

void setUnbuildable(Vector v)
{
  Grid[v.x][v.y].isPath = true;
}

void winloseCheck()
{
  if(baseLives==0)
  {
    println("GAME OVER");
  }
}

void leak(Enemy e)
{
  AllEnemies.remove(e);
  
  baseLives--;
  println("Base damaged");
}
