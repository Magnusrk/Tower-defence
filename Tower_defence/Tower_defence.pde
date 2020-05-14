int HEIGHT = 800;
int WIDTH = 1000;
float playWindowHeight = WIDTH *0.65;
float cellSize = WIDTH/20;
float menuPosY = playWindowHeight + 1;
float menuHeight = HEIGHT - menuPosY;

Cell [][] Grid = new Cell[20][13];
PImage t1;

PImage ground;
PImage groundpath;
PImage pathMask;
PImage metal;
PImage caution;

PFont font;

PImage[] TowerSprites;
EnemySprite[] EnemySprites;
PImage[] ProjectileSprites;

Cell hoverCell = null;


Path Level;
int selectedTower = 0;
ArrayList<Tower> AllTowers = new ArrayList<Tower>();
ArrayList<Enemy> AllEnemies = new ArrayList<Enemy>();
ArrayList<Projectile> AllProjectiles = new ArrayList<Projectile>();

int baseLives = 25;
int scrap = 75;

int stage =-1;

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

void setup()
{
  font= createFont("terminator-real-nfi.otf", 32);
  textFont(font);
  frameRate(30);
  noSmooth();

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
    new EnemySprite("ene2"), 
  };

  TowerSprites = new PImage[] {
    loadImage("towers/t1.png"), 
    loadImage("towers/t2.png"), 
    loadImage("towers/t3.png"),
    loadImage("towers/t4.png"),
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

  caution = loadImage("caution.jpg");
  metal = loadImage("metal.png");
  ground = loadImage("ground.jpg");
  groundpath = loadImage("groundpath.jpg");
  pathMask = loadImage("Levels/map.png");
  groundpath.mask(pathMask);
}

void draw()
{
  if (stage==-1)
  {
    mainMenu();
  }
  if (stage==10)
  {
    background(0);
    image(t1, 0, 0, 1000, 800);
    textSize(60);
    text("You Won", 100, 680);
  }
  if (stage==20)
  {
    background(0);
    image(t1, 0, 0, 1000, 800);
    textSize(60);
    text("You Lost", 100, 680);
  } else if (stage==0) {

    background(255, 0, 0);
    image(ground, 0, 0, width, playWindowHeight);
    image(groundpath, 0, 0, width, playWindowHeight);
    image(metal, 0, 650);
    image(caution, 0, 650, width/2, 50);
    image(caution, 500, 650, width/2, 50);


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
  if (stage==-1)
  {
    if ((mouseX>575-150) && (mouseY>350-75) && (mouseX<575+150) && (mouseY<350+75)) 
    {
      stage = 0;
    }
  }

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
        if (selectedTower == 3 && scrap>=75)
        {
          hoverCell.buildOn(new SniperTower(hoverCell.x, hoverCell.y));
          scrap-=75;
          selectedTower=0;
        }
        if (selectedTower == 4 && scrap>=150)
        {
          hoverCell.buildOn(new RailTower(hoverCell.x, hoverCell.y));
          scrap-=150;
          selectedTower=0;
        }
      }
    }
  }

  if ((mouseX>100-50) && (mouseY>720-50) && (mouseX<100+50) && (mouseY<720+50)) 
  {
    selectedTower = 1;
  }
  if ((mouseX>200-50) && (mouseY>720-50) && (mouseX<200+50) && (mouseY<720+50)) 
  {
    selectedTower = 2;
  }
  if ((mouseX>300-50) && (mouseY>720-50) && (mouseX<300+50) && (mouseY<720+50)) 
  {
    selectedTower = 3;
  }
  if ((mouseX>400-50) && (mouseY>720-50) && (mouseX<400+50) && (mouseY<720+50)) 
  {
    selectedTower = 4;
  }
}

void setUnbuildable(Vector v)
{
  Grid[v.x][v.y].isPath = true;
}



void winloseCheck()
{
  if (baseLives<=0)
  {
    lose();
  }
}

void leak(Enemy e)
{
  AllEnemies.remove(e);

  baseLives--;
  println("Base damaged");
}

void death(Enemy e) {
  scrap+=10;
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


void finishWave() {
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
      if (AllEnemies.size() < 1) println(stage); 
      win();
    }
  } else {
    waveInfo = "Wave " + (onWave + 1) + " in:  " + round( (startWave - millis()) / 1000) + " sec";
  }
}



void levelInit() {
  ArrayList<Enemy> wave1 = new ArrayList<Enemy>();
  for (int i = 0; i < 5; i++) wave1.add(new Enemy(0, 5)); 
  ArrayList<Enemy> wave2 = new ArrayList<Enemy>();
  for (int i = 0; i < 10; i++) wave2.add(new Enemy(0, 5)); 
  ArrayList<Enemy> wave3 = new ArrayList<Enemy>();
  for (int i = 0; i < 3; i++) wave3.add(new Enemy(1, 30)); 
  ArrayList<Enemy> wave4 = new ArrayList<Enemy>();
  for (int i = 0; i < 20; i++) wave4.add(new Enemy(0, 5)); 
  ArrayList<Enemy> wave5 = new ArrayList<Enemy>();
  for (int i = 0; i < 10; i++) wave5.add(new Enemy(1, 30)); 
  ArrayList<Enemy> wave6 = new ArrayList<Enemy>();
  for (int i = 0; i < 0; i++) wave6.add(new Enemy(0, 5)); 

  allWaves = new ArrayList<Wave>();
  allWaves.add(new Wave(wave1, 1000)); 
  allWaves.add(new Wave(wave2, 500));
  allWaves.add(new Wave(wave3, 500));
  allWaves.add(new Wave(wave4, 500));
  allWaves.add(new Wave(wave5, 500));
  allWaves.add(new Wave(wave6, 5));

  currentWave = allWaves.get(0);
  startWave = waveDelay + millis();
}
