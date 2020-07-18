(* --- Start of missing functions --- *)

procedure Fatal(s: Str255);
begin
  WriteLn(s);
  Halt();
end;

function Replace(S: Str255; C, D: Char): Str255;
var
  I: Integer;
begin
  for I := 1 to Length(S) do
    if S[I] = C then
      S[I] := D;
  Replace := S;
end;

function ToUpper(S: Str255): Str255;
var
  I: Integer;
begin
  for I := 1 to Length(S) do
    S[I] := UpCase(S[I]);
  ToUpper := S;  
end;

function Real2Str(R: Real; N: Integer): Str255;
var
  S: Str255;
begin
  Str(R:Abs(N):0, S);
  if N < 0 then
    S := Replace(S, ' ', '0');
  Real2Str := S;
end;

function Int2Str(I: Integer; N: Integer): Str255;
var
  S: Str255;
begin
  Str(I:Abs(N), S);
  if N < 0 then
    S := Replace(S, ' ', '0');
  Int2Str := S;
end;

function TrimStr(S: Str255): Str255;
var
  I, J: Integer;
begin
  I := 1;
  while ((I <= Length(S)) and (S[I] <= ' ')) do
    I := I + 1;
  J := Length(S);
  while ((J > I) and (S[I] <= ' ')) do
    J := J - 1;
  TrimStr := Copy(S, I, J - I);
end;

function AlignStr(S: Str255; N: Integer): Str255;
const
  Spaces = '                ';
begin
  if Length(S) >= Abs(N) then
    AlignStr := S
  else if N > 0 then
  begin
    while Length(S) < N do
      S := S + Spaces;
    AlignStr := Copy(S, 1, N);  
  end
  else begin
    N := -N;
    while Length(S) < N do
      S := Spaces + S;
    AlignStr := Copy(S, Length(S) - N + 1, N);
  end
end;

function EpochDay(Y, M, D: Integer): Integer;
const
  DaysGone: array[1..12] of Integer = (0,31,59,90,120,151,181,212,243,273,304,334);
var
  LeapDays: Integer;
begin
  LeapDays := (Y-1-1968) div 4 - (Y-1-1900) div 100 + (Y-1-1600) div 400;

  if ((M>2) and (Y mod 4=0) and ((Y mod 100<>0) or (Y mod 400=0))) then
    LeapDays := LeapDays + 1;

  EpochDay := (Y-1970)*365 + LeapDays + DaysGone[M] + D;
end;

function Now(): Real;
var
  Year, Month, Day, WeekDay, Hour, Minute, Second, Sec100: Word;
begin
  GetDate(Year, Month, Day, WeekDay);
  GetTime(Hour, Minute, Second, Sec100);
  Now := EpochDay(Year, Month, Day) * 24.0 + Hour;
end;

function Ticks(): Integer;
var
  Hour, Minute, Second, Sec100: Word;
begin
  GetTime(Hour, Minute, Second, Sec100);
  Ticks := Minute * 60 + Second;
end;

(* --- End of missing functions --- *)
