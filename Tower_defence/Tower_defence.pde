import processing.sound.*;
SoundFile music;

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
  music = new SoundFile(this, "music.mp3");
  music.loop();

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
  if (stage==-10)
  {
    background(100);
    textSize(17);
    text("Goal of the game:", 20, 50);
    text("Kill all the human soldiers before they reach your base.", 20, 100);

    text("Use the four tower types to shoot the humans.", 20, 150);

    image(TowerSprites[0], 50, 200, cellSize*2, cellSize*2);

    image(TowerSprites[1], 300, 200, cellSize*2, cellSize*2);

    image(TowerSprites[2], 550, 200, cellSize*2, cellSize*2);

    image(TowerSprites[3], 800, 200, cellSize*2, cellSize*2);

    textSize(11);
    text("Rocket tower:", 20, 320);
    text("Does moderate damage", 10, 370);
    text("and moderate", 10, 400);
    text("reload speed.", 10, 425);
    text("Low range.", 10, 450);

    text("Machine gun:", 275, 320);
    text("Does little damage,", 275, 370);
    text("but fast", 275, 400);
    text("reload speed.", 275, 425);
    text("Medium range.", 275, 450);

    text("Sniper tower:", 500, 320);
    text("Does lots of damage", 500, 370);
    text("but slow", 500, 400);
    text("reload speed.", 500, 425);
    text("High range.", 500, 450);

    text("Railgun:", 740, 320);
    text("Does lots of damage and", 740, 370);
    text("moderate reload speed,", 740, 400);
    text("but high cost", 740, 425);
    text("High range", 740, 450);

    textSize(15);
    rect(20, 600, 100, 75);
    fill(0);
    text("Back", 35, 645);
    fill(255);
  }

  if (stage==10)
  {
    background(0);
    image(t1, 0, 0, 1000, 800);
    textSize(60);
    text("You Won", 100, 680);
    exitGame();
  }
  if (stage==20)
  {
    background(0);
    image(t1, 0, 0, 1000, 800);
    textSize(60);
    text("You Lost", 100, 680);
    exitGame();
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
    if ((mouseX>575) && (mouseY>250) && (mouseX<575+200) && (mouseY<250+75)) 
    {
      stage = 0;
    }
    if ((mouseX>575) && (mouseY>350) && (mouseX<575+200) && (mouseY<350+75)) 
    {
      stage = -10;
    }
    if ((mouseX>575) && (mouseY>450) && (mouseX<575+200) && (mouseY<450+75)) 
    {
      exit();
    }
  }
  if (stage==10 || stage==20)
  {
    if ((mouseX>575) && (mouseY>350) && (mouseX<575+150) && (mouseY<350+75)) 
    {
      exit();
    }
  }

  if (stage == -10)
  {
    if ((mouseX>20) && (mouseY>600) && (mouseX<20+100) && (mouseY<600+75)) 
    {
      stage=-1;
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
          scrap-=200;
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
}

void death(Enemy e) {
  scrap+=5;
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
  for (int i = 0; i < 10; i++) wave2.add(new Enemy(0, 7)); 

  ArrayList<Enemy> wave3 = new ArrayList<Enemy>();
  for (int i = 0; i < 3; i++) wave3.add(new Enemy(1, 15)); 

  ArrayList<Enemy> wave4 = new ArrayList<Enemy>();
  for (int i = 0; i < 15; i++) wave4.add(new Enemy(0, 10)); 

  ArrayList<Enemy> wave5 = new ArrayList<Enemy>();
  for (int i = 0; i < 10; i++) wave5.add(new Enemy(1, 17)); 
  for (int i = 0; i < 5; i++) wave5.add(new Enemy(0, 10)); 

  ArrayList<Enemy> wave6 = new ArrayList<Enemy>();
  for (int i = 0; i < 20; i++) wave6.add(new Enemy(0, 13)); 

  ArrayList<Enemy> wave7 = new ArrayList<Enemy>();
  for (int i = 0; i < 10; i++) wave7.add(new Enemy(0, 10)); 

  ArrayList<Enemy> wave8 = new ArrayList<Enemy>();
  for (int i = 0; i < 15; i++) wave8.add(new Enemy(1, 20));
  for (int i = 0; i < 5; i++) wave8.add(new Enemy(0, 10)); 

  ArrayList<Enemy> wave9 = new ArrayList<Enemy>();
  for (int i = 0; i < 50; i++) wave9.add(new Enemy(0, 5)); 

  ArrayList<Enemy> wave10 = new ArrayList<Enemy>();
  for (int i = 0; i < 25; i++) wave10.add(new Enemy(1, 10)); 
  for (int i = 0; i < 5; i++) wave10.add(new Enemy(0, 5)); 

  ArrayList<Enemy> wave11 = new ArrayList<Enemy>();
  for (int i = 0; i < 15; i++) wave11.add(new Enemy(0, 15)); 

  ArrayList<Enemy> wave12 = new ArrayList<Enemy>();
  for (int i = 0; i < 10; i++) wave12.add(new Enemy(0, 20)); 

  ArrayList<Enemy> wave13 = new ArrayList<Enemy>();
  for (int i = 0; i < 3; i++) wave13.add(new Enemy(1, 60));
  for (int i = 0; i < 5; i++) wave13.add(new Enemy(0, 30)); 

  ArrayList<Enemy> wave14 = new ArrayList<Enemy>();
  for (int i = 0; i < 20; i++) wave14.add(new Enemy(0, 30)); 

  ArrayList<Enemy> wave15 = new ArrayList<Enemy>();
  for (int i = 0; i < 1; i++) wave15.add(new Enemy(1, 1000)); 
  for (int i = 0; i < 15; i++) wave15.add(new Enemy(0, 50)); 


  ArrayList<Enemy> wave16 = new ArrayList<Enemy>();
  for (int i = 0; i < 0; i++) wave16.add(new Enemy(0, 5)); 

  allWaves = new ArrayList<Wave>();
  allWaves.add(new Wave(wave1, 1000)); 
  allWaves.add(new Wave(wave2, 500));
  allWaves.add(new Wave(wave3, 500));
  allWaves.add(new Wave(wave4, 500));
  allWaves.add(new Wave(wave5, 500));
  allWaves.add(new Wave(wave6, 1000)); 
  allWaves.add(new Wave(wave7, 500));
  allWaves.add(new Wave(wave8, 500));
  allWaves.add(new Wave(wave9, 500));
  allWaves.add(new Wave(wave10, 500));
  allWaves.add(new Wave(wave11, 1000)); 
  allWaves.add(new Wave(wave12, 500));
  allWaves.add(new Wave(wave13, 500));
  allWaves.add(new Wave(wave14, 500));
  allWaves.add(new Wave(wave15, 500));
  allWaves.add(new Wave(wave16, 5));

  currentWave = allWaves.get(0);
  startWave = waveDelay + millis();
}
