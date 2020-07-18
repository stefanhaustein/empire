function login: boolean;

var
  Name, password, number: Str255;
  error: integer;
  pn: Integer;
  p: planetrec;
  c: char;
begin
  ClearScreen;

  if not local then
  begin
    clrscr;
    println('Empire is being played by ' + ParamStr(1) + ' at ' + ParamStr(2) + ' baud');
    println('');
    println('Press ESC to abort...');
    println('');
  end;

  id := 0;
  println('     Galactic Empire');
  println('     ===============');
  println('');
  println('                           (C) 1990, 1992, 2020 Stefan Haustein');
  println('                                                Joerg Pleumann');

  println('');
  println('');
  println('Attention: Timeout is now 6 hours. Terminal needs VT100/ANSI support.');
  println('');
  println('');
  println('Login Date: ' + dtos(newdate));
  println('');
  Name := ToUpper(ParamStr(1));

  login := False;

  (* If this planet is owned by the computer, reduce troops to 10%.  *)
  (* Might be leftover from "revolutions" -- or a non working        *)
  (* attempt to avoid the computer homeworld becoming unconquerable? *)
  pn := 1 + Random(1000);

  loadplanet(pn, p);
  if p.owner = 1 then
  begin
    p.ships := Round(p.ships / 10);
    saveplanet(pn, p);
  end;
  (* ------------------------------------ *)

  if (Name <> '') then
  begin
    id := playerid(Name);
    if id = 0 then
    begin
      id := freePlayer;
      player.last := NewDate;
      player.Name := Name;
      pn := 1 + Random(1000);
      loadplanet(pn, p);
      p.ships := p.ships + random(2000) + 4000; (* some "startup capital" for the new player *)
      p.production := 5;
      if p.owner <> 0 then
      begin
        openMsg(p.owner, planetToS(pn, p));
        writeMsg('LATEST NEWS - Enemy rebels took control.');
        closeMsg;
      end;
      p.owner := id;
      p.ownername := Name;
      saveplanet(pn, p);
      saveplayer(id, player);

      openMsg(p.owner, planetToS(pn, p));
      writeMsg('Our rebels took control.');
      closeMsg;

      login := True;
      c := waitkey;
    end
    else
    begin
      loadplayer(id, player);

      if newdate - player.last < 6 then
      begin
        print('Access to galactic supercomputer rejected.' + #13#10);
        print('Please try again ' + Real2str(6 - newdate + player.last, 2) + ' hours' + #13#10);
        login := False;
        id := 0;
      end
      else
      begin
        login := True;
        println('Last login: ' + dtos(player.last));
        println('');
        println('');
        println('Awaiting your orders, commmander ' + player.Name + '.');
      end;
      c := waitkey;
    end;
  end;
end;

procedure fleetList(eigen: boolean);
var
  f: fleetrec;
  s, d: planetrec;
  x, y, n, h, c: integer;
  dt: Real;
begin
  c := 0;
  for n := 1 to fleets do
  begin
    loadfleet(n, f);
    dt := f.enter - date;
    if (f.ships <> 0) and ((not eigen and (dt < 24) and (f.owner <> id)) or
      (eigen and (f.owner = id))) then
    begin
      loadplanet(f.destination, d);
      if eigen or (d.owner = id) then
      begin
        if c mod (Lines - 9) = 0 then
        begin
          if c <> 0 then
            if waitkey = #27 then
              exit;
          ClearScreen;
          if eigen then
          begin
            println('     List of my fleets');
            println('     ===================================');
            println('');
            println(
              '  ID Position Origin Target                            ETA/h    Ships  ');
            println(
              '-----------------------------------------------------------------------');
          end
          else
          begin
            println('     List of enemy fleets');
            println('     =================================');
            println('');
            println(
              '  ID Position Target                            ETA/h    Ships   Commander');
            println(
              '------------------------------------------------------------------------------');
          end;
        end;
        Inc(c, 1);

        x := Round(f.sx - (f.sx - d.x) * (f.start - date) / (f.start - f.enter));
        y := Round(f.sy - (f.sy - d.y) * (f.start - date) / (f.start - f.enter));

        h := (c and 1) * 8;

        setcolor(cyan + h, 7);
        print(int2str(n, 4) + ' ' + ptos(x, y) + ' ');

        if eigen then
        begin
          print(Int2Str(f.Source, 5) + ' ');
          if d.owner = 0 then
            setcolor(green + h, 15)
          else if d.owner <> id then
            setcolor(red + h, 7);
        end;

        print(planetToS(f.destination, d));


        setcolor(cyan + h, h);
        print(' ' + Real2str(dt, 6));
        if eigen or (dt <= 8) then
          begin
            if f.ships >= 0 then
              print(Real2str(f.ships, 11))
            else
              print(' Death star');
          end
        else
          print('         ?');
        if not eigen and (dt <= 4) then
          print(' ' + f.ownername);
        println('');
      end;
    end;
  end;
  if c = 0 then
  begin
    ClearScreen;
    println('');
    println('');
    println('No fleets in travel');
  end;

  setcolor(cyan, 7);
end;

var
  c: char;

procedure displaymessages;
var
  m: Str255;
  c: Integer;
  k: char;

begin
  Assign(msg, 'msg' + Int2Str(id, 0) + '.emp');
{$i-}
  c := 0;
  reset(msg);
  if ioresult = 0 then
  begin
{$i+}
    while not EOF(msg) do
    begin
      readln(msg, m);
      if c mod (Lines - 7) = 0 then
      begin
        if (c <> 0) then
          k := waitkey;
        ClearScreen;
        println('     Messages / news');
        println('     ==========================');
        println('');
      end;
      println(m);
      Inc(c, 1);
    end;
    rewrite(msg);
  end;
  if c mod (Lines - 7) <> 0 then
    k := InKey;
end;

procedure SendText;
var
  s, t: Str255;
  n: Integer;
  b: boolean;
begin
  ClearScreen;
  print('Send message to: ');
  b := instr(s, 20);
  println('');
  n := PlayerID(s);
  if n = 0 then
  begin
    println('');
    println('Destination does not exist');
  end
  else
  begin
    println('');
    println('Message Text:');
    openMSG(n, player.Name);
    repeat
      b := instr(t, 79);
      println('');
      writeMSG(t);
    until t = '';
    closeMSG;
  end;
end;

procedure renamePlanet(n0: integer);
var
  n: integer;
  p: planetrec;
  s: Str255;
  b: boolean;
begin
  n := input(' - Rename planet; ID: ');
  if n = 0 then
  begin
    print(#8 + int2str(n0, 0));
    n := n0;
  end;

  SetCursor(3, Lines - 2);

  if (n <= 0) or (n > planets) then
  begin
    error('Invalid planet!');
    exit;
  end;

  loadplanet(n, p);
  if p.owner <> id then
  begin
    error('Not your planet!');
    exit;
  end;


  print('New name: ');
  b := instr(s, 16);
  if s <> '' then
  begin
    p.Name := s;
    p.Name := ToUpper(p.Name);
    saveplanet(n, p);
  end;
end;

procedure statistik(era: boolean);
var
  n, nn, paz, faz: Integer;
  p: planetrec;
  f: fleetrec;
  s: Str255;
  b: boolean;
  k: char;
  pfl, ffl, ppr: Real;
begin
  ClearScreen;
  println('     Statistical information');
  println('     ==========================');
  println('');
  println('');
  if era = False then
  begin
    print('                    Commander: ');
    b := instr(s, 20);
    println('');
    println('');
    n := playerId(s);
    if n = 0 then
    begin
      println(#7'Invalid commander!');
      exit;
    end;
  end
  else
    n := id;

  paz := 0;
  pfl := 0;
  ppr := 0;

  for nn := 1 to planets do
  begin
    loadplanet(nn, p);
    if p.owner = n then
    begin
      Inc(paz, 1);
      pfl := pfl + p.ships;
      ppr := ppr + p.production;
    end;
  end;

  println('         Planets under control: ' + Int2Str(paz, 0));
  println('                    Percentage: ' + Real2Str(paz * 100 / 1000, 0) + ' %');
  println('          Total resident ships: ' + Real2Str(pfl, 0));
  println('        Ships produced per day: ' + Real2Str(ppr * 24, 0));
  println('');

  faz := 0;
  ffl := 0;

  for nn := 1 to fleets do
  begin
    loadfleet(nn, f);
    if ((f.owner = n) and (f.ships <> 0)) then
    begin
      Inc(faz, 1);
      ffl := ffl + abs(f.ships);
    end;
  end;

  println('              Number of fleets: ' + Int2Str(faz, 0));
  println('               Ships in travel: ' + Real2Str(ffl, 0));
  println('');
  println('                   Total ships: ' + Real2Str(pfl + ffl, 0));
  println('');

  if era and (pfl + ffl = 0) then
  begin
    println('Sorry, you lost ... commander deleted!');
    Player.Name := '';
  end;

  k := waitkey;
end;

procedure mitspieler;
var
  n, c: Integer;
  p: playerrec;
begin
  c := 0;
  for n := 1 to players do
  begin
    loadplayer(n, p);
    if player.Name <> '' then
    begin
      if c mod (Lines - 7) = 0 then
      begin
        if c <> 0 then
          if waitkey = #27 then
            exit;
        ClearScreen;
        println('     Commanders');
        println('     ==========');
        println('');
      end;
      Inc(c, 1);
      println(chr(64 + c) + ': ' + AlignStr(p.Name, 16) + '           ' + copy(dtos(p.last), 1, 5));
    end;
  end;
end;

procedure planetlist;
var
  n, c: Integer;
  p: planetrec;
begin
  c := 0;
  for n := 1 to planets do
  begin
    loadplanet(n, p);
    if p.owner = id then
    begin
      if c mod (Lines - 9) = 0 then
      begin
        if c <> 0 then
          if waitkey = #27 then
            exit;
        ClearScreen;
        println('     Planets under control');
        println('     ======================');
        println('');
        println('     Name             Position              Ships   Production');
        println('--------------------------------------------------------------');
      end;
      Inc(c, 1);
      setcolor(cyan + 8 * (c and 1), 7 + 8 * (c and 1));
      println(planetToS(n, p) + '          ' + Real2Str(p.ships, 11) +
        Int2str(p.Production * 24, 11));
    end;
  end;
end;

procedure drawMap(x0, y0, x1, y1, cx, cy, r: integer);
const
  radius: array[1..7] of integer = (1, 2, 3, 5, 8, 12, 16);

var
  dx, dy: Integer;

  procedure mapWrite(x, y: Integer; s: Str255);
  begin
    x := x + x0 + dx;
    y := y + y0 + dy;

    if (y >= y0) and (y <= y1) and (x >= x0) and (x + length(s) <= x1) then
    begin
      SetCursor(x, y);
      print(s);
    end;
  end;

  function Visible(x, y: Integer): boolean;
  begin
    Visible := (x <= dx) and (x >= -dx) and (y <= dy) and (y >= -dy);
  end;

var
  nr: integer;
  l: Integer;
  x, y, xf, yf: Integer;
  p, d: planetRec;
  s: Str255;
  f: fleetrec;
  bright: integer;

begin

  xf := 2;
  if Lines > 25 then
    yf := 2
  else
    yf := 1;

  r := radius[r];

  ClearRegion(x0, y0, x1, y1);

  dx := ((x1 - x0)) div 2;
  dy := ((y1 - y0)) div 2;


  setcolor(7, 7);
  for nr := 0 to 10 do
    mapwrite(Round((100 * nr + 50 - cx) * xf / r), -dy, chr(nr + 65));

  for nr := 0 to 10 do
    mapwrite(-dx, Round((100 * nr + 50 - cy) * yf / r), chr(nr + 48));

  if r <= 4 then
  begin
    for nr := 1 to fleets do
    begin
      if keypressed then
        exit;


      loadfleet(nr, f);
      loadplanet(f.destination, d);

      x := Round(f.sx - (f.sx - d.x) * (f.start - date) / (f.start - f.enter));
      y := Round(f.sy - (f.sy - d.y) * (f.start - date) / (f.start - f.enter));
      x := Round((x - cx) * xf / r);
      y := Round((y - cy) * yf / r);

      if (f.ships <> 0) and (Visible(x, y)) then
      begin
        if f.owner = id then
        begin
          if (x = 0) and (y = 0) then
            setcolor(yellow, 15)
          else
            setcolor(cyan + 8, 7);
        end
        else if d.owner = id then
          setcolor(128 + red + 8, 128 + 15)
        else
          setcolor(red, 7);

        for l := Round(f.enter * 2) downto Round(date * 2) do
        begin
          x := Round(f.sx - (f.sx - d.x) * (f.start * 2 - l) / ((f.start - f.enter) * 2));
          y := Round(f.sy - (f.sy - d.y) * (f.start * 2 - l) / ((f.start - f.enter) * 2));
          x := Round((x - cx) * xf / r);
          y := Round((y - cy) * yf / r);

          if l <> date * 2 then
            mapWrite(x, y, '.')
          else
          begin
            if f.owner = id then
              MapWrite(x, y, '+' + int2str(nr, 0))
            else
              if f.ships < 0 then
                MapWrite(x, y, chr(96 + f.owner) + '!')
              else
                MapWrite(x, y, chr(96 + f.owner) + Real2str((f.ships + 50) / 100, 0) + '^');
          end;
        end;
      end;
    end;
  end;
  for nr := 1 to planets do
  begin
    if keypressed then
      exit;

    loadPlanet(nr, p);
    x := ((p.x - cx) * xf) div r;
    y := ((p.y - cy) * yf) div r;
    if Visible(x, y) then
    begin
      if p.production >= 3 then
        bright := 8
      else
        bright := 0;
      if p.owner = id then
      begin
        if (x = 0) and (y = 0) then
          setcolor(yellow, 15)
        else
          setcolor(cyan + bright, 15);
      end
      else if p.owner = 0 then
        setcolor(green + bright, 7)
      else
        setcolor(red + bright, 7);

      if (p.owner = 0) then
      begin
        s := '""****************';
        s := s[p.production + 1];
      end
      else
        s := chr(64 + p.owner);

      if r < 16 then
      begin
        s := s + int2str(nr, 0);

        if r < 8 then
          MapWrite(x + 1, y + 1, (Real2Str((p.ships + 50) / 100, 0) + '^'));
      end;

      MapWrite(x, y, s);
    end;
  end;
  setcolor(cyan, 7);

end;
