procedure renderStarChart;
var
  i: Integer;
  planet: PlanetRec;
begin
  for i := 1 to PlanetCount do
  begin
    planet := Planets[i];
    gotoXY(planet.x * 3, planet.y);
    write(i);
  end;

end;