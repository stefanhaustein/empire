procedure mainloop(pid: integer);
var
  planet: planetRec;
  radius: Integer;
  menuZeile: integer;

  procedure menu(s: Str255);
  begin
    if s <> '' then
    begin
      if (Lines > 40) then
        SetCursor(53, 2 * menuzeile + 1)
      else
        SetCursor(53, menuzeile + 1);

      if s[2] = ':' then
      begin
        setcolor(cyan + 8, 15);
        print(s[1]);
        setcolor(cyan, 7);
        s := copy(s, 2, 255);
      end;
      print(s);
    end;
    Inc(menuzeile, 1);
  end;

  procedure restoreInfo;
  begin
    menuzeile := 1;
    with planet do
    begin
      setcolor(yellow, 15);
      menu('#' + int2str(pid, -3) + ' ' + Name + copy('                  ',
        1, 20 - length(Name)));
      menu('');
      setcolor(cyan, 7);
      menu('Position    Ships   Prod.');
      setcolor(8 + cyan, 15);
      menu(ptos(x, y) + Real2Str(ships, 11) + Int2Str(production * 24, 6));
      setcolor(cyan, 7);
    end;
  end;

  procedure restoreMap;
  begin
    drawMap(2, 2, 50, (Lines - 24 + 19), planet.x, planet.y, radius);
  end;

