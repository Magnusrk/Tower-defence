void UI()
{
  textSize(15);
  image(TowerSprites[0], 100, 720, cellSize*1.25, cellSize*1.25);
  text("25",119, 790);
  
  
  image(TowerSprites[1], 200, 720, cellSize*1.25, cellSize*1.25);
  text("50",219, 790);
  
  
  image(TowerSprites[2], 300, 720, cellSize*1.25, cellSize*1.25);
  text("75",319, 790);
  
  image(TowerSprites[3], 400, 720, cellSize*1.25, cellSize*1.25);
  text("150",419, 790);
  
  text("Scrap: "+scrap,700, 740);
  text(waveInfo, 700, 780);
  text("Life: "+baseLives, 850, 740);
  
  textSize(11);
  text("Cost :",20, 785);
  text("Type :",20, 716);
  text("Rocket",90, 716);
  text("Machine Gun",175, 716);
  text("Sniper",305, 716);
  text("Railgun",395, 716);
}
