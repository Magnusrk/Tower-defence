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

int baseLives = 30;
int scrap = 100;

int stage;

int test =0;

Tower currentlyBuilding = null;


//wave
Wave currentWave;
ArrayList<Wave> allWaves;
int onWave = 0;
String waveInfo = "";
boolean noWave = true;
int waveDelay = 15000;
int startWave = 0;
boolean endGame = false;
boolean gameOver = false;

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
  levelInit();
  path = loadImage("Levels/map.png");
}

void draw()
{
  background(255, 0, 0);
  image(path, 0, 0, width, playWindowHeight);

  if (gameOver) { 
    gameOver(); 
    return;
  }
  if (noWave) startWave();
  else if (currentWave != null) currentWave.man();

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

void spawn(Enemy e) {
  AllEnemies.add(e);
}

void gameOver() {
  gameOver = true;
  fill(000);
  textSize(50);
  text("Game Over", 180, 200);
}

void finishWave() {
  println("f");
  onWave ++;
  noWave = true;
  if (onWave < allWaves.size()) {
    currentWave = allWaves.get(onWave);
    startWave = waveDelay + millis();
  } else {
    currentWave = null;
    endGame = true;
  }
}


void startWave() {
  if (millis() > startWave) {
    if (!endGame) {
      noWave = false;
      waveInfo = "Wave " + (onWave + 1);
    } else {
      if (AllEnemies.size() < 1)gameOver();
    }
  } else {
    waveInfo = "Wave " + (onWave + 1) + " in:  " + round( (startWave - millis()) / 1000) + " sec";
  }
}



void levelInit() {
  ArrayList<Enemy> wave1 = new ArrayList<Enemy>();
  for (int i = 0; i < 20; i++) wave1.add(new Enemy(0, 5)); // new Creep (int image, int HIT POINTS)

  allWaves = new ArrayList<Wave>(); //MAKE SURE TO ADD THE WAVE TO THIS LIST!
  allWaves.add(new Wave(wave1, 1000)); //new Wave (ArrayList<Creep> creeps in wave, int DELAY BETWEEN CREEP SPAWNS)

  currentWave = allWaves.get(0);
  startWave = waveDelay + millis();
}
