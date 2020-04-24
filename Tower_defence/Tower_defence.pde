int HEIGHT = 800;
int WIDTH = 1000;
float playWindowHeight = WIDTH *0.65;
float cellSize = WIDTH/20;
float menuPosY = playWindowHeight + 1;
float menuHeight = HEIGHT - menuPosY;

Cell [][] Grid = new Cell[20][13];

PImage path;
PImage[] TowerSprites;
EnemySprite[] EnemySprites;
PImage[] ProjectileSprites;

Cell hoverCell = null;

Path Level;
int selectedTower = 0;
ArrayList<Tower> AllTowers = new ArrayList<Tower>();
ArrayList<Enemy> AllEnemies = new ArrayList<Enemy>();
ArrayList<Projectile> AllProjectiles = new ArrayList<Projectile>();

int baseLives = 10;
int scrap = 100;

int stage;

Tower currentlyBuilding = null;

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

  TowerSprites = new PImage[] {
    loadImage("towers/t1.png"), 
    loadImage("towers/t2.png"), 
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

  ProjectileSprites = new PImage[] {
    loadImage("projectile/01.png"), 
    loadImage("projectile/02.png"), 
    loadImage("projectile/03.png"), 
  };

  Level = new Path(_path);

  path = loadImage("Levels/map.png");
}

void draw()
{
  background(255, 0, 0);
  image(path, 0, 0, width, playWindowHeight);

  for (int i = 0; i< AllTowers.size(); i++)
  {
    AllTowers.get(i).drawTower();
  }

  for (int i = 0; i < AllEnemies.size(); i++)
  {
    AllEnemies.get(i).move();
  }

  for (int i = 0; i < AllTowers.size(); i++) {
    AllTowers.get(i).action();
  }
  for (int i = 0; i < AllProjectiles.size(); i++) AllProjectiles.get(i).move();

  mouseCheck();
  winloseCheck();
  UI();
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
  if (key == 'a')
  {
    AllEnemies.add(new Enemy(0, 10));
  }
}
void mousePressed()
{
  if (mouseY<650) {
    if (hoverCell != null)
    {
      // println("new Vector(" + hoverCell.x + ", " + hoverCell.y + "),");
      if (hoverCell.buildable())
      {
        if (selectedTower == 1 && scrap>=25)
        {
          hoverCell.buildOn(new RocketTower(hoverCell.x, hoverCell.y));
          scrap-=25;
          selectedTower=0;
        }
        if (selectedTower == 2 && scrap>=50)
        {
          hoverCell.buildOn(new GunTower(hoverCell.x, hoverCell.y));
          scrap-=50;
          selectedTower=0;
        }
      }
    }
  }

  if ((mouseX>100-50) && (mouseY>700-50) && (mouseX<100+50) && (mouseY<700+50)) 
  {
    selectedTower = 1;
  }
  if ((mouseX>200-50) && (mouseY>700-50) && (mouseX<200+50) && (mouseY<700+50)) 
  {
    selectedTower = 2;
  }
}

void setUnbuildable(Vector v)
{
  Grid[v.x][v.y].isPath = true;
}



void winloseCheck()
{
  if (baseLives==0)
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

void death(Enemy e) {
  scrap++;
  AllEnemies.remove(e);
  e.alive = false;
  removeTarget(e);
}

void removeTarget(Enemy e) {
  for (int i = 0; i < AllTowers.size(); i++) if (AllTowers.get(i).target == e) AllTowers.get(i).target = null;
}

int getDistance(Tower t, Enemy e) { // returns the manhattan distance in pixels


  float man = 0;
  float x = abs(((t.cellX * cellSize) + cellSize/2) - e.posX);
  float y = abs(((t.cellY * cellSize) + cellSize/2) - e.posY);
  man = x + y;
  return round(man);
}
