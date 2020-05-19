void mainMenu()
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

void win()
{
  stage = 10;
}

void lose()
{
  stage = 20;
}

void exitGame()
{
  textSize(24);
  fill(255);
  rect(575, 350, 150, 75);
  fill(0);
  text("Exit", 583, 400);
  fill(255);
}
