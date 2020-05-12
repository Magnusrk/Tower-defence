void mainMenu()
{
  t1 = loadImage("t.jpg");
background(0);
image(t1,0,0, 1000,800);
textSize(100);
text("Tower Defence", 100,680);

textSize(40);
rect(575,350, 150,75);
fill(0);
text("Start", 605, 400);
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
