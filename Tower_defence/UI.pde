void UI()
{
  textSize(15);
  image(TowerSprites[0], 100, 720, cellSize*1.25, cellSize*1.25);
  text("25",119, 790);
  image(TowerSprites[1], 200, 720, cellSize*1.25, cellSize*1.25);
  text("50",219, 790);
  image(TowerSprites[2], 300, 720, cellSize*1.25, cellSize*1.25);
  text("75",319, 790);
  
  text("Scrap: "+scrap,700, 740);
  text(waveInfo, 700, 780);
  text("Life: "+baseLives, 850, 740);
}
