void mainMenu()
{
  t1 = loadImage("t.jpg");
  background(0);
  image(t1, 0, 0, 1000, 800);
  textSize(60);
  text("Tower Defence", 100, 680);

  textSize(24);
  rect(575, 350, 150, 75);
  fill(0);
  text("Start", 583, 400);
  fill(255);

  textSize(15);
}

void win()
{
  stage = 10;
  println("win");
}

void lose()
{
  stage = 20;
  println("lose");
}
