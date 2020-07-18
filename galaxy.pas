var
  Local: boolean;
  mono: boolean;
  Color: byte;
  cx, cy, Lines: integer;

procedure print(s: Str255);
begin
  if s <> '' then
  begin
    Write(s);
    cx := cx + length(s);
  end;
end;

procedure println(s: Str255);
begin
  print(s);
  print(#13#10);
  cx := 1;
  Inc(cy, 1);
end;

procedure SetColor(i, j: integer);
var
  fg, bg: integer;
  bold: char;
  blink: Str255;
const
  table: Str255 = '04261537';
begin
  if mono then
    i := j;

  if i <> color then
  begin
    color := i;
    fg := i mod 16;
    if fg > 7 then
      bold := '1'
    else
      bold := '0';
    fg := fg mod 8;
    if i > 127 then
      blink := ';5'
    else
      blink := '';

    if local then
      textcolor(color)
    else
      Write(#27'[' + bold + ';3' + table[1 + fg] + blink + 'm');
  end;
end;

type
  str16 = string[16];

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

  PlayerRec = record
    Name: str16;
    last: Real;               (* Last access timestamp      *)
  end;

var
  playerFile: file of playerRec;
  planetFile: file of planetRec;
  fleetFile: file of fleetRec;
  player: playerRec;
  id: Integer;
  date, newdate: Real;
  mark: Str255;
  timer, dt: Integer;
  msg: Text;


procedure savePlayer(n: Integer; var r: playerrec);
begin
  seek(playerfile, n - 1);
  Write(playerfile, r);
end;

procedure savePlanet(n: Integer; var r: planetrec);
begin
  seek(planetfile, n - 1);
  Write(planetfile, r);
end;

function traveltime(x0, y0, x1, y1: Integer): Real;
begin
  traveltime := round(sqrt(sqr(x0 - x1) + sqr(y0 - y1))) div 12 + 1;
end;

procedure leave;
begin
  if id <> 0 then
  begin
    player.last := date;
    savePlayer(id, player);
  end;
  Close(playerFile);
  Close(planetFile);
  Close(fleetFile);

  {$i-}
  RmDir('mutex.emp');
  {$i+}

  halt;
end;

function ptos(x, y: Integer): Str255;
var
  sx, sy: Str255;
begin
  str(x mod 100: 2, sx);
  str(y mod 100: 2, sy);

  ptos := chr(x div 100 + 65) + chr(y div 100 + 48) + ' ' + sx + '/' + sy;
end;

function planetToS(n: Integer; p: planetRec): Str255;
var
  s: Str255;
begin
  str(n: 3, s);
  planetToS := '#' + s + ' ' + AlignStr(p.Name, 16) + ' ' + ptos(p.x, p.y);
end;

procedure testleave;
var
  tmp: Integer;
begin
  tmp := Ticks - timer;
  if (tmp < 0) then
    tmp := 3600 + tmp;
  dt := 3600 - tmp;
  if dt < 0 then
    leave;
end;

procedure SetCursor(x, y: integer);
begin
  if local then
  begin
    gotoXY(x, y);
  end
  else
  begin
    Write(#27 + '[' + int2str(y, 0) + ';' + int2str(x, 0) + 'H');
  end;

  cx := x;
  cy := y;
end;

procedure ClearRegion(x1, y1, x2, y2: integer);
var
  y: integer;
begin

  x2 := x2 - x1 + 1;
  for y := y1 to y2 do
  begin
    if local then
    begin
      gotoxy(x1, y);
      Write(copy(
        '                                                                                  ',
        1, x2));
    end
    else
    begin
      SetCursor(x1, y);
      Write(copy(
        '                                                                                  ',
        1, x2));
    end;

    cx := 999;
  end;
end;

procedure ClearScreen;
var
  c: integer;
begin
  cx := 999;
  cy := 999;
  if local then
    clrscr;
  c := color;
  color := magenta;
  Write(#27'[2J');
  setcolor(c, c);
  testleave;
  SetCursor(1, 1);
end;

function InKey: Char;
begin
  repeat
    TestLeave;
  until KeyPressed;

  InKey := ReadKey;
end;

function WaitKey: char;
begin
  while KeyPressed do
    WaitKey := InKey;

  PrintLn('');
  Print(' - Key - ');
  WaitKey := InKey;
end;

function instr(var s: Str255; ml: integer): boolean;
var
  c: char;
begin
  s := '';
  repeat
    c := InKey;
    if (c >= ' ') and (c < #255) and (length(s) < abs(ml)) and
      ((c in ['0'..'9']) or (ml > 0)) then
    begin
      s := s + c;
      print(c);
    end
    else if (c = #8) and (length(s) >= 1) then
    begin
      s := copy(s, 1, length(s) - 1);
      print(#27'[1D; '#27'[1D;');
    end
    else if c <> #13 then
      print(#7);
  until (c = #13) or (c = #27);

  instr := c = #13;
end;

function dtos(R: Real): Str255;
var
  D, H: Integer;
begin
  D := Trunc(R / 24);
  H := Trunc(R - 24 * D);

  dtos := 'Stardate ' + Int2Str(D, 0) + '.' + Int2Str(H, 0);

(*
  d := d + 16;

  dtos := itos(d div 24 mod 32) + '.' + itos(d div (24 * 32) mod 12) + '. ' +
    itos(d mod 24) + ':00';
*)
end;

function input(s: Str255): Integer;
var
  i: Integer;
  err: integer;
begin
  print(s);
  if not instr(s, -9) then
  begin
    input := -1;
    exit;
  end;

  if s = '' then
  begin
    print('0');
    input := 0;
    exit;
  end;

  val(s, i, err);
  input := i;
end;

procedure error(s: Str255);
var
  c: char;
begin
  SetCursor(3, Lines - 1);
  setcolor(red + 8 + 128, 15 + 128);

  print(s + #7);

  while keypressed do
    c := InKey;

  c := InKey;
end;

procedure loadPlanet(n: Integer; var r: planetrec);
begin
  seek(planetfile, n - 1);
  Read(planetfile, r);
end;

function Planets: Integer;
begin
  planets := filesize(planetfile);
end;

procedure loadPlayer(n: Integer; var r: playerrec);
begin
  seek(playerfile, n - 1);
  Read(playerfile, r);
end;

function Players: Integer;
begin
  players := filesize(playerfile);
end;

procedure loadfleet(n: Integer; var r: fleetrec);
begin
  seek(fleetfile, n - 1);
  Read(fleetfile, r);
end;

procedure savefleet(n: Integer; var r: fleetrec);
begin
  seek(fleetfile, n - 1);
  Write(fleetfile, r);
end;

function fleets: Integer;
begin
  fleets := filesize(fleetfile);
end;

function PlayerID(s: str16): Integer;
var
  p: playerRec;
  n: Integer;
begin
  s := ToUpper(s);
  for n := 1 to players do
  begin
    ;
    loadplayer(n, p);
    if p.Name = s then
    begin
      PlayerID := n;
      exit;
    end;
  end;
  PlayerID := 0;
end;

function FreePlayer: Integer;
var
  n: Integer;
  p: playerrec;
begin
  for n := 1 to players do
  begin
    loadPlayer(n, p);
    if p.Name = '' then
    begin
      FreePlayer := n;
      exit;
    end;
  end;
  FreePlayer := players + 1;
end;

function FreeFleet: Integer;
var
  n: Integer;
  p: FleetRec;
begin
  for n := 1 to fleets do
  begin
    loadFleet(n, p);
    if p.ships = 0 then
    begin
      FreeFleet := n;
      exit;
    end;
  end;
  FreeFleet := fleets + 1;
end;

var
  dest: Integer;

var
  msgout: File of Char;

procedure writeMsg(s: Str255);
var
  N: Integer;
  C: Char;   
begin
  if dest > 1 then
  begin
    for N := 1 to Length(S) do
    begin
      C := S[N];
      Write(msgout, S[N]);
    end;  
    C := Char(13);
    Write(msgout, C);
    C := Char(10);
    Write(msgout, C);
  end;
end;

procedure openMsg(d: Integer; s: Str255);
begin
  dest := d;

  if d > 1 then
  begin
    Assign(msgout, 'msg' + Int2Str(d, 0) + '.emp');
    {$i-}
    reset(msgout);
    if ioresult <> 0 then
      rewrite(msgout)
    else
      seek(msgout, filesize(msgout));
    {$i+}

    writeMsg('');
    writeMsg('');
    writeMsg('Date:   ' +  dtos(date));
    writeMsg('Source: ' + s);
    writeMsg('');
  end;
end;

procedure closeMsg;
begin
  if dest > 1 then
    Close(msgout);
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

procedure AutoCreatePlayers;
var
  player: playerRec;

begin
  rewrite(playerfile);
  println('');
  println('Autocreating Players...');
  println('');
  player.Name := 'COMPUTER';
  player.last := Newdate;
  savePlayer(1, player);
end;

procedure workPlanet(n: Integer);
var
  dt: Real;
  p: planetrec;
begin
  loadPlanet(n, p);
  dt := Int(date - p.last);
  if dt <> 0 then
  begin
    if p.owner > 0 then
      p.ships := p.ships + p.production * dT;
    p.last := date;
    savePlanet(n, p);
  end;
end;

procedure planetwork;
var
  n: Integer;
begin
  for n := 1 to planets do
    workPlanet(n);
end;

procedure fleetWork;
var
  p: planetrec;
  f, f2: fleetrec;
  oriP, oriF: Real;
  Next, saveDate: Real;
  n, i, fl: Integer;
begin
  fl := fleets;

  while date <= newdate do
  begin
    Next := newdate + 1;
    println('');
    print('Calculations... ' + dtos(date) + ':');
    for n := 1 to fl do
    begin
      loadFleet(n, f);

      if (f.ships <> 0) and (f.enter - 24 < date) and not f.warning then
      begin
        loadPlanet(f.destination, p);
        if (p.owner <> 0) and (f.owner <> p.owner) then
        begin
          OpenMsg(p.owner, planetToS(f.destination, p));
          writeMSG('ATTENTION: Approaching hostile fleet detected.');
          closeMSG;
        end;
        f.warning := True;
        savefleet(n, f);
        print(' W:' + int2str(n, 0));
      end;


      if (f.ships <> 0) and (f.enter <= date) then
      begin
        Workplanet(f.destination);
        loadPlanet(f.destination, p);

        print(' A:' + int2str(n, 0));

        if f.ships < 0 then
        begin
            {
            Todesstern!!!!
            }

          for i := 1 to fleets do
          begin
            loadfleet(i, f2);
            if f2.destination = f.destination then
            begin
              f2.ships := 0;
              savefleet(i, f2);
            end;
          end;

          OpenMsg(p.owner, planetToS(f.destination, p));
          writeMSG('FINAL MESSAGE - Planet and all based and approaching');
          writeMSG('troops were destroyed by a death star');
          writeMSG('by commander ' + f.ownername + '.');
          closeMsg;

          OpenMsg(f.owner, planetToS(f.destination, p));
          writeMSG('Planet and all based and approaching troops');
          writeMSG('destoryed successfully.');
          closeMsg;

          p.x := random(1000);
          p.y := random(1000);
          p.production := random(6);
          p.ships := random(1500);
          p.owner := 0;
          p.last := date;
          p.Name := 'NAMELESS';
          p.ownername := 'INDEPENDENT';

        end
        else if p.owner = f.owner then
        begin
          p.ships := p.ships + f.ships;
          OpenMsg(p.owner, planetToS(f.destination, p));
          writeMSG('Troops increased by ' + Real2Str(f.ships, 0) + ' to ' + Real2Str(p.ships, 0) +
            ' ships.');
          closeMSG;
        end
        else
        begin
          oriF := f.ships;
          oriP := p.ships;
          while (p.ships > 0) and (f.ships > 0) do
          begin
            f.ships := f.ships - Round(p.ships / (5 + random(4))) - 1;
            if f.ships > 0 then
              p.ships := p.ships - Round(f.ships / (6 + random(5))) - 1;
          end;

          if f.ships < 0 then
            f.ships := 0;
          if p.ships < 0 then
            p.ships := 0;

          if f.ships > 0 then
          begin
            OpenMsg(p.owner, planetToS(f.destination, p));
            writeMSG('FINAL MESSAGE - All troops destroyed by ' +
              Real2Str(oriF, 0) + ' enemy ships.');
            writeMSG('Planet now conrolled by ' + f.ownername + '.');
            writeMSG('Own losses    ' + Real2Str(oriP, 0) + ' ships.');
            writeMSG('Enemy losses: ' + Real2Str(oriF - f.ships, 0) + ' ships.');
            closeMsg;

            OpenMsg(f.owner, planetToS(f.destination, p));
            writeMSG('Planet conquered with ' + Real2Str(orif, 0) + ' ships.');
            writeMSG('Own losses:   ' + Real2Str(oriF - f.ships, 0) + ' ships.');
            writeMSG('Enemy losses: ' + Real2Str(oriP, 0) + ' ships.');
            closeMsg;

            p.ships := f.ships;
            p.owner := f.owner;
            p.ownername := f.ownername;
          end
          else
          begin
            OpenMsg(p.owner, planetToS(f.destination, p));
            writeMSG('Attack by ' + Real2Str(oriF, 0) + ' ships of commander ' + f.ownername);
            writeMSG('successfully defeated.');
            writeMSG(Real2Str(p.ships, 0) + ' ships survived the battle.');
            writeMSG('Own losses: ' + Real2Str(p.ships - oriP, 0) + ' ships.');
            closeMsg;

            OpenMsg(f.owner, planetToS(f.destination, p));
            writeMSG(
              'FINAL MESSAGE - Attack formation failed to conquer target planet.');
            writeMSG('All ' + Real2Str(oriF, 0) + ' ships were destroyed.');
            closeMsg;
          end;
        end;

        saveplanet(f.destination, p);
        f.ships := 0;
        savefleet(n, f);
      end;
      if (f.ships <> 0) and (f.enter > date) and (f.enter < Next) then
        Next := f.enter;
    end;
    date := Next;
  end;
  date := newdate;
end;

function sendFleet(s: Integer; todesstern: boolean): boolean;
var
  (* delta, costs, *) time: Real;
  p1, p2: planetRec;
  f: fleetRec;
  n: Real;
  s2, d: Integer;
begin
  sendfleet := False;

  f.ownername := player.Name;
  f.owner := id;
  f.warning := False;

  if todesstern then
    s2 := input(' - send death star from planet #')
  else
    s2 := input(' - send fleet from planet #');
  if s2 = 0 then
  begin
    print(#8 + int2str(s, 0));
    loadplanet(s, p1);
  end
  else
  begin
    s := s2;
    if (s < 0) or (s > planets) then
    begin
      error('Planet does not exist!');
      exit;
    end;
    loadPlanet(s, p1);
    if p1.owner <> id then
    begin
      error('Planet not under your control!');
      exit;
    end;
  end;

  if todesstern and (p1.ships < 2000) then
  begin
    error('2000 ships required for death star transformation!');
    exit;
  end;


  d := input(' to planet #');

  SetCursor(3, Lines - 2);

  if (d < 1) or (d > planets) then
  begin
    error('Planet does not exist!');
    exit;
  end;

  loadplanet(d, p2);

  time := traveltime(p1.x, p1.y, p2.x, p2.y);

  println('The flight to ' + p2.Name + ' will take about ' + Real2str(time, 0) + ' hours.');
  SetCursor(3, Lines - 1);

  if todesstern then
  begin
    print('Confirm launch of the death star with "Y", abort otherwise? ');
    if upcase(InKey) <> 'Y' then
    begin
      error('Launch aborted!                                            ');
      exit;
    end;
    f.ships := -1;
    p1.ships := p1.ships - 2000;
  end
  else
  begin
    n := input('How many ships [0..' + Real2Str(p1.ships, 0) + ']? ');

    if n <= 0 then
    begin
      error('Invalid input!                                                  ');
      exit;
    end;

    if n > p1.ships then
      n := p1.ships;
    p1.ships := p1.ships - n;

    f.ships := n;
  end;

  saveplanet(s, p1);
  f.Source := s;
  f.sx := p1.x;
  f.sy := p1.y;
  f.destination := d;

  f.start := date;
  f.enter := date + time;

  savefleet(freefleet, f);

  sendfleet := True;
end;
