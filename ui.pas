procedure renderStarChart;
var
  i: Integer;
  planet: PlanetRec;
begin
  for i := 1 to PlanetCount do
  begin
    planet := Planets[i];
    CursorPosition(planet.y, planet.x * 2);
    write(i);
  end;

end;