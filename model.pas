planetRec = record
    Name: str16;
    production: Integer;      (* Ships per hour             *)
    ships: Real;              (* Ships                      *)
    owner,                    (* Player number              *)
    x, y: Integer;            (* Coordinates                *)
    ownerName: str16;         (* Redundant to avoid lookup  *)
    last: Real;               (* Last access timestamp      *)
  end;

  
  fleetRec = record
    warning: boolean;
    ships: Real;              (* Ships in fleet.            *)
    start,                    (* Depart timestamp           *)
    enter: Real;              (* Arrive timestamp           *)
    Source,                   (* Origin planet id           *)
    sx, sy,                   (* Current position           *)
    destination,              (* Target planet id           *)
    owner: Integer;           (* Owner id                   *)
    ownerName: str16;         (* Redundant to avoid lookup  *)
  end;


function traveltime(x0, y0, x1, y1: Integer): Real;
begin
  traveltime := round(sqrt(sqr(x0 - x1) + sqr(y0 - y1))) div 12 + 1;
end;


procedure AutoCreatePlanets;
var
  planet: planetRec;
  n: Integer;

begin
  rewrite(planetfile);
  println('');
  println('Creating universe...');
  println('');
  for n := 1 to 999 do
  begin
    WriteLn(n);
    planet.x := random(1000);
    planet.y := random(1000);
    planet.production := random(5);
    planet.ships := random(1500);
    planet.owner := 0;
    planet.last := Newdate;
    if n = 1 then
    begin
      planet.Name := 'MAIN PLANET';
      planet.ownername := 'COMPUTER';
      planet.owner := 1;
      planet.production := 10;
    end
    else
    begin
      planet.Name := 'NAMELESS';
      planet.ownername := 'INDEPENDENT';
    end;
    savePlanet(n, planet);
  end;
end;
