var mono: boolean;
var color: Integer;

(* 
 * Sets the Cursor postion to the given line and column using the "H"
 * ANSI command. Coordinates are 1-based, matching the ANSI command.
 *)
procedure CursorPosition(Line, Column: Integer);
begin
  Write(Chr(27), 'Y', Chr(Line - 1 + 32), Chr(Column - 1 + 32));
end;

procedure SetColor(i, j: integer);
var
  fg, bg: integer;
  bold: char;
  blink: String;
const
  table: String = '04261537';
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

    Write(#27'[' + bold + ';3' + table[1 + fg] + blink + 'm');
  end;
end;
