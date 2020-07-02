program galactic_empire;

uses crt, dos;

var
  Local: boolean;
  mono: boolean;
  Color: byte;
  cmd1, cmd2: string;
  cx, cy, Lines: integer;

  (* --- Start of missing functions --- *)

  procedure fatal(s: string);
  begin
    WriteLn(s);
    Halt(1);
  end;

  function long2str(l: longint; n: integer): String;
  var
    s: String;
    c: char;
  begin
    if (n < 0) then begin
      c := '0';
      n := -n;
    end
    else begin
      c := ' ';
    end;

    str(l, s);
    while (length(s) < n) do
    begin
      s := c + s;
    end;

    long2str := s;
  end;

  function int2str(i: integer; n: integer): String;
  var
    s: String;
    c: char;
  begin
    if (n < 0) then begin
      c := '0';
      n := -n;
    end
    else begin
      c := ' ';
    end;

    str(i, s);
    while (length(s) < n) do
    begin
      s := c + s;
    end;

    int2str := s;
  end;

  function alltrim(s: String): String;
  begin
    while ((length(s) > 0) and (s[1] <= ' ')) do
    begin
      s := copy(s, 2, 255);
    end;

    while ((length(s) > 0) and (s[length(s)] <= ' ')) do
    begin
      s := copy(s, 1, length(s) - 1);
    end;

    alltrim := s;
  end;

  function iif(b: boolean; s: string; t: string): string;
  begin
    if b then iif := s else iif := t;
  end;

  (* --- End of missing functions --- *)

  procedure print (s: string);
    begin
      if s <> '' then
        begin
          write (s);
          cx := cx + length (s);
        end;
    end;

  procedure println (s: string);
    begin
      print (s);
      print (#13#10);
      cx := 1;
      inc (cy);
    end;

  procedure SetColor (i, j: integer);
    var fg, bg: integer;
      bold: char;
      blink: string;
    const
      table: String = '04261537';
    begin
      if mono then
        i := j;

      if i <> color then
        begin
          color := i;
	  fg := i mod 16;
          if fg > 7 then bold := '1' else bold := '0';
          fg := fg mod 8;
          if i > 127 then blink := ';5' else blink := '';

          if local then
            textcolor(color)
          else
            write(#27'[' + bold + ';3' + table[1+fg] + blink + 'm');
        end;
    end;

type
  str16 = string[16];
  planetRec = record
    name: str16;
    production,
    ships,
    owner,
    x, y: longInt;
    ownerName: str16;
    last: longInt;
    collectDest,
    collectSave: integer;
    taxes: longInt;
  end;

  fleetRec = record
    warning: boolean;
    ships,
    start,
    enter,
    source,
    sx, sy,
    destination,
    owner: longInt;
    ownerName: str16;
  end;

  PlayerRec = record
    name: str16;
    last: longint;
  end;

var
  playerFile: file of playerRec;
  planetFile: file of planetRec;
  fleetFile: file of fleetRec;
  player: playerRec;
  id, date, newdate: longint;
  mark: string;
  timer, dt, lastdisp: longint;
  msg: text;


procedure savePlayer (n: longint; var r: playerrec);
begin
  seek (playerfile, n - 1);
  write (playerfile, r);
end;

procedure savePlanet (n: longint; var r: planetrec);
begin
  seek (planetfile, n - 1);
  write (planetfile, r);
end;

function traveltime (x0, y0, x1, y1: longint): longint;
begin
  traveltime := round(sqrt (sqr(x0-x1)+sqr(y0-y1))) div 12 + 1;
end;


procedure leave;
begin
  if id <> 0 then begin
    player.last := date;
    savePlayer (id, player);
  end;
  close (playerFile);
  close (planetFile);
  close (fleetFile);

  {$i-}
  RmDir('mutex.emp');
  {$i+}

  halt (0);
end;


function ships2str (n: longint): string;
  begin
    if n >= 0 then
      ships2str := long2str (n,11)
    else
      ships2str := ' Death star';
  end;


function ptos(x,y:longint): string;
var sx, sy: string;
begin
  str (x mod 100:2, sx);
  str (y mod 100:2, sy);

  ptos := chr(x div 100+65)+chr(y div 100+48)+' '+sx+'/'+sy;
end;



function cutname (s: str16): str16;
begin
  cutname := copy (s+'                ',1,16);
end;


function planetToS (n: longInt; p:planetRec): string;
var s: string;
begin
  str (n:3,s);
  planetToS := '#'+s+' '+cutname (p.name)+' '+ptos(p.x,p.y);
end;

function trimPlanet (n: longint; p:planetRec): string;
var s: string;
begin
  str (n:3,s);
  TrimPlanet := '#'+alltrim(s)+' '+alltrim (cutname (p.name))+' '+ptos(p.x,p.y);
end;


function gettimer: longint;
var
  h,m,s,s100: word;
begin
  GetTime(h, m, s, s100);
  gettimer := (h*3600 + m*60 + s) * 18 + s100 div 5;
end;

function memb: byte;
begin
  memb := byte(gettimer);
end;

procedure testleave;
begin
  dt := 36*60*18 - (gettimer - timer);
  dt := dt + 20*60*18;
  if dt <0 then leave;
end;

procedure gotoxy (x,y:integer);

begin
  if local then
    begin
      crt.gotoXY (x, y);
    end
  else
    begin
      write(#27 + '[' + int2str(y,0) + ';' + int2str(x, 0) + 'H');
    end;

  cx := x;
  cy := y;
end;

procedure clearArea (x1, y1, x2, y2: integer);
  var
    y: integer;
  begin

    x2 := x2-x1+1;
    for y := y1 to y2 do
      begin
        if local then
          begin
            crt.gotoxy (x1, y);
            write (copy ('                                                                                  ',1, x2));
          end
        else
          begin
            gotoxy (x1, y);
            write (copy ('                                                                                  ',1, x2));
          end;

        cx := 999;
      end;
  end;


procedure clrscr;
var c: integer;
begin
  cx := 999;
  cy := 999;
  if local then
    crt.clrscr;
  c := color;
  color := magenta;
  write (#27'[2J');
  setcolor (c, c);
  testleave;
  gotoxy (1,1);
end;



function keypressed: boolean;
  begin
    testleave;
    keypressed := crt.keypressed;
  end;

function readkey: char;
begin
  repeat
    testleave;
  until keypressed;

  if crt.keypressed then
    readkey := crt.readkey

end;


function waitkey: char;
  var
    c: char;
  begin
    while keypressed do
      c := readkey;
    println ('');
    print (' - Key - ');
    waitkey := readkey;
  end;


function instr (var s: string; ml: integer): boolean;
var c: char;
begin
  s := '';
  repeat
    c := readkey;
    if (c>=' ') and (c <#255) and (length (s) <abs(ml)) and ((c in ['0'..'9']) or (ml > 0)) then begin
      s := s + c;
      print (c);
    end else if (c = #8) and (length(s) >= 1) then begin
      s := copy (s, 1, length (s) - 1);
      print (#27'[1D; '#27'[1D;');
    end else if c <> #13 then print (#7);
  until (c = #13) or (c=#27);

  instr := c=#13;
end;



function upStr(s: string): string;
var
  d: string;
  i: byte;
begin
  d :='';
  for i := 1 to length(s) do d := d+upcase(s[i]);
  upStr := d;
end;

function itos (i: longint): string;
var s: string;
begin
  str (i,s);
  itos := s;
end;


function dtos (d:longint): string;
begin
  d := d+16;
  dtos := itos (d div 24 mod 32)+'.'+itos (d div (24*32) mod 12)+'. '+itos(d mod 24)+':00';
end;

function input (s: string): longint;
var i: longint;
    err: integer;
begin
  print (s);
  if not instr (s,-9) then
    begin
      input := -1;
      exit;
    end;

  if s = '' then
    begin
      print ('0');
      input := 0;
      exit;
    end;

  val (s,i,err);
  input := i;
end;


  procedure error (s: string);
    var
      c: char;
    begin
      gotoxy (3,lines-1);
      setcolor (red+8+128, 15+128);

      print (s+#7);

      while keypressed do
        c := readkey;

      c := readkey;
    end;


procedure loadPlanet (n: longint; var r: planetrec);
begin
  seek (planetfile, n - 1);
  read (planetfile, r);
end;

function Planets: longint;
begin
  planets := filesize (planetfile);
end;

procedure loadPlayer (n: longint; var r: playerrec);
begin
  seek (playerfile, n - 1);
  read (playerfile, r);
end;

function Players: longint;
begin
  players := filesize (playerfile);
end;


procedure loadfleet (n: longint; var r: fleetrec);
begin
  seek (fleetfile, n - 1);
  read (fleetfile, r);
end;

procedure savefleet (n: longint; var r: fleetrec);
begin
  seek (fleetfile, n - 1);
  write (fleetfile, r);
end;

function fleets: longint;
begin
  fleets := filesize (fleetfile);
end;


function PlayerID (s: str16): longint;
var p: playerRec;
    n: longint;
begin
  s := upstr(s);
  for n := 1 to players do begin;
    loadplayer (n, p);
    if p.name = s then begin
      PlayerID := n;
      exit;
    end;
  end;
  PlayerID := 0;
end;

function FreePlayer: longint;
var n: longInt;
 p: playerrec;
begin
  for n := 1 to players do begin
    loadPlayer (n, p);
    if p.name = '' then begin
      FreePlayer := n;
      exit;
    end;
  end;
  FreePlayer := players + 1;
end;


function FreeFleet: longInt;
var n: longInt;
 p: FleetRec;
begin
  for n := 1 to fleets do begin
    loadFleet (n, p);
    if p.ships = 0 then begin
      FreeFleet := n;
      exit;
    end;
  end;
  FreeFleet := fleets + 1;
end;

var dest: longint;

procedure openMsg (d: longInt; s: string);
begin
  dest := d;

  if d > 1 then
    begin
      assign (msg,'msg'+itos(d)+'.emp');
      {$i-}
      append (msg);
      if ioresult <> 0 then rewrite (msg);
      {$i+}

      writeln (msg);
      writeln (msg);
      writeln (msg, 'Date:   ',dtos (date));
      writeln (msg, 'Source: ',s);
      writeln (msg);
    end;
end;

procedure writeMsg (s: string);
begin
  if dest > 1 then
    writeln (msg, s);
end;

procedure closeMsg;
begin
  if dest > 1 then
    close (msg);
end;

procedure AutoCreatePlanets;
var
  planet: planetRec;
  n: longInt;

begin
  rewrite (planetfile);
  println ('');
  println ('Creating universe...');
  println ('');
  for n := 1 to 999 do begin
    planet.x      := random (1000);
    planet.y      := random (1000);
    planet.production := random(5);
    planet.ships := random (1500);
    planet.owner := 0;
    planet.last := Newdate;
    if n = 1 then begin
      planet.name := 'MAIN PLANET';
      planet.ownername := 'COMPUTER';
      planet.owner := 1;
      planet.production := 10;
    end else begin
      planet.name := 'NAMELESS';
      planet.ownername := 'INDEPENDENT';
    end;
    savePlanet (n, planet);
  end;
end;

procedure AutoCreatePlayers;
var
  player: playerRec;

begin
  rewrite (playerfile);
  println ('');
  println ('Autocreating Players...');
  println ('');
  player.name := 'COMPUTER';
  player.last := Newdate;
  savePlayer (1, player);
end;


function conv (c: char): longint;
begin
  if c>='a' then conv := (ord (c) - ord ('a'))*100
  else if c>='A' then conv := (ord (c) - ord ('A'))*100
  else if c>='0' then conv := (ord (c) - ord ('0'))*100
  else conv := 0;
end;



procedure workPlanet (n: longint);
var
  dt: longint;
  p: planetrec;
begin
  loadPlanet (n, p);
  dt := date - p.last;
  if dt <> 0 then begin
    if p.owner > 0 then p.ships := p.ships + p.production * dT;
    p.last := date;
    savePlanet (n, p);
  end;
end;

procedure planetwork;
var n: longint;
begin
  for n := 1 to planets do workPlanet (n);
end;


procedure fleetWork;
var
  p: planetrec;
  f, f2: fleetrec;
  oriP, oriF: longInt;
  n, fl,next, i, saveDate: longint;

begin
  fl := fleets;

  while date <= newdate do begin
    next := newdate+1;
    println ('');
    print ('Calculations... '+dtos (date)+':');
    for n := 1 to fl do begin
      loadFleet (n, f);

      if (f.ships <> 0) and (f.enter-24 < date) and not f.warning then begin
        loadPlanet (f.destination, p);
        if (p.owner <> 0) and (f.owner <> p.owner) then begin
          OpenMsg (p.owner, planetToS (f.destination, p));
          writeMSG ('ATTENTION: Approaching hostile fleet detected.');
          closeMSG;
        end;
        f.warning := true;
        savefleet (n,f);
        print (' W:'+int2str(n,0));
      end;

      
      if (f.ships <> 0) and (f.enter <= date) then begin
        Workplanet (f.destination);
        loadPlanet (f.destination, p);

        print (' A:'+int2str(n,0));

        if f.ships < 0 then
          begin
            {
            Todesstern!!!!
            }

            for i := 1 to fleets do
              begin
                loadfleet (i, f2);
                if f2.destination = f.destination then
                  begin
                    f2.ships := 0;
                    savefleet (i, f2);
                  end;
              end;

            OpenMsg (p.owner, planetToS (f.destination, p));
            writeMSG ('FINAL MESSAGE - Planet and all based and approaching');
            writeMSG ('troops were destroyed by a death star');
            writeMSG ('by commander '+f.ownername+'.');
            closeMsg;

            OpenMsg (f.owner, planetToS (f.destination, p));
            writeMSG ('Planet and all based and approaching troops');
            writeMSG ('destoryed successfully.');
            closeMsg;

            p.x      := random (1000);
            p.y      := random (1000);
            p.production := random(6);
            p.ships := random (1500);
            p.owner := 0;
            p.last := date;
            p.name := 'NAMELESS';
            p.ownername := 'INDEPENDENT';

          end
        else if p.owner = f.owner then
          begin
            p.ships := p.ships + f.ships;
            OpenMsg (p.owner, planetToS (f.destination, p));
            writeMSG ('Troops increased by '+itos(f.ships)+' to '+itos (p.ships)+ ' ships.');
            closeMSG;
          end
        else
          begin
            oriF := f.ships;
            oriP := p.ships;
            while (p.ships > 0) and (f.ships > 0) do begin
              f.ships := f.ships - p.ships div (5+ random (4)) - 1;
              if f.ships > 0 then
                p.ships := p.ships - f.ships div (6+ random (5)) - 1;
            end;

            if f.ships <0 then f.ships := 0;
            if p.ships <0 then p.ships := 0;

            if f.ships > 0 then begin
              OpenMsg (p.owner, planetToS (f.destination, p));
              writeMSG ('FINAL MESSAGE - All troops destroyed by '+itos(oriF)+' enemy ships.');
              writeMSG ('Planet now conrolled by '+f.ownername+'.');
              writeMSG ('Own losses    '+itos(oriP)+' ships.');
              writeMSG ('Enemy losses: '+itos(oriF-f.ships)+' ships.');
              closeMsg;

              OpenMsg (f.owner, planetToS (f.destination, p));
              writeMSG ('Planet conquered with '+ itos(orif)+' ships.');
              writeMSG ('Own losses:   '+itos(oriF-f.ships)+' ships.');
              writeMSG ('Enemy losses: '+itos(oriP)+' ships.');
              closeMsg;

              p.ships := f.ships;
              p.owner := f.owner;
              p.ownername := f.ownername;
            end
          else
            begin
              OpenMsg (p.owner, planetToS (f.destination, p));
              writeMSG ('Attack by '+itos(oriF)+' ships of commander '+f.ownername);
              writeMSG ('successfully defeated.');
              writeMSG (itos(p.ships)+' ships survived the battle.');
              writeMSG ('Own losses: '+itos(p.ships-oriP)+' ships.');
              closeMsg;

              OpenMsg (f.owner, planetToS (f.destination, p));
              writeMSG ('FINAL MESSAGE - Attack formation failed to conquer target planet.');
              writeMSG ('All '+itos(oriF)+' ships were destroyed.');
              closeMsg;
            end;
        end;

        saveplanet (f.destination, p);
        f.ships := 0;
        savefleet (n,f);
      end;
      if (f.ships <> 0) and (f.enter > date) and (f.enter < next) then next := f.enter;
    end;
    date := next;
  end;
  date := newdate;
end;


function sendFleet (s: integer; todesstern: boolean): boolean;
var s2,d,n,delta, costs, time: longint;
  p1, p2: planetRec;
  f: fleetRec;

begin
  sendfleet := false;

  f.ownername := player.name;
  f.owner := id;
  f.warning := false;

  if todesstern then
    s2 := input(' - send death star from planet #')
  else
    s2 := input(' - send fleet from planet #');
  if s2 = 0 then
    begin
      print (#8+int2str (s, 0));
      loadplanet (s, p1);
    end
  else
    begin
      s := s2;
      if (s < 0) or (s > planets) then
        begin
          error ('Planet does not exist!');
          exit;
        end;
      loadPlanet (s, p1);
      if p1.owner <> id then
        begin
          error ('Planet not under your control!');
          exit;
        end;
    end;

  if todesstern and (p1.ships < 2000) then
    begin
      error ('2000 ships required for death star transformation!');
      exit;
    end;


  d := input (' to planet #');

  gotoxy (3,lines-2);

  if (d<1) or (d>planets) then begin
    error ('Planet does not exist!');
    exit;
  end;

  loadplanet (d, p2);

  time := traveltime (p1.x,p1.y,p2.x,p2.y);

  println ('The flight to '+p2.name+' will take about '+int2str(time,0)+' hours.');
  gotoxy (3, lines-1);

  if todesstern then
    begin
      print ('Confirm launch of the death star with "Y", abort otherwise? ');
      if upcase (readkey) <> 'Y' then
        begin
          error ('Launch aborted!                                            ');
          exit
        end;
      f.ships := -1;
      dec (p1.ships, 2000)
    end
  else
    begin
      n := input ('How many ships [0..'+long2str(p1.ships,0)+']? ');

      if n <= 0 then begin
        error ('Invalid input!                                                  ');
        exit;
      end;

      if n > p1.ships then
        n := p1.ships;
      p1.ships := p1.ships - n;

      f.ships := n;
    end;

  saveplanet (s, p1);
  f.source := s;
  f.sx := p1.x;
  f.sy := p1.y;
  f.destination := d;

  f.start := date;
  f.enter := date+ time;

  savefleet (freefleet, f);

  sendfleet := true;
end;





function login: boolean;

var name, password, number: string;
  error: integer;
  pn: longint;
  p: planetrec;
  c: char;
begin
  clrscr;

  if not local then
    begin
      crt.clrscr;
      println ('Empire is being played by '+paramstr(1)+' at '+paramstr (2)+ ' baud');
      println ('');
      println ('Press ESC to abort...');
      println ('');
    end;

  id := 0;
  println ('     Galactic Empire');
  println ('     ===============');
  println ('');
  println ('                           (C) 1990, 1992, 2020 Stefan Haustein');
  println ('                                                Joerg Pleumann');

  println ('');
  println ('');
  println ('Attention: Timeout is now 6 hours. Terminal needs VT100/ANSI support.');
  println ('');
  println ('');
  println ('Login Date: '+dtos(newdate));
  println ('');
  name := upstr (paramstr(1));

  login := false;

  pn := (memb  and 127)*7+1;

  loadplanet (pn, p);
  if p.owner = 1 then begin
    p.ships := p.ships div 10;
    saveplanet (pn, p);
  end;

  if (name <> '') then begin
    id := playerid(name);
    if id = 0 then begin
      id := freePlayer;
      player.last := NewDate;
      player.name := name;
      pn := memb  *3+3;
      loadplanet (pn, p);
      inc (p.ships, p.ships + random (10000)+1000);
      p.production := 5;
      if p.owner <> 0 then begin
        openMsg (p.owner, planetToS (pn, p));
        writeMsg ('LATEST NEWS - Enemy rebels took control.');
        closeMsg;
      end;
      p.owner := id;
      p.ownername := name;
      saveplanet (pn, p);
      saveplayer (id, player);

      openMsg (p.owner, planetToS (pn, p));
      writeMsg ('Our rebels took control.');
      closeMsg;

      login := true;
      c := waitkey;
    end
    else begin
      loadplayer (id, player);

      if newdate - player.last < 6 then
        begin
          print ('Access to galactic supercomputer rejected.'+#13#10);
          print ('Please try again '+int2str (6-newdate+player.last,2)+' hours'+#13#10);
          login := false;
          id := 0;
        end
      else
        begin
          login := true;
          println ('Last login: '+dtos(player.last));
          println ('');
          println ('');
          println ('Awaiting your orders, commmander '+player.name+'.');
        end;
      c := waitkey;
    end;
  end;
end;


procedure fleetList (eigen: boolean);
var n, x, y, nd, c: longInt;
  f: fleetrec;
  s, d: planetrec;
  h: integer;
  dt: longInt;
begin
  c := 0;
  for n := 1 to fleets do begin
    loadfleet (n, f);
    dt := f.enter - date;
    if (f.ships <> 0) and (
       (not eigen and (dt < 24) and (f.owner <> id)) or
       (eigen and (f.owner = id))
      ) then begin
      loadplanet (f.destination, d);
      if eigen or (d.owner = id) then begin
        if c mod (lines - 9) = 0 then begin
          if c <> 0 then if waitkey = #27 then exit;
          clrscr;
          if eigen then begin
            println ('     List of my fleets');
            println ('     ===================================');
            println ('');
            println ('  ID Position Origin Target                            ETA/h    Ships  ');
            println ('-----------------------------------------------------------------------');
          end else begin
            println ('     List of enemy fleets');
            println ('     =================================');
            println ('');
            println ('  ID Position Target                            ETA/h    Ships   Commander');
            println ('------------------------------------------------------------------------------');
          end;
        end;
        inc (c);

        x := f.sx-(f.sx-d.x)*(f.start-date) div (f.start-f.enter);
        y := f.sy-(f.sy-d.y)*(f.start-date) div (f.start-f.enter);

        h := (c and 1) * 8;

        setcolor (cyan+h,7);
        print (int2str (n, 4)+' '+ptos(x,y)+' ');

        if eigen then
          begin
            print (long2str (f.source, 5)+' ');
            if d.owner = 0 then
              setcolor (green+h,15)
            else if d.owner <> id then
              setcolor (red+h,7);
          end;

        print (planetToS (f.destination,d));


        setcolor (cyan+h,h);
        print (' '+int2str(dt,6));
        if eigen or (dt <= 8) then print (ships2str (f.ships)) else print ('         ?');
        if not eigen and (dt <= 4) then print (' '+f.ownername);
        println ('');
      end;
    end;
  end;
  if c = 0 then begin
    clrscr;
    println ('');
    println ('');
    println ('No fleets in travel');
  end;

  setcolor (cyan, 7);
end;


var c: char;

procedure displaymessages;
var m: string;
  n: longInt;
  c: longint;
  k: char;

begin
  assign (msg, 'msg'+itos(id)+'.emp');
{$i-}
  c := 0;
  reset (msg);
  if ioresult = 0 then begin
{$i+}
    while not eof (msg) do begin
      readln (msg,m);
      if c mod (lines-7) = 0 then begin
        if (c <> 0) then
          k := waitkey;
        clrscr;
        println ('     Messages / news');
        println ('     ==========================');
        println ('');
      end;
      println (m);
      inc (c);
    end;
    rewrite (msg);
  end;
  if c mod (lines-7) <> 0 then
    k := readkey;
end;



procedure SendText;
var
  s, t: string;
  n: longInt;
  b: boolean;
begin
  clrscr;
  print ('Send message to: ');
  b := instr (s,20);
  println ('');
  n := PlayerID (s);
  if n = 0 then begin
    println ('');
    println ('Destination does not exist');
  end else begin
    println ('');
    println ('Message Text:');
    openMSG (n, player.name);
    repeat
      b := instr (t,79);
      println ('');
      writeMSG (t);
    until t='';
    closeMSG;
  end;
end;

procedure renamePlanet (n0: integer);
var
  n: integer;
  p: planetrec;
  s: string;
  b: boolean;
begin
  n := input (' - Rename planet; ID: ');
  if n = 0 then
    begin
      print (#8+int2str (n0,0));
      n := n0;
    end;

  gotoxy (3, lines-2);

  if (n <= 0) or (n > planets) then
    begin
      error ('Invalid planet!');
      exit;
    end;

  loadplanet (n, p);
  if p.owner <> id then
    begin
      error ('Not your planet!');
      exit;
    end;


  print ('New name: ');
  b := instr (s,16);
  if s <> '' then
    begin
      p.name := s;
      p.name := upstr(p.name);
      saveplanet (n,p);
    end;
end;



procedure statistik (era: boolean);
var n,nn,paz,pfl,ppr,faz,ffl: longint;
  p:planetrec;
  f:fleetrec;
  s: string;
  b: boolean;
  k: char;
begin
  clrscr;
  println ('     Statistical information');
  println ('     ==========================');
  println ('');
  println ('');
  if era = false then begin
    print ('                    Commander: ');
    b := instr (s,20);
    println ('');
    println  ('');
    n := playerId (s);
    if n = 0 then begin
      println (#7'Invalid commander!');
      exit;
    end;
  end else n := id;

  paz := 0;
  pfl := 0;
  ppr := 0;

  for nn := 1 to planets do begin
    loadplanet (nn, p);
    if p.owner = n then begin
      inc (paz);
      inc (pfl, p.ships);
      inc (ppr, p.production);
    end;
  end;

  println ('         Planets under control: '+int2str (paz,0));
  println ('                    Percentage: '+int2str (paz * 100 div 1000,0)+' %');
  println ('          Total resident ships: '+long2str(pfl,0));
  println ('        Ships produced per day: '+long2str (ppr * 24,0));
  println ('');

  faz := 0;
  ffl := 0;

  for nn := 1 to fleets do begin
    loadfleet (nn, f);
    if ((f.owner = n) and (f.ships <> 0)) then begin
      inc (faz);
      inc (ffl, abs(f.ships));
    end;
  end;

  println ('              Number of fleets: '+long2str(faz,0));
  println ('               Ships in travel: '+long2str (ffl,0));
  println ('');
  println ('                   Total ships: '+long2str(pfl+ffl,0));
  println ('');

  if era and (pfl + ffl = 0) then begin
    println ('Sorry, you lost ... commander deleted!');
    Player.name := '';
  end;

  k := waitkey;
end;

procedure mitspieler;
var
  n, c: longint;
  p: playerrec;
begin
  c := 0;
  for n := 1 to players do begin
    loadplayer (n, p);
    if player.name <> '' then begin
      if c mod (lines-7) = 0 then begin
        if c <> 0 then if waitkey = #27 then exit;
        clrscr;
        println ('     Commanders');
        println ('     ==========');
        println ('');
      end;
      inc (c);
      println (chr(64+c)+': '+cutname(p.name)+'           '+copy(dtos(p.last),1,5));
    end;
  end;
end;


procedure planetlist;
var
  n, c: longint;
  p: planetrec;
begin
  c := 0;
  for n := 1 to planets do begin
    loadplanet (n, p);
    if p.owner = id then begin
      if c mod (lines-9) = 0 then begin
        if c <> 0 then if waitkey = #27 then exit;
        clrscr;
        println ('     Planets under control');
        println ('     ======================');
        println ('');
        println ('     Name             Position              Ships   Production');
        println ('--------------------------------------------------------------');
      end;
      inc (c);
      setcolor (cyan+8*(c and 1), 7+8*(c and 1));
      println (planetToS (n,p)+'          '+long2str(p.ships,11)+long2str(p.Production*24,11));
    end;
  end;
end;


procedure drawMap (x0, y0, x1, y1: integer; cx, cy, r: longint);
  const
    radius: array[1..7] of integer = (1, 2, 3, 5, 8, 12, 16);

  var
    dx, dy: longInt;

  procedure mapWrite (x, y: longint; s: string);
    begin
      x := x + x0 + dx;
      y := y + y0 + dy;

      if (y >= y0) and (y <= y1) and (x >= x0) and (x + length (s) <= x1) then
        begin
          gotoxy (x, y);
          print (s);
        end;
    end;

  function visible (x, y: longint): boolean;
    begin
      visible := (x <= dx) and (x >= -dx) and (y <= dy) and (y >= - dy);
    end;

  var
    nr: integer;
    l: longint;
    x, y, xf, yf: longint;
    p, d: planetRec;
    s: string;
    f: fleetrec;
    bright: integer;

  begin

    xf := 2;
    if lines > 25 then yf := 2 else yf := 1;

    r := radius [r];

    clearArea (x0, y0, x1, y1);

    dx := ((x1 - x0)) div 2;
    dy := ((y1 - y0)) div 2;


    setcolor (7, 7);
    for nr := 0 to 10 do
      mapwrite ((100 * nr + 50-cx)*xf div r, -dy, chr(nr+65));

    for nr := 0 to 10 do
      mapwrite (-dx, (100 * nr + 50-cy)*yf div r, chr(nr+48));

    if r <= 4 then
      begin
        for nr := 1 to fleets do
          begin
            if keypressed then
              exit;


            loadfleet (nr, f);
            loadplanet (f.destination, d);

            x := f.sx-(f.sx-d.x)*(f.start-date) div (f.start-f.enter);
            y := f.sy-(f.sy-d.y)*(f.start-date) div (f.start-f.enter);
            x := (x - cx)*xf div r;
            y := (y - cy)*yf div r;

            if (f.ships <> 0) and (visible (x, y)) then
              begin
                if f.owner = id then
                  begin
                    if (x = 0) and (y=0) then
                      setcolor (yellow, 15)
                    else
                      setcolor (cyan + 8, 7)
                  end
                else if d.owner = id then setcolor (128+red+8,128+15)
                else setcolor (red, 7);

                for l := f.enter*2 downto date*2 do
                  begin
                    x := f.sx-(f.sx-d.x)*(f.start*2-l) div ((f.start-f.enter)*2);
                    y := f.sy-(f.sy-d.y)*(f.start*2-l) div ((f.start-f.enter)*2);
                    x := (x - cx)*xf div r;
                    y := (y - cy)*yf div r;

                    if l <> date*2 then
                      mapWrite (x, y, '.')
                    else
                      begin
                        if f.owner = id then
                          MapWrite (x, y, '+'+int2str(nr,0))
                        else
                          MapWrite (x, y, chr (96+f.owner)+iif (f.ships < 0,'!',int2str((f.ships+50) div 100,0)+'^'));
                      end;
                  end;
              end;
          end;
      end;
    for nr := 1 to planets do
      begin
        if keypressed then exit;

        loadPlanet (nr ,p);
        x := ((p.x - cx)*xf) div r;
        y := ((p.y - cy)*yf) div r;
        if visible (x, y) then
          begin
            if p.production >= 3 then
              bright := 8
            else
              bright := 0;
            if p.owner = id then
              begin
                if (x=0) and (y=0) then
                  setcolor (yellow, 15)
                else
                  setcolor (cyan+bright, 15)
              end
            else if p.owner = 0 then
               setcolor (green+bright, 7)
            else
               setcolor (red+bright, 7);

            if (p.owner = 0) then
              begin
                s := '""****************';
                s := s[p.production+1];
              end
            else
              s := chr(64+p.owner);

            if r < 16  then
              begin
                s := s + int2str (nr, 0);

                if r < 8 then
                  MapWrite (x+1, y+1, (long2str ((p.ships+50) div 100,0)+'^'));
              end;

            MapWrite (x, y, s);
          end;
      end;
    setcolor (cyan, 7);

  end;




procedure mainloop (pid: integer);
  var
    planet: planetRec;
    radius: longint;
    menuZeile: integer;

  procedure menu (s: string);
    begin
      if s <> '' then
        begin
          if (lines > 40) then
            gotoXY (53, 2*menuzeile+1)
          else
            gotoXY (53, menuzeile+1);

          if s[2] = ':' then
            begin
              setcolor (cyan+8,15);
              print (s[1]);
              setcolor (cyan,7);
              s := copy (s,2,255);
            end;
          print (s);
        end;
      inc (menuzeile);
    end;




  procedure restoreInfo;
    begin
      menuzeile := 1;
      with planet do
        begin
          setcolor (yellow,15);
          menu ('#'+int2str (pid,-3)+' '+Name+copy ('                  ', 1,20-length (name)));
          menu ('');
          setcolor (cyan,7);
          menu ('Position    Ships   Prod.');
          setcolor (8+cyan,15);
          menu (ptos (x, y)+long2str (ships,11)+int2str (production*24,6));
          setcolor (cyan,7);
        end;
    end;

  procedure restoreMap;
    begin
      drawMap (2, 2, 50, (lines-24+19), planet.x, planet.y, radius);
    end;

  procedure fleetinfo;
    var n, x, y, nd: longInt;
      f: fleetrec;
      s, d: planetrec;
      doit, c: char;
    begin
      n := input (' - Fleet information; ID: ');
      gotoxy (3, lines-2);
      if (n = 0) or (n > fleets) then begin
        error ('Invalid fleet!');
        exit;
      end;

      loadfleet (n, f);
      if (f.owner <> id) or (f.ships = 0) then begin
        error ('Invalid fleet!');
        exit;
      end;
      loadplanet (f.source, s);
      loadplanet (f.destination, d);

      x := f.sx-(f.sx-d.x)*(f.start-date) div (f.start-f.enter);
      y := f.sy-(f.sy-d.y)*(f.start-date) div (f.start-f.enter);

      repeat
        drawMap (2, 2, 50, (lines-24+19), x, y, 2);

        clearArea (3, lines-2, 78, lines-1);

        gotoxy (3, lines-2);
        if f.ships < 0 then
          print ('Death star')
        else
          print ('Cnt: '+long2str(f.ships,0));

        print (' Pos: '+ptos(x,y)+' Dest: '+trimplanet (f.destination,d)+' in '+
        long2str(f.enter-date,0)+' h');
        gotoxy (3, lines-1);
        print ('Change course (Y/N)? ');

        doit := upCase(readkey);
        print (doit);

        if doit = 'Y' then
          begin
            gotoxy (3, lines-1);
            nd := input ('ID of new destination: #');
            if (nd>0) and (nd <= planets) and (nd <> f.destination) then
              begin
                loadPlanet (nd, d);
                f.warning := false;
                f.enter := date + traveltime (x, y, d.x, d.y);
                f.sx := x;
                f.sy := y;
                f.start := date;
                f.destination := nd;
                savefleet (n, f);
              end
            else
              error ('Invalid destination!              ');
          end;
      until doit <> 'Y';

      restoreMap;
    end;


  function collectFleet (pid: integer): boolean;
    var
      n, c, t: integer;
      p, d: planetrec;
      range, anz: longint;
      f: fleetrec;
      k: char;

    begin
      collectFleet := false;

      n := input (' - Assemble fleet  #');
      if n <> 0 then
        pid := n
      else
        print (#8+int2str (pid, 0));

      if (pid <= 0) or (pid > planets) then
        begin
          error ('Invalid planet');
          exit;
        end;

      loadplanet (pid, d);

      gotoXY (3, lines-2);
      range := input ('Maximum distance (hours): ');
      if range < 0 then
        exit;
      if range = 0 then
        begin
          range := 12;
          print (#8'12');
        end;


      c := 0;
      for n := 1 to planets do
        begin
          loadplanet (n, p);

          t := traveltime (d.x, d.y, p.x, p.y);

          if (p.owner = id) and (pid <> n) and (t <= range) and (p.ships > 0) then begin
            if c mod (lines-9) = 0 then begin
              if c <> 0 then if waitkey = #27 then exit;
              clrscr;
              collectfleet := true;
              println ('     Assemble fleet in planet '+planettos (pid, d));
              println ('     ===============================================');
              println ('');
              println ('     Name             Position      Ships    Prod.  Time  Num. to snd');
              println ('---------------------------------------------------------------------');
            end;
            inc (c);
            print (planetToS (n,p)+'  '+long2str(p.ships,11)+long2str(p.Production*24,7)+long2str (t, 6)+'  ');
            anz := input ('? ');
            if anz < 0 then
              exit;

            if anz > p.ships then
              anz := p.ships;

            gotoxy (58, cy);

            println (long2str (anz,12));
            if anz > 0 then
              begin
                f.ownername := player.name;
                f.owner := id;
                f.warning := false;

                p.ships := p.ships - anz;


                saveplanet (n, p);

                f.ships := anz;
                f.source := n;
                f.sx := p.x;
                f.sy := p.y;
                f.destination := pid;

                f.start := date;
                f.enter := date + t;

                savefleet (freefleet, f);
              end;

          end;
      end;

      if c = 0 then
        error ('None of your planets within that distance!')
      else
        k := waitkey;


  end;





  procedure restoreAll;
    var n: integer;
    begin
      clrscr;
      setcolor (blue,7);
      println ('-------------------------------------------------------------------------------');
      for n := 2 to (lines-1) do
        begin
          gotoxy (1, n);
          print ('|');
          if n < (lines -24+20) then
            begin
              gotoxy (51, n);
              print ('|');
            end;
          gotoxy (79, n);
          print ('|');
        end;

      gotoxy (1, lines);
      print   ('-------------------------------------------------------------------------------');

      gotoxy (1, (lines-4));
      print   ('-------------------------------------------------------------------------------');

      restoreMap;
      with planet do
        begin
          menuzeile := 6;
          menu ('+: Zoom in / ');
          setcolor (cyan+8,15);
          print ('-');
          setcolor (cyan,7);
          print (': Zoom out');
          menu ('M: Fullscreen map');
          menu ('P: Select planet');
          menu ('R: Rename planet');
          menu ('F: Send fleet');
          menu ('C: Collect ships');
          menu ('D: Death star...');
          menu ('L: List...');
          menu ('W: Write message');
          menu ('T: Terminal mode');
          menu ('H: Help');
          menu ('X: Exit');
        end;
    end;



  var n: integer;
  k: char;
  label label_break, label_continue;

  begin
    loadPlanet (pid, planet);

    radius := 3;

    restoreAll;


    repeat
      loadPlanet (pid, planet);
      restoreInfo;

      clearArea (3,lines-3,78,lines-1);

      repeat
        gotoxy (3,lines-3);
        print ('['+int2str (dt div (60*18),-2)+':'+int2str(dt div 18 mod 60,-2)+'] Command?  '#8);
      until keypressed;
      c := upcase (readkey);
      print (c);
      if not local then
        write (' Command: ',c);
      case c of
        '+':
          if radius > 1 then
            begin
              dec (radius);
              restoreMap;
            end;
        '-':
          begin
            if radius < 7 then
              begin
                inc (radius);
                restoreMap;
              end;
          end;
        'P':
          begin
            print (' - Change planet');
            gotoxy (3,lines-2);
            n := Input ('New planet #');
            gotoxy (3,lines-1);
            if (n <= 0) or (n > planets) then
              error ('Invalid value'#7)
            else
              begin
                loadplanet (n, planet);
                if planet.owner <> id then
                  error ('Not your planet!')
                else
                  begin
                    pid := n;
                    restoreMap;
                  end;
                loadPlanet (pid, planet);
              end;
          end;
        'R': renamePlanet (pid);
        'M':
          begin
            drawMap (1,1,79, lines, planet.x, planet.y, radius);
            repeat
              case upcase (readkey) of
                '-':
                  if radius < 7 then
                    inc(radius)
                  else
                    goto label_continue;
                '+':
                  if radius > 1 then
                    dec (radius)
                  else
                    goto label_continue;
                else goto label_break
              end;

              drawMap (1,1,79, lines, planet.x, planet.y, radius);

              label_continue:

            until false;

            label_break:

            restoreAll
          end;
        'F':
          begin
            if sendfleet (pid, false) then
              restoreMap;
          end;
        'D':
          begin
            if sendfleet (pid, true) then
              restoreMap;
          end;
        'H': error ('Help file not found!');
        'X': exit;

        'C':
          if collectFleet (pid) then
            restoreall;
        'W':
          begin
            sendText;
            restoreAll;
          end;
        'L':
          begin
            print (' - List');
            gotoxy (3, lines-2);
            setcolor (cyan+8, 15);
            print ('C');
            setcolor (cyan, 7);
            print (': Commanders ');

            setcolor (cyan+8, 15);
            print ('P');
            setcolor (cyan, 7);
            print (': Planets ');

            setcolor (cyan+8, 15);
            print ('F');
            setcolor (cyan, 7);
            print (': Fleets ');

            setcolor (cyan+8, 15);
            print ('E');
            setcolor (cyan, 7);
            print (': Enemy fleets ? ');

            c := upcase (readkey);
            if c <> #27 then
              begin
                print (c);

                case c of
                  'P': planetlist;
                  'C': mitspieler;
                  'F': fleetlist (true);
                  'E': fleetlist (false);
                  else c := #27;
                end;

                if c = #27 then
                  error ('Invalid command!')
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
            if lines = 24 then
              begin
                if mono then
                  mono := false
                else
                  lines := 49;
              end
            else
              begin
                if mono then
                  lines := 24
                else
                  mono := true;
              end;

            restoreAll;
          end;
      end;
    until false;
  end;



var n: longint;
  y,mo,d,dow,h,m,s,s100: word;
  z: playerRec;
  p: planetrec;

  ships: longInt;
  pid, i: integer;

begin
  randomize;

  DirectVideo:=False;
  Assign(Output,'');
  Append(Output);

  Lines := 24;
  mono := true;

  setcolor (cyan,7);

  LOCAL := paramStr (2) = '0';

  {$i-}
  MkDir('mutex.emp');
  if IOResult<>0 then begin
    printLn('Galactic supercomputer already in use. Please try again later.');
    Halt(1);
  end;
  {$i+}

  id := 0;
  dt := 100000;

  timer := gettimer;

  getDate (y,mo,d,dow);
  getTime (h,m,s,s100);

  newDate := y*32*12*24+mo*32*24+d*24+h;

  assign (playerFile, 'player.emp');
  assign (planetFile, 'planet.emp');
  assign (fleetFile, 'fleet.emp');

  {$i-}
  reset (playerfile);
  if ioresult <> 0 then autocreatePlayers;
  reset (planetfile);
  if ioresult <> 0 then autoCreatePlanets;
  reset (fleetfile);
  if ioresult <> 0 then rewrite (fleetfile);
  {$i+}

  loadPlayer (1, z);

  date   := z.last;

  z.last := newDate;
  savePlayer (1, z);

  clrscr;

  fleetwork;
  planetWork;

  if login then begin

    displaymessages;
    ships := 0;
    pid := -1;
    for i := 1 to planets do
      begin
        loadPlanet (i, p);
        if (p.owner = id) and (p.ships >= ships) then
          begin
            pid := i;
            ships := p.ships;
          end;
      end;

    if pid <> -1 then
      begin
        mainloop (pid);
      end;

    statistik (true);
  end;
  leave;
end.