(*
  procedure fleetinfo;
  var
    n, x, y, nd: Integer;
    f: fleetrec;
    s, d: planetrec;
    doit, c: char;
  begin
    n := input(' - Fleet information; ID: ');
    SetCursor(3, Lines - 2);
    if (n = 0) or (n > fleets) then
    begin
      error('Invalid fleet!');
      exit;
    end;

    loadfleet(n, f);
    if (f.owner <> id) or (f.ships = 0) then
    begin
      error('Invalid fleet!');
      exit;
    end;
    loadplanet(f.Source, s);
    loadplanet(f.destination, d);

    x := Round(f.sx - (f.sx - d.x) * (f.start - date) / (f.start - f.enter));
    y := Round(f.sy - (f.sy - d.y) * (f.start - date) / (f.start - f.enter));

    repeat
      drawMap(2, 2, 50, (Lines - 24 + 19), x, y, 2);

      ClearRegion(3, Lines - 2, 78, Lines - 1);

      SetCursor(3, Lines - 2);
      if f.ships < 0 then
        print('Death star')
      else
        print('Cnt: ' + Real2Str(f.ships, 0));

      print(' Pos: ' + ptos(x, y) + ' Dest: #' + Int2Str(f.destination, 0));
      print(' ' + TrimStr(d.Name) + ' ' + ptos(d.x, d.y));
      print(' in ' + Real2Str(f.enter - date, 0) + ' h');
      SetCursor(3, Lines - 1);
      print('Change course (Y/N)? ');

      doit := upCase(InKey);
      print(doit);

      if doit = 'Y' then
      begin
        SetCursor(3, Lines - 1);
        nd := input('ID of new destination: #');
        if (nd > 0) and (nd <= planets) and (nd <> f.destination) then
        begin
          loadPlanet(nd, d);
          f.warning := False;
          f.enter := date + traveltime(x, y, d.x, d.y);
          f.sx := x;
          f.sy := y;
          f.start := date;
          f.destination := nd;
          savefleet(n, f);
        end
        else
          error('Invalid destination!              ');
      end;
    until doit <> 'Y';

    restoreMap;
  end;
*)

  function collectFleet(pid: integer): boolean;
  var
    n, c: integer;
    t: Real;
    p, d: planetrec;
    range: Integer;
    f: fleetrec;
    k: char;
    anz: Real;
  begin
    collectFleet := False;

    n := input(' - Assemble fleet  #');
    if n <> 0 then
      pid := n
    else
      print(#8 + int2str(pid, 0));

    if (pid <= 0) or (pid > planets) then
    begin
      error('Invalid planet');
      exit;
    end;

    loadplanet(pid, d);

    SetCursor(3, Lines - 2);
    range := input('Maximum distance (hours): ');
    if range < 0 then
      exit;
    if range = 0 then
    begin
      range := 12;
      print(#8'12');
    end;


    c := 0;
    for n := 1 to planets do
    begin
      loadplanet(n, p);

      t := traveltime(d.x, d.y, p.x, p.y);

      if (p.owner = id) and (pid <> n) and (t <= range) and (p.ships > 0) then
      begin
        if c mod (Lines - 9) = 0 then
        begin
          if c <> 0 then
            if waitkey = #27 then
              exit;
          ClearScreen;
          collectfleet := True;
          println('     Assemble fleet in planet ' + planettos(pid, d));
          println('     ===============================================');
          println('');
          println(
            '     Name             Position      Ships    Prod.  Time  Num. to snd');
          println(
            '---------------------------------------------------------------------');
        end;
        Inc(c, 1);
        print(planetToS(n, p) + '  ' + Real2Str(p.ships, 11) + Int2Str(
          p.Production * 24, 7) + Real2Str(t, 6) + '  ');
        anz := input('? ');
        if anz < 0 then
          exit;

        if anz > p.ships then
          anz := p.ships;

        SetCursor(58, cy);

        println(Real2Str(anz, 12));
        if anz > 0 then
        begin
          f.ownername := player.Name;
          f.owner := id;
          f.warning := False;

          p.ships := p.ships - anz;


          saveplanet(n, p);

          f.ships := anz;
          f.Source := n;
          f.sx := p.x;
          f.sy := p.y;
          f.destination := pid;

          f.start := date;
          f.enter := date + t;

          savefleet(freefleet, f);
        end;

      end;
    end;

    if c = 0 then
      error('None of your planets within that distance!')
    else
      k := waitkey;

  end;

  procedure restoreAll;
  var
    n: integer;
  begin
    ClearScreen;
    setcolor(blue, 7);
    println('-------------------------------------------------------------------------------');
    for n := 2 to (Lines - 1) do
    begin
      SetCursor(1, n);
      print('|');
      if n < (Lines - 24 + 20) then
      begin
        SetCursor(51, n);
        print('|');
      end;
      SetCursor(79, n);
      print('|');
    end;

    SetCursor(1, Lines);
    print('-------------------------------------------------------------------------------');

    SetCursor(1, (Lines - 4));
    print('-------------------------------------------------------------------------------');

    restoreMap;
    with planet do
    begin
      menuzeile := 6;
      menu('+: Zoom in / ');
      setcolor(cyan + 8, 15);
      print('-');
      setcolor(cyan, 7);
      print(': Zoom out');
      menu('M: Fullscreen map');
      menu('P: Select planet');
      menu('R: Rename planet');
      menu('F: Send fleet');
      menu('C: Collect ships');
      menu('D: Death star...');
      menu('L: List...');
      menu('W: Write message');
      menu('T: Terminal mode');
      menu('H: Help');
      menu('X: Exit');
    end;
  end;

var
  n: integer;
  k: char;
label
  label_break, label_continue;

begin
  loadPlanet(pid, planet);

  radius := 3;

  restoreAll;

  repeat
    loadPlanet(pid, planet);
    restoreInfo;

    ClearRegion(3, Lines - 3, 78, Lines - 1);

    repeat
      TestLeave;
      SetCursor(3, Lines - 3);
      print('[' + int2str(dt div 60, -2) + ':' + int2str(dt mod 60, -2) + '] Command?  '#8);
      delay(100);
    until keypressed;
    c := upcase(InKey);
    print(c);
    if not local then
      Write(' Command: ', c);
    case c of
      '+':
        if radius > 1 then
        begin
          Dec(radius, 1);
          restoreMap;
        end;
      '-':
      begin
        if radius < 7 then
        begin
          Inc(radius, 1);
          restoreMap;
        end;
      end;
      'P':
      begin
        print(' - Change planet');
        SetCursor(3, Lines - 2);
        n := Input('New planet #');
        SetCursor(3, Lines - 1);
        if (n <= 0) or (n > planets) then
          error('Invalid value'#7)
        else
        begin
          loadplanet(n, planet);
          if planet.owner <> id then
            error('Not your planet!')
          else
          begin
            pid := n;
            restoreMap;
          end;
          loadPlanet(pid, planet);
        end;
      end;
      'R': renamePlanet(pid);
      'M':
      begin
        drawMap(1, 1, 79, Lines, planet.x, planet.y, radius);
        repeat
          case upcase(InKey) of
            '-':
              if radius < 7 then
                Inc(radius, 1)
              else
                goto label_continue;
            '+':
              if radius > 1 then
                Dec(radius, 1)
              else
                goto label_continue;
            else
              goto label_break
          end;

          drawMap(1, 1, 79, Lines, planet.x, planet.y, radius);

          label_continue:

        until False;

        label_break:

          restoreAll;
      end;
      'F':
      begin
        if sendfleet(pid, False) then
          restoreMap;
      end;
      'D':
      begin
        if sendfleet(pid, True) then
          restoreMap;
      end;
      'H': error('Help file not found!');
      'X': exit;

      'C':
        if collectFleet(pid) then
          restoreall;
      'W':
      begin
        sendText;
        restoreAll;
      end;
      'L':
      begin
        print(' - List');
        SetCursor(3, Lines - 2);
        setcolor(cyan + 8, 15);
        print('C');
        setcolor(cyan, 7);
        print(': Commanders ');

        setcolor(cyan + 8, 15);
        print('P');
        setcolor(cyan, 7);
        print(': Planets ');

        setcolor(cyan + 8, 15);
        print('F');
        setcolor(cyan, 7);
        print(': Fleets ');

        setcolor(cyan + 8, 15);
        print('E');
        setcolor(cyan, 7);
        print(': Enemy fleets ? ');

        c := upcase(InKey);
        if c <> #27 then
        begin
          print(c);

          case c of
            'P': planetlist;
            'C': mitspieler;
            'F': fleetlist(True);
            'E': fleetlist(False);
            else
              c := #27;
          end;

          if c = #27 then
            error('Invalid command!')
          else
          begin
            k := waitkey;
            restoreAll;
          end;
        end;
      end;
{       'T':
          begin
            statistik (false);
            restoreAll;
          end;}
      'T':
      begin
        if Lines = 24 then
        begin
          if mono then
            mono := False
          else
            Lines := 49;
        end
        else
        begin
          if mono then
            Lines := 24
          else
            mono := True;
        end;

        restoreAll;
      end;
    end;
  until False;
end;

var
  n: Integer;
  z: playerRec;
  p: planetrec;

  ships: Real;
  pid, i: integer;

begin
  randomize;

  DirectVideo := False;
  Assign(Output, '');
  Append(Output);

  Lines := 24;
  mono := True;

  setcolor(cyan, 7);

  LOCAL := ParamStr(2) = '0';

  {$i-}
  MkDir('mutex.emp');
  if IOResult <> 0 then
  begin
    printLn('Galactic supercomputer already in use. Please try again later.');
    Halt(1);
  end;
  {$i+}

  id := 0;
  dt := 100000;

  timer := Ticks;

  if ParamStr(3) <> '' then
    Val(ParamStr(3), newDate)
  else
    newDate := Now();

  Assign(playerFile, 'player.emp');
  Assign(planetFile, 'planet.emp');
  Assign(fleetFile, 'fleet.emp');

  {$i-}
  reset(playerfile);
  if ioresult <> 0 then
    autocreatePlayers;
  reset(planetfile);
  if ioresult <> 0 then
    autoCreatePlanets;
  reset(fleetfile);
  if ioresult <> 0 then
    rewrite(fleetfile);
  {$i+}

  loadPlayer(1, z);

  date := z.last;

  z.last := newDate;
  savePlayer(1, z);

  ClearScreen;

  fleetwork;
  planetWork;

  if login then
  begin

    displaymessages;
    ships := 0;
    pid := -1;
    for i := 1 to planets do
    begin
      loadPlanet(i, p);
      if (p.owner = id) and (p.ships >= ships) then
      begin
        pid := i;
        ships := p.ships;
      end;
    end;

    if pid <> -1 then
    begin
      mainloop(pid);
    end;

    statistik(True);
  end;
  leave;
end.

