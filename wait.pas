program wait;

uses crt, xsystem, xstring;

var
  d: word;
  s: string;

begin
  s := alltrim (paramstr (1));
  if s = '' then
    begin
      Writeln ('Parameter - Wartezeit in Sek. - fehlt!');
      halt (2);
    end;

  d := str2word (s);

  write ('Warten ... Abbruch mit beliebiger Taste      ');


  while (not keypressed) and (d > 0) do
    begin
      write (#8#8#8#8#8,d:5);
      delay (1000);
      dec (d);
    end;

  writeln;

  if d = 0 then
    halt (0)
  else
    halt (1);

end.
