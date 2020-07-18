program Empire3;

type
  Str255 = String[128];
  Word = Integer;

const
  Black = 0;
  Blue = 1;
  Green = 2;
  Cyan = 3;
  Red = 4;
  Magenta = 5;
  Brown = 6;
  LightGray = 7;
  DarkGray = 8;
  LightBlue = 9;
  LightGreen = 10;
  LightCyan = 11;
  LightRed = 12;
  LightMagenta = 13;
  Yellow = 14;
  White = 15;
  Blink = 128;

procedure Inc(var I: Integer; J: Integer);
begin
  I:=I+J;
end;

procedure Dec(var I: Integer; J: Integer);
begin
  I:=I-J;
end;

procedure TextColor(Color: Integer);
begin
end;

procedure MkDir(Dir: Str255);
begin
end;

procedure RmDir(Dir: Str255);
begin
end;

procedure GetTime(H, M, S, S100: Integer);
begin
end;

procedure GetDate(Y, M, D, Dow: Integer);
begin
end;

function ReadKey: Char;
var
  C: Char;
begin
  Read(KBD, C);
  ReadKey := C;
end;

{$I utility.pas}
{$I galaxy.pas}
{$I command.pas}
{$I main.pas}
