
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
