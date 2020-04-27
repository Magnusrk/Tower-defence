void UI()
{
  image(TowerSprites[0], 100, 700, cellSize, cellSize);
  text("25",116, 760);
  image(TowerSprites[1], 200, 700, cellSize, cellSize);
  text("50",218, 760);
  text("Scrap: "+scrap,500, 760);
  text(waveInfo, 500, 780);
  text("Life: "+baseLives, 600, 760);
}
