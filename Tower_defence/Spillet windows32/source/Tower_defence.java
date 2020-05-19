import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Tower_defence extends PApplet {


SoundFile music;

int HEIGHT = 800;
int WIDTH = 1000;
float playWindowHeight = WIDTH *0.65f;
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
float scrap = 125;

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

public void setup()
{
  music = new SoundFile(this, "music.mp3");
  music.loop();

  font= createFont("terminator-real-nfi.otf", 32);
  textFont(font);
  frameRate(30);
  

  

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

public void draw()
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

public void mouseCheck()
{
  int x = (int)(mouseX/ cellSize);
  int y = (int)(mouseY/ cellSize);

  if (x<Grid.length && y<Grid[0].length)
  {
    hoverCell = Grid[x][y];
    hoverCell.outlineSelected();
  }
}

public void mousePressed()
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

public void setUnbuildable(Vector v)
{
  Grid[v.x][v.y].isPath = true;
}



public void winloseCheck()
{
  if (baseLives<=0)
  {
    lose();
  }
}

public void leak(Enemy e)
{
  AllEnemies.remove(e);

  baseLives--;
}

public void death(Enemy e) {
  scrap+=2.5f;
  AllEnemies.remove(e);
  e.alive = false;
  removeTarget(e);
}

public void removeTarget(Enemy e) {
  for (int i = 0; i < AllTowers.size(); i++) if (AllTowers.get(i).target == e) AllTowers.get(i).target = null;
}

public int getDistance(Tower t, Enemy e) { // returns the manhattan distance in pixels


  float man = 0;
  float x = abs(((t.cellX * cellSize) + cellSize/2) - e.posX);
  float y = abs(((t.cellY * cellSize) + cellSize/2) - e.posY);
  man = x + y;
  return round(man);
}

public void spawn(Enemy e) {
  AllEnemies.add(e);
}


public void finishWave() {
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


public void startWave() {
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



public void levelInit() {
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
class Cell {
  int x;
  int y;

  boolean isPath = false;

  Tower occupant = null;

  public void buildOn(Tower t)
  {
    if (buildable())
    {
      occupant = t;
      AllTowers.add(occupant);
    }
  }

  public boolean buildable()
  {
    if (occupant == null && !isPath)
    {
      return true;
    } else
    {
      return false;
    }
  }

  public void outlineSelected()
  {
    noFill();
    if (buildable())
    {
      stroke(0, 255, 0);
      tint(255, 126);
      if(selectedTower==1)
      {
      image(TowerSprites[0], x * cellSize, y * cellSize, cellSize, cellSize);
      }
      if(selectedTower==2)
      {
      image(TowerSprites[1], x * cellSize, y * cellSize, cellSize, cellSize);
      }
      if(selectedTower==3)
      {
      image(TowerSprites[2], x * cellSize, y * cellSize, cellSize, cellSize);
      }
      if(selectedTower==4)
      {
      image(TowerSprites[3], x * cellSize, y * cellSize, cellSize, cellSize);
      }
      noTint();
    } else
    {
      stroke(255, 0, 0);
    }
    rect(x * cellSize, y* cellSize, cellSize, cellSize);
  }


  Cell (int _x, int _y)
  {
    x=_x;
    y=_y;
  }
}
class EnemySprite{
  PImage[] up = new PImage[2];
  PImage[] down = new PImage[2];
  PImage[] left = new PImage[2];
  PImage[] right = new PImage[2];
  
  public PImage getImage(Direction dir, int anim)
  {
    if(dir == Direction.up)
    {
      return up[anim];
    } else if(dir == Direction.down)
    {
      return down[anim];
    } else if(dir == Direction.left)
    {
      return left[anim];   
    } else
    {
      return right[anim];
    }
  }
  
  EnemySprite(String name)
  {
    String path = "enemies/" + name + "/" + name + "_";
    up[0] = loadImage (path + "u0.png");
    up[1] = loadImage (path + "u1.png");
    down[0] = loadImage (path + "d0.png");
    down[1] = loadImage (path + "d1.png");
    left[0] = loadImage (path + "l0.png");
    left[1] = loadImage (path + "l1.png");
    right[0] = loadImage (path + "r0.png");
    right[1] = loadImage (path + "r1.png");
    
  }
}

class Enemy{
  int posX;
  int posY;
  int onLane = 0;
  Direction dir;
  
  int speed = 5;
  int hitPoints = 100;
  
  int spriteIndex;
  int anim = 0;
  
  int animTimer = 0;
  int animDelay = 3;
  
  boolean alive = true;
  
  Enemy(int sprite, int hp){
    hitPoints = hp;
    spriteIndex = sprite;
    Vector p = Level.getSpawn();
    posX = p.x;
    posY = p.y;
    dir = Level.getDir(0);
    alive = true;
  }
  
    public void hit(int damage) {
    hitPoints -= damage;
    if (hitPoints < 0) death(this);
  }
  
  public void move()
  {
    PathStatus status = Level.checkPos(new Vector(posX, posY), onLane);
    if(status == PathStatus.finished)
    {
      leak(this);
      return;
    } else if(status == PathStatus.next)
    {
      onLane ++;
      dir = Level.getDir(onLane);
    }
    
    if(dir == Direction.up) posY -= speed;
    else if(dir == Direction.down) posY += speed;
    else if(dir == Direction.left) posX -= speed;
    else posX += speed;
    
    image(EnemySprites[spriteIndex].getImage(dir, anim), posX, posY, cellSize, cellSize);
    
    animTimer++;
    if(animTimer > animDelay)
    {
      animTimer = 0;
      if (anim == 0) anim = 1;
      else anim = 0;
    }
  }
}
class Path {

  Vector[] Pathway;
  Lane[] allLanes;
  Vector spawnPos;
  
  public Vector getSpawn()
  {
    return spawnPos;
  }
  
  public Direction getDir(int i)
  {
    if(i < allLanes.length)
    {
      return allLanes[i].dir;
    } else
    {
      return allLanes[allLanes.length - 1].dir;
    }
  }

  public PathStatus checkPos(Vector v, int lane)
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
    
    public boolean checkPos(Vector v) {
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
class Projectile {
  Tower owner;
  Enemy target;
  int sprite;

  int posX;
  int posY;
  float distance = 0;

  int damage = 0;


  public void move() {
    if (!target.alive) AllProjectiles.remove(this);
    distance += .07f;
    float x = lerp(owner.cellX * cellSize + cellSize/2, target.posX + cellSize/2, distance);
    float y = lerp(owner.cellY * cellSize + cellSize/2, target.posY + cellSize/2, distance);
    posX = round(x);
    posY = round(y); 

    image(ProjectileSprites[sprite], posX, posY, cellSize/2, cellSize/2);
    if (distance >= 1) hit();
  }

  public void aamove() {
    distance -= 2;
    float tX = target.posX + cellSize/2;
    float tY = target.posY + cellSize/2;
    float dx = tX - posX;
    float dy = tY - posY;
    float angle1 = atan2(dy, dx);  
    posX = round(tX - (cos(angle1) * distance));
    posY = round(tY - (sin(angle1) * distance));

    image(ProjectileSprites[sprite], posX, posY, cellSize/2, cellSize/2);
    if (distance < 0) hit();
  }


  public void hit() {
    target.hit(damage);
    AllProjectiles.remove(this);
  }

  Projectile(Tower o, Enemy t, int sprite, int dmg) {
    owner = o;
    target = t;
    posX = (int) round((owner.cellX * cellSize) + cellSize/2);
    posY = (int) round((owner.cellY * cellSize) + cellSize/2);
    distance = 0;
    damage = dmg;
  }
}
public void mainMenu()
{
  t1 = loadImage("t.jpg");
  background(0);
  image(t1, 0, 0, 1000, 800);
  textSize(60);
  text("Tower Defence", 100, 680);

  textSize(24);
  rect(575, 250, 200, 75);
  fill(0);
  text("Start", 583, 300);
  fill(255);
  
  rect(575, 350, 200, 75);
  fill(0);
  text("Tutorial", 583, 400);
  fill(255);
  
  
  rect(575, 450, 200, 75);
  fill(0);
  text("Exit", 583, 500);
  fill(255);

  textSize(15);
}

public void win()
{
  stage = 10;
}

public void lose()
{
  stage = 20;
}

public void exitGame()
{
  textSize(24);
  fill(255);
  rect(575, 350, 150, 75);
  fill(0);
  text("Exit", 583, 400);
  fill(255);
}
class Tower
{
  TowerTypes type = null;
  int cellX;
  int cellY;

  int spriteIndex;
  int cost = 0;
  int range = 200;
  int reloadTime = 1000;
  int lastAttack = 0;
  Enemy target = null;
  ArrayList<Enemy> attackThisRound;

  int projectileSprite = 0;

  int damage = 0;
  

  Tower(int x, int y, int sprite)
  {
    spriteIndex = sprite;
    cellX = x;
    cellY = y;
  }

  public void drawTower()
  {
    image(TowerSprites[spriteIndex], cellX * cellSize, cellY * cellSize, cellSize, cellSize);
  }

  public void action() {
    if (millis() < lastAttack + reloadTime) return; //still on cooldown

    if (target != null) { //check our current target
      if (getDistance(this, target) < range) { //attack them if we can
        attack(target);
        return;
      }
    }

    for (int i = 0; i < AllEnemies.size(); i++) { //attack the next enemy
      if (getDistance(this, AllEnemies.get(i)) < range) {
        attack(AllEnemies.get(i));
        i = AllEnemies.size();
      }
    }
  }

  public void attack(Enemy e) {
    target = e;
    lastAttack = millis();    
    AllProjectiles.add(new Projectile(this, e, projectileSprite, (int)random(damage, damage)));
  }
  Tower() {
  }
}

class RocketTower extends Tower {
  // 6 skud til at dræbe 1
    public void init() {
    type = TowerTypes.rocketTower;
    spriteIndex = 0;
    projectileSprite = 0;
    range = 200;
    reloadTime = 1000;
    cost = 25;
    damage = 2;
  }  

  RocketTower(int x, int y) {
    cellX = x;
    cellY = y;
    init();
  }

  RocketTower() {
    init();
  }
}

class GunTower extends Tower {
  // 11 skud til at dræbe 1
    public void init() {
    type = TowerTypes.gunTower;
    spriteIndex = 1;
    projectileSprite = 1;
    range = 400;
    reloadTime = 300;
    cost = 50;
    damage = 1;
  }  

  GunTower(int x, int y) {
    cellX = x;
    cellY = y;
    init();
  }

  GunTower() {
    init();
  }
}

class SniperTower extends Tower {
  // 1 skud til at dræbe 1
    public void init() {
    type = TowerTypes.sniperTower;
    spriteIndex = 2;
    projectileSprite = 1;
    range = 750;
    reloadTime = 3000;
    cost = 75;
    damage = 10;
  }  

  SniperTower(int x, int y) {
    cellX = x;
    cellY = y;
    init();
  }

  SniperTower() {
    init();
  }
}

class RailTower extends Tower {
  // 1 skud til at dræbe 1
    public void init() {
    type = TowerTypes.railTower;
    spriteIndex = 3;
    projectileSprite = 2;
    range = 750;
    reloadTime = 1000;
    cost = 200;
    damage = 10;
  }  

  RailTower(int x, int y) {
    cellX = x;
    cellY = y;
    init();
  }

  RailTower() {
    init();
  }
}
public void UI()
{
  textSize(15);
  image(TowerSprites[0], 100, 720, cellSize*1.25f, cellSize*1.25f);
  text("25",119, 790);
  
  
  image(TowerSprites[1], 200, 720, cellSize*1.25f, cellSize*1.25f);
  text("50",219, 790);
  
  
  image(TowerSprites[2], 300, 720, cellSize*1.25f, cellSize*1.25f);
  text("75",319, 790);
  
  image(TowerSprites[3], 400, 720, cellSize*1.25f, cellSize*1.25f);
  text("200",410, 790);
  
  text("Scrap: "+scrap,700, 740);
  text(waveInfo, 700, 780);
  text("Life: "+baseLives, 885, 740);
  
  textSize(11);
  text("Cost :",20, 785);
  text("Type :",20, 716);
  text("Rocket",90, 716);
  text("Machine Gun",175, 716);
  text("Sniper",305, 716);
  text("Railgun",395, 716);
}
class Vector
{
  int x;
  int y;

  Vector(int _x, int _y)
  {
    x = _x;
    y = _y;
  }
}
class Wave {
  ArrayList<Enemy> enemies;
  int spawnTimer;
  
  int nextSpawn = 0;
  
  public void man() {
    if(millis() >= nextSpawn) {
      nextSpawn = millis() + spawnTimer;
      waveSpawn();
    }
  }
  
  public void waveSpawn() {
    if(enemies.size() < 1 ) finishWave();
    else {
      Enemy e = enemies.get(0);
      enemies.remove(0);
      spawn(e);
    }
  }

  Wave(ArrayList<Enemy> e, int s) {
    enemies = e;
    spawnTimer = s;
  }
}
  public void settings() {  size(1000, 800);  noSmooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Tower_defence" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
