 {}
  {#F}
 { Verwalter.......:  Stefan Haustein}
  {Erstes Datum....:  08.10.1992     }
  {Letztes Datum...:  21.04.1996     }
  {#F}
  {}

Unit
  XString;

Interface

Uses
  xSystem;

Type
  PXlatTable = ^TXlatTable; {Zeiger auf #TXlatTable#} {#X XlatPStr}
  TXlatTable = Array [0..255] of Char;
    {Translationstabelle fÅr #XlatPStr#}

Function AllTrimStr (Const S: String): String;
  {Leerzeichen Am Stringanfang und -Ende werden abgeschnitten. Entspricht #LTrimStr# (#TrimStr# (S))}
  {#X LTrimStr TrimStr SuperTrimStr}
Function CenterStr (Const S: String; C: Char; Laenge: byte): String;
  {Der String wird auf die LÑnge <Laenge> gebracht, dabei durch gleichmÑ·iges
   AuffÅllen mit <C> von rechts und links Zentriert.
   Ist <S> lÑnger als <Laenge>, so wird die RÅckgabe auf <Laenge> gekÅrzt.}
  {#X FillStr LFillStr}
Function CopyChar (C: Char; Laenge: Byte): String;
  {Liefert einen String zurÅck, der <Laenge> mal <C> enthÑlt}
  {#X Space}
Function CompareIndexStr (Const a, b: String): Integer;
  {Vergleicht zwei Strings ohne BerÅcksichtigung der gro·/kleinschreibung und
   mit korrekter Umlaut-Sortierung}
Function CopyStr (Const S: String; Count: Integer): String;
  {Liefert einen neuen String, der <Count> mal aus <S> besteht}
Function CountChar (Const S: String; C: Char): Byte;
  {Was wohlt? ZÑhlt die Zeichen <C> in S.}
Function CountCharSet (Const S: String; CS: TCharSet): Byte;
  {Wie CountChar, nur mit CharSet.}
Function CountStr (Const SubStr, S: String): integer;
  {ZÑhlt das vorkommen von <SubStr> in <S>}
Function CountParts (Const S: String): Integer;
  {ZÑhlt die Teile einen Strings, wenn man bei dem Pipe-Zeichen schneidet}
Function CountPartsByChar (Const S: String; Seperator: Char): Integer;
  {ZÑhlt die Teile eines Strings bei Zerlegung mit <Seperator>}
Function CountPartsBySet (Const S: String; Seperator: TCharSet): Integer;
  {ZÑhlt die Anzahl der Teilstrings von <S>, die durch <Seperator>
   getrennt werden}
  {#X GetPartStr}
Function CountWrapLines (Const S: String; W: byte): Integer;
  {Wieviele Zeilen ergeben sich beim Wordwrap des Strings}
  {#X WordWrap}
Function CutStr (Var S: String): String;
  {Schneidet von <S> den ersten Teilstring bis zum Pipe-Zeichen ab und
   liefert diesen als Ergebnis zurÅck. Ist kein Pipe-Zeichen in <S>, so
   ist <S> anschlie·en leer und die RÅpckgabe ist der gesamte String}
Function CutStrByChar (Var S: String; Sep: Char): String;
  {Wie CutStr, mit beliebigem Trennzeichen}
Function CutStrBySet (Var S: String; Sep: TCharSet): String;
  {Wie CutStr, mit beliebigen Trennzeichen}
Function DelChar (Const S: String; C: Char): String;
  {Lîscht alle Vorkommenden Zeichen <C> im String <S>}
Function DelCharSet (Const S: String; CS: TCharSet): String;
  {Lîscht alle zeichen in CS aus S
   (Wie #DelChar#, nur mit CharSet)}
Function DiffStr (S, T: String): Integer;
  {ZÑhlt die Unterschiede zwischen S und T}
Function DigitIndexStr (Const S: String): String;
Function FillStr (Const S: String; C: Char; Laenge: Byte): String;
  {FÅllt <S> am Ende mit <C> auf <Laenge> auf, bzw. kÅrzt auf <Laenge>}
  {#X LFillStr CenterStr}
Function Float2StrUsing (F: Float; Const Using: String): String;
{Ziffern:
 Flags:
 .     Dezimaltrennzeichen '.'
 ,     Dezimaltrennzeichen ','
 :     Automatische Wahl (default)
 +     Auch + angeben
 O     FÅhrende Nullen (NK immer automatisch)
 T     Tausender-Separatoren

 10:2  10 vk 2 Nk
 10:2  10 vk 2 Nk
 10:   10 Stellen insgesamt, Ausrichtung automatisch
 0:2   = 0 vk 2 Nk (Dezimalpunkt)
 :2    = Beliebige VK, 2 NK
 2:0   = 2 vk 0 nk (kein Dezimalpunkt)}

Function FormatStr (S: String; Const Using: String): String;
{Formatiert den Åbergeben String <S> mit <Using>:
 Ziffern geben LÑnge fÅr L (default) oder R an
 L       LinksbÅndig
 C       Zentriert
 R       RechtsbÅndig
 D       LoCase (S);
 U       UpCase (S);
 !       SuperTrimStr
 >       lTrimStr
 <       trim}

Function FromStr (Const S: String; P: Byte): String;
  {Liefert String ab Position <P> zurÅck; Leerstring wenn P > Length (S)}
  {#X LeftStr RightStr}
Function GetPartStr (Const S: String; N: Integer): String;
  {Liefert <N>-ten durch Pipes definierten Teilstring von <S>}
Function GetPartStrByChar (Const S: String; N: Integer; C: Char): String;
  {Liefert <N>-ten durch Seperator <C> definierten Teilstring von <S>}
Function GetPartStrBySet (Const S: String; N: Integer; C: TCharSet): String;
  {Liefert N-ten durch Seperator(en) <C> definierten Teilstring von <S>}
  {#X CountPartsStr}
Function IncStr(Var S: String; Base: Byte): Boolean;
  { Inkrementiert den angegebenen String von rechts beginnend. }
  { Es wird entsprechend der angegebenen Basis gezÑhlt, also   }
  { 10 fÅr dezimal, 16 fÅr hex, etc. Der String wird nicht     }
  { lÑnger, es werden stattdessen Zeichen ersetzt. Wird die    }
  { maximale darstellbare Zahl Åberschritten, dann wird als    }
  { Funktionsergebnis <True> zurÅckgegeben, um einen Overflow  }
  { zu melden. Sonst ist das Ergebnis <False>. Die Prozedur    }
  { kann zum automatischen Umbenennen von Dateien benutzt      }
  { werden (.ARJ -> .AR0 -> .ARJ1) oder zum Erzeugen von Fido- }
  { Paketnamen. Es sollte darauf geachtet werden, da· nur Gro·-}
  { buchstaben als Ziffern benutzt werden. }
Function IndexStr (Const s: string; Cut: Boolean): String;
  {Wandelt <S> in einen fÅr Indices geeigneten String um:
   Die LÑnge bleibt konstant, wenn cut true ist, Umlaute werden durch
   entsprechende Vokale, · durch S und Kleinbuchstaben durch
   Grossbuchstaben ersetzt}
Function KryptStr (s: string): String;
  {Die Buchtaben werden verschlÅsselt; Die VerschlÅsselung bleibt im
   Bereich oberhalb / unterhalb von ASCII 32}
Function LeftStr (Const S: String; N: Byte): String;
  {Die ersten <N> Zeichen von <S> werden zurÅckgeliefert
   Ist N grî·er als Length (S), so wird S zurÅckgeliefert}
  {#X FromStr RightStr}
Function LFillStr (Const S:String; C:Char; Laenge: Byte): String;
  {FÅllt <S> am Anfang mit <C> auf <Laenge> auf, bzw. kÅrzt auf <Laenge>}
  {#X FillStr CenterStr}
Function Long2StrUsing (L: LongInt; Using: String): String;
  {Wandelt einen LongInt <L> unter BerÅcksichtigung von <Using>
   in einen String um. <Using> ist bei Float2StrUsing beschrieben}
Function LowChar (C: Char): Char;
  {Wandelt C in den entsprechenden Kleinbuchstaben um}
  {#X IndexStr LowChar LowStr PrettyStr UpChar UpStr XLatPStr}
Function LowStr (Const S: String): String;
  {Wandelt S in Kleinbuchstaben um}
  {#X IndexStr LowChar LowStr PrettyStr UpChar UpStr XLatPStr}
Function LTrimStr (Const S: String): String;
  {Liefert <S> ohne fÅhrende Leerzeichen zurÅck}
  {#X AllTrimStr TrimStr}
function MatchStr(Txt, Pat: string): Boolean;
  { Vergleicht einen String mit einem Pattern. Das Pattern kann '*' und }
  { '?' in beliebigen Kombinationen enthalten. Der Text kann bis zu 253 }
  { Zeichen lang sein, das Pattern bis zu 252. Au·erdem sollte der Text }
  { keine Zeichen mit dem ASCII-Code 255 enthalten, da diese intern von }
  { der Routine benutzt werden.                                         }
  {#X SplitStr MergeStr}
function MaxCommonSubStr(A, B: string): string;
  { Vergleich zwei Strings und liefert den lÑngsten gemeinsamen Substring }
  { zurÅck. }
function MergeStr(Pattern, Template: string): string;
  { FÅllt die einzelnen Wildcards eines Patterns durch jeweils einen }
  { Eintrag einer Schablone.                                         }
  { z.B. Pattern  = 'Ich wÅnsche einen *en und *en *.'               }
  {      Template = 'schîn|gut|Tag|'                                 }
  {  =>  Result   = 'Ich wÅnsche einen schînen und guten Tag.'       }
  {#X MatchStr SplitStr}
function MkI (i: integer): string;
  {Wandelt I in 2-Zeichen-String im Intel-Format um}
  {#X MkI MkL MkP MkR}
function MkL (l: longint): string;
  {Wandelt L in 4-Zeichen-String im Intel-Format um}
  {#X MkI MkL MkP MkR}
function MkP (p: pointer): string;
  {Wandelt P in 4-Zeichen-String im Intel-Format um}
  {#X MkI MkL MkP MkR}
function MkR (r: real): string;
  {Wandelt R in 6-Zeichen-String im Pascal-Format um}
  {#X MkI MkL MkP MkR}
function NthPos (n: integer; Const subStr, s: string): Integer;
  {Liefert N-te Position von SubStr in S zurÅck, 0 wenn weniger als N Vorkommen}
  {#X Pos PosCharSet ReplaceStr}
Function PosAfter (Const substr, s: String; Startpos: Byte): Integer;
  {Liefert die Position des Substrings ab einer Stelle startsearch im String}
Function PosBefore (Const substr, s: String; Startpos: Byte): Integer;
  {Liefert das Vorkommen von Substring vor einer StartPosition}
Function PosCharSet (c: TCharSet; const s: String): Integer;
  {Liefert Position des ersten Vorkommens eines Zeichens aus <C> in <S> zurÅck, sonst 0}
  {#X Pos NthPos ReplaceStr StartStr}
Function PrettyStr (S: String): String;
  {Wandelt erstes Zeichen und jedes Zeichen nach einem Leerzeichen in
   Gro·buchstaben um, alle anderen Zeichen in Kleinbuchstaben.}
  {#X IndexStr LowChar LowStr UpStr XLatPStr}
Function ReplaceChar (OldChar, NewChar: Char; Const S: String; N: integer): String;
  {Ersetzt N-tes Vorkommen von OldS in S durch NewS; bei N=0 werden alle Vorkommen ersetzt.}
  {#X NthPos Pos PosCharSet StartStr}
Function ReplaceStr (Const OldS, NewS: String; S: String; N: integer): String;
  {Ersetzt N-tes Vorkommen von OldS in S durch NewS; bei N=0 werden alle Vorkommen ersetzt.}
  {#X NthPos Pos PosCharSet StartStr}
Function RightStr (Const S: String; N: Integer): String;
  {Die letzten <N> Zeichen von <S> werden zurÅckgeliefert.
   Ist N grî·er als die LÑnge von <S>, so wird S zurÅckgeliefert}
  {#X FromStr LeftStr}
Function Space (n: byte): string;
  {Liefert String aus N Leerzeichen zurÅck. Identisch zu #CopyChar# (' ', N)}
function SplitStr(Txt, Pat: string): string;
  { Vergleicht einen String mit einem Pattern und liefert eine Liste  }
  { der Sub-Strings zurÅck, die mit jeweils einem Wildcard 'gematcht' }
  { wurden.                                                           }
  { z.B. Txt = 'EinenschînengutenTag'                                 }
  {      Pat = 'Einen*en*en*'                                         }
  {  =>  Res = 'schîn|gut|Tag|'                                       }
  {#X MatchStr MergeStr}
Function StartStr (Const SubStr, S: String): Boolean;
  {Schaut ob S mit SubStr anfÑngt; SubStr = '' liefert immer True}
  {#X NthPos Pos PosCharSet ReplaceStr}
Function Str2FloatUsing (S: String; Const Using: String): Float;
  {Wandelt S in Float um. Using '?' sucht ',' und '.' von hinten und nimmt
   ersten Fund als Dezimaltrennzeichen, das entsprechende andere Zeichen als
   Tausenderseparator. ',' und '.' erzwingt die entsprechende
   Dezimalseparatorbelegung, sonst werden die globalen <SepThousand>
   und <SepDecimal> verwendet}
Function SuperTrimStr (S: String): String;
  {fÅhrt AlltrimStr durch und ersetzt im Wort mehrfache leerzeichen
   durch ein einziges}
  {#X LTrimStr AllTrimStr SuperTrimStr}
Function TrimStr (Const S: String): String;
  {Scheidet Leerzeichen am Ende von S ab}
  {#X LTrimStr AllTrimStr SuperTrimStr}
Function UnFormatNumber (const s, using: String): String;
  {Entfernt Leerzeichen und Tausenderseperatoren}
Function UpChar (C: Char): Char;
  {Liefert Gro·buchstaben zu C zurÅck}
  {#X IndexStr LowChar LowStr PrettyStr UpStr XLatPStr}
Function UpStr (Const S: String): String;
  {Liefert S in Gro·buchstaben zurÅck}
  {#X IndexStr LowChar LowStr PrettyStr UpChar XLatPStr}
Procedure Wordwrap (Var S, T: String; w: Integer);
  {String S wird an Position w Gewrapped, der Rest steht in T. Wenn kein
   Leerzeichen gefunden wird, mu· hart in einem Wort getrennt werden}
  {#X CountWrapLines}
Function XCutStrByChar (Var S: String; Sep, A, B: Char): String;
{Trennt <S> wie die Funktion #CutStrByChar#, jedoch wird der Seperator <Sep>
 ignoriert, wenn er zwischen den Zeichen <A> und <B> steht}
Procedure XlatPStr (S, D: PString; XlatTable: PXlatTable);
  {Kopiert unter Anwendung der Translationstabelle XlatTable S nach D}
  {#X IndexStr LowChar LowStr PrettyStr UpChar UpStr PXlatTable}

Implementation

Uses
  SysUtils;


{$IfNDef Speed}
Const
  _LowXlatTable: TXlatTable =
    #00#01#02#03#04#05#06#07#08#09#10#11#12#13#14#15 +
    #16#17#18#19#20#21#22#23#24#25#26#27#28#29#30#31 +
    ' !"#$%&'#39'()*+,-./0123456789:;<=>?'           +
    '@abcdefghijklmnopqrstuvwxyz[\]^_'               +
    '`abcdefghijklmnopqrstuvwxyz{|}~'               +
    'áÅÇÉÑÖÜáàâäãåçÑÜÇëëìîïñóòîÅõúùûü'               +
    '†°¢£§§¶ß®©™´¨≠ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø'               +
    '¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ'               +
    '‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘˙˚¸˝˛'#255;

  _UpXlatTable: TXlatTable =
    #00#01#02#03#04#05#06#07#08#09#10#11#12#13#14#15 +
    #16#17#18#19#20#21#22#23#24#25#26#27#28#29#30#31 +
    ' !"#$%&'#39'()*+,-./0123456789:;<=>?'           +
    '@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_'               +
    '`ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}~'               +
    'ÄöêAéAèÄEEEIIIéèêííOôOUUòôöõúùûü'               +
    'AIOU••¶ß®©™´¨≠ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø'               +
    '¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ'               +
    '‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘˙˚¸˝˛'#255;
{$Else}
Var
  _LowXlatTable: TXlatTable;
  _UpXlatTable: TXlatTable;
{$Endif}

{$IfNDef Speed}
Function CopyChar (C: Char; Laenge: Byte): String; Assembler;
  Asm
    mov al, laenge
    les di, @result
    stosb
    or al, al
    jz @ende
    cld
    mov cl, al
    mov ch, 0
    mov al, c
    mov ah, al
    stosb
    dec cx
    shr cx, 1
    rep stosw
    adc cx, cx
    rep stosb
  @ende:
  End;

Function CountParts (Const S: String): Integer;
  Begin
    CountParts := CountPartsBySet (S, ['|']);
  End;

Function CountPartsByChar (Const S: String; Seperator: Char): Integer;
  Begin
    CountPartsByChar := CountPartsBySet (S, [Seperator]);
  End;

{$Else}
Function CopyChar (C: Char; Laenge: Byte): String;
  Var
    S: String;
  Begin
    S [0] := Char (Laenge);
    FillChar (s [1], laenge, c);
    CopyChar := S;
  End;

Function CountParts (Const S: String): Integer;
  Var
    CS: tCharSet;
  Begin
    CS := ['|'];
    CountParts := CountPartsBySet (S, CS);
  End;

Function CountPartsByChar (Const S: String; Seperator: Char): Integer;
  Var
    CS: tCharSet;
  Begin
    CS := [Seperator];
    CountPartsByChar := CountPartsBySet (S, CS);
  End;


{$Endif}

Function CopyStr (Const S: String; Count: integer): String;
  Var
    CS: String;
    I: Integer;
  Begin
    CS := '';
    For I := 1 to Count do
      CS := CS + S;
    CopyStr := CS;
  End;

Function _IndexChar (c: Char; Var c1, c2: Char): Boolean;
  {RÅckgabewert = true: zwei Buchstaben, false: nur c1 relevant. Wandelt
   Ñ -> AE etc...}
  begin
    _IndexChar := False;

    if (ord (c) AND 128) = 0 then
      c1 := upChar (c)
    else If c in ['Ñ', 'î', 'Å', 'é', 'ô', 'ö', '·'] then
      begin
        If c = '·' then
          begin
            c1 := 'S';
            c2 := 'S';
          end
        else
          begin
            Case c Of
              'Ñ', 'é': c1 := 'A';
              'î', 'ô': c1 := 'O';
              'Å', 'ö': c1 := 'U';
            end;
            c2 := 'E';
          end;
        _IndexChar := true;
      end
    else if c in ['†', 'Ö'] then
      c1 := 'A'
    else if c in ['Ç', 'ê', 'ä'] then
      c1 := 'E'
    else
      c1 := upChar (c);
  end;


Function AllTrimStr (Const S:String): String;
    Var
      B1,B2:Byte;
    Begin
      B1:=1;
      B2:=Length(S);
      While ((S[B1]=' ') or (s[b1]=#9)) AND (B1<=B2) do
        Inc(B1);
      If B1<B2 then
        While (S[B2]=' ') or (s[b2] = #9) do
          Dec(B2);
      AllTrimStr :=Copy(S,B1,B2-B1+1);
    End;

Function CenterStr (Const S: String; C: Char; Laenge: byte): String;
  begin
    if length (s) > laenge then
      CenterStr := leftStr (s, laenge)
    else
      CenterStr := CopyChar (c, (laenge - length (s)) div 2) +
                   S + CopyChar (c, (laenge - length (s) + 1) div 2);
  end;

Function CompareIndexStr (Const a, b: String): Integer;
  var
    k0, l0,
    addla, addlb,
    i, j: Integer;
    k,l: Boolean;
    c1, c2, d1, d2: Char;
  begin
    I := 1;
    J := 1;

    addla := 0;
    addlb := 0;

    k0 := 256;
    l0 := 256;

    k := false;
    l := false;

    While (k or (i <= length (a))) and (l or (j <= length (b))) do
      begin
        If not k then
          begin
            if _IndexChar (a [i], c1, c2) then
              begin
                k := true;
                Inc (addla);
              end;
            inc (i);
          end
        else
          begin
            if k0 = 256 then
              k0 := i;
            k := false;
            c1 := c2;
          end;

        If NOT l then
          begin
            If _IndexChar (b [j], d1, d2) then
              begin
                l := true;
                Inc (addlb);
              end;
            inc (j);
          end
        else
          begin
            if l0 = 256 then
              l0 := j;

            l := False;
            d1 := d2;
          end;

        If c1 > d1 then
          begin
            CompareIndexStr := 1;
            exit;
          end
        else if c1 < d1 then
          begin
            CompareIndexStr := -1;
            exit;
          end;
      end;

    i := compareInt (Length (a) + addla, Length (b) + addlb);
                    {lÑnge nach der Umwandlung}
    (*
    If i <> 0 then *)
      CompareIndexStr := i
(*   else
      CompareIndexStr := CompareInt (l0, k0); *)
  end;


Function CountPartsBySet (Const S: String; Seperator: TCharSet): Integer;
  var
    n, cnt: Integer;
  begin
    cnt := 1;
    for n := 1 to length(s) do
      if s[n] in Seperator then
        inc (cnt);

    CountPartsBySet := cnt;
  end;

Function CountChar (Const S: String; C: Char): Byte;
  var
    i, cnt: Integer;
  begin
    cnt := 0;

    for i := 1 to length (s) do
      if s[i] = c then inc (cnt);

    CountChar := cnt;
  end;

Function CountCharSet (Const S: String; CS: TCharSet): Byte;
  var
    i, cnt: Integer;
  begin
    cnt := 0;

    for i := 1 to length (s) do
      if s[i] in cs then inc (cnt);

    CountCharSet := cnt;
  end;


Function CountStr (Const SubStr, S: String): integer;
  var
    op, p, c: byte;
  begin
    op := 1;
    p := 1;
    c := 0;
    repeat
      p := pos (subStr, copy (s, op, 255));
      if p <> 0 then begin
        op := op+ p + length (subStr)-1;
        inc (c);
      end;
    until p = 0;
    countStr := c;
  end;

Function CountWrapLines (Const S: String; W: byte): Integer;
  Var
    t, u: String;
    i: Integer;
  Begin
    i := 0;
    t := s;
    repeat
      Wordwrap (t, u, w);
      t := u;
      inc (i);
    until u='';
    CountWrapLines := I;
  End;

Function CutStr (Var S: String): String;
  Begin
    CutStr := CutStrByChar (S, '|');
  End;

function CutStrByChar (var S: String; Sep: Char): String;
  var
    P: Integer;
  begin
    P := Pos(Sep, S + Sep);
    CutStrByChar := Copy(S, 1, P - 1);
    S := Copy(S, P + 1, 255);
  end;

function CutStrBySet (var S: String; Sep: tCharSet): String;
  var
    P: Integer;
  begin
    P := PosCharSet (Sep, S);
    If P = 0 then
      begin
        CutStrBySet := S;
        S := ''
      end
    else
      begin
        CutStrBySet := Copy(S, 1, P - 1);
        S := Copy(S, P + 1, 255);
      end;
  end;


Function DelChar (Const S:String;C:Char):String;
  Var
    B:Byte;
    S2:String;
  Begin
    S2:='';
    For B:=1 to Length(S) do
      If S[B]<>C then S2:=S2+S[B];
    DelChar:=S2;
  End;

Function DelCharSet (Const S: String; CS: TCharSet): String;
  Var
    B:Byte;
    S2:String;
  Begin
    S2:='';
    For B:=1 to Length(S) do
      If not (S[B] in Cs) then S2:=S2+S[B];

    DelCharSet :=S2;
  End;


Function DiffStr (s, t: String): Integer;
  var
    i, j, err: Integer;
  begin
    s := s +' ';
    t := t +' ';

    i := 1;
    j := 1;
    err := 0;

    while (i < length (s)) and (j < length (t)) do
      begin
        if s [i] <> t [j] then
          begin
            inc (err);

            if s [i] = t [j+1] then
              inc (j)
            else if s[i+1] = t [j] then
              inc (i);
          end;
        inc (i);
        inc (j);
      end;

    diffStr := err + biggerInt (length (s), length (t)) - biggerInt (i, j);
  end;


Function DigitIndexStr (Const S: String): String;
  var
    t: String;
    i,j,k: Integer;

  begin
    j := 1;
    while (j <= length (s)) and not (s[j] in ['1'..'9']) do
      inc (j);

    k := 1;

    for i := j to length (s) do
      if s[i] in ['0'..'9'] then
        begin
          inc (k);
          t [k] := s[i];
        end;

    t [0] := chr (k);
    t [1] := chr (ord ('Z') - k);

    digitIndexStr := t;
  end;


Function FillStr (Const S: String; C: Char; Laenge: Byte): String;
  Begin
    If Length (S) > Laenge then
      FillStr := LeftStr (S, Laenge)
    else If Length (S) = Laenge then
      FillStr := S
    else
      FillStr := S + CopyChar (C, Laenge - Length (S));
  End;


Function Float2StrUsing (F: Float; Const Using: String): String;
{Ziffern:
 Flags:
 .     Dezimaltrennzeichen '.'
 ,     Dezimaltrennzeichen ','
 :     Automatische Wahl (default)
 +     Auch + angeben
 O     FÅhrende Nullen (NK immer automatisch)
 T     Tausender-Separatoren

 10:2  10 vk 2 Nk
 10:2  10 vk 2 Nk
 10:   10 Stellen insgesamt, Ausrichtung automatisch
 10    10 Stellen insgesamt, Ausrichtung automatisch
 :2    = Beliebige VK, 2 NK
 2:0   = 2 vk 0 nk (kein Dezimalpunkt)}

  Var
    Num, Start, SepPos, Vk, Nk, I: Integer;
    Assigned, thousands, Sign, trim, Zeros: Boolean;
    tSep, Sep: Char;
    S, Exp: String;

  Begin
    Thousands := False;
    Num := 0;
    Assigned := False;
    Zeros := False;
    Sign := False;
    trim := false;

    Sep := ' ';

    Vk := -1;
    Nk := -1;

    {Analyse des Using-Strings}

    For I := 1 to Length (Using) do
      Case Using [i] Of
        '0'..'9': begin
                    Num := Num * 10 + ord (Using [i])-48;
                    Assigned := true;
                  end;

        ':',',','.': begin
                       {$ifopt r+}
                       If Sep <> ' ' then
                         Warning ('Float2StrUsing (F, ''' + Using + ''') - doppeltes Dezimaltrennzeichen angegeben!');
                       {$endif}

                       Sep := Using [i];
                       If Assigned then
                         begin
                           Vk := Num;
                           assigned := False;
                           Num := 0;
                         end;
                     end;
        't','T': Thousands := true;
        'o','O': Zeros := true;
        '+': Sign := true;
        'L', '!', '>': trim := true;
        {$ifopt R+}
        else
          Warning ('Float2StrUsing (F, ''' + Using + ''') - Unbekannter Formatteil: '''+Using[i]+'''!');
        {$endif}

      end;

    {Separator bestimmen}

    If Sep = ' ' then
      begin
        Sep := ':';
        if Assigned then
          Vk := Num;
      end
    else
      begin
        If Assigned then
          NK := Num;
      end;

    {String und SepPos bestimmen}

    If Sep = ':' then
      Sep := SepDecimal;

    If (vk >= 0) and (nk >= 0) then
      begin
        Str (f:vk:nk, S);
        S := LtrimStr (s);
        SepPos := Length (s) - nk;
      end
    else If (vk < 0) and (nk >= 0) then
      begin
        Str (f:40:nk, S);
        S := ltrimStr (S);
        SepPos := length (S) - Nk;
      end
    else    { keine vorgabe fÅr kommastellen  }
      begin
        Str (f, Exp);
        If vk > 0 then
          Num := vk
        else
          Num := length (Exp);

        Str (f:80:40, s);

        S := LTrimStr (S);

        While S[length(s)] = '0' do
          dec (s[0]);

        If Length (S) > Num then
          S := Exp;

        SepPos := Pos ('.', S);
      end;

    If Nk <> 0 then
      begin
        S [SepPos] := Sep;

        if (nk = -1) and (seppos = length (s)) then
          dec (s[0]);
      end;

    If thousands then
      begin
        if f < 0 then
          start := 2
        else
          start := 1;

        If Sep = '.' then
          tSep := ','
        else
          tSep := '.';

        i := SepPos - 3;

        While i > Start do
          begin
            Insert (tSep, S, i);
            Dec (i, 3);
          end;
      end;

    {beim auffÅllen mit 0 mÅssen nochmal tsep eingef. werden}

    If Sign And (f >= 0) then
      begin
        S := '+'+s;
        inc (i);
      end;

    If vk >= 0 then
      begin
        If Length (S) > vk then
          S := CopyChar (FormatErrChar, vk)
        Else If Length (S) < vk then
          begin
            If Zeros then
              begin
                I := I + (vk - length (s) - 1);

                If (s[1] = '+') or (s[1] = '-') then
                  S := s [1] + lFillStr (FromStr (S, 2), '0', vk-1)
                else
                  S := ' '+lFillStr (S, '0', vk-1);

                If Thousands then
                  begin
                    While i > 1 do
                      begin
                        s [i] := tSep;
                        Dec (i, 4);
                      end;
                  end;
              end
            else if not trim then
              S := lFillStr (S, ' ', vk);
          end
      end;

    Float2StrUsing := S;
  End;


Function FormatStr (S: String; Const Using: String): String;

{Formatiert den Åbergeben String <S> mit <Using>:
 Ziffern geben LÑnge fÅr L (default) oder R an
 L       LinksbÅndig
 C       Zentriert
 R       RechtsbÅndig
 D       LoCase (S);
 U       UpCase (S);
 !       SuperTrimStr
 >       lTrimStr
 <       trim}


  Var
    Num, I: Integer;
    Ar: Char;

  Begin
    Num := 0;
    Ar := 'L';

    For I := 1 to Length (Using) do
      case UpChar (using [i]) of
        '0'..'9': Num := Num * 10 + Ord (Using[i])-48;
        'U': S := UpStr (s);
        'D': S := LowStr (S);
        'C', 'L', 'R': AR := UpChar (Using[i]);
        '!': S := SuperTrimStr (S);
        '<': S := TrimStr (S);
        '>': S := lTrimStr (S);
      end;

    If Num <> 0 then
      begin
        If AR = 'C' then FormatStr := CenterStr (S, ' ', Num)
        else if ar = 'L' then FormatStr := lFillStr (S, ' ', Num)
        else FormatStr := FillStr (S, ' ', Num);
      end
    else
      FormatStr := S;
  End;



Function FromStr (Const S: String; P: Byte): String;
  Begin
    If P > Length (S) Then  (* Wichtig!!!!! *)
      FromStr := ''
    Else
      FromStr := Copy (S, P, 255);
  End;


Function GetPartStr (Const S: String; N: Integer): String;
{$IFNDef Speed}
  Begin
    GetPartStr := GetPartStrBySet (S, N, ['|']);
{$Else}
  Var
    CS: tCharSet;
  Begin
    CS := ['|'];
    GetPartStr := GetPartStrBySet (S, N, CS);
{$Endif}
  End;


Function GetPartStrByChar (Const S: String; N: Integer; C: Char): String;
{$IFNDef Speed}
  Begin
    GetPartStrByChar := GetPartStrBySet (S, N, [C]);
{$Else}
  Var
    CS: tCharSet;
  Begin
    CS := [C];
    GetPartStrByChar := GetPartStrBySet (S, N, CS);
{$EndIf}
  End;


Function GetPartStrBySet (Const S: String; N: Integer; C: TCharSet): String;
  var
    i, p, q: byte;
  begin
    p := 1;
    for i := 2 to n do
      begin
        while (p < length (s)) and not (s[p] in c) do
          inc (p);
        inc (p);
      end;
    if p > length (s) then
      getPartStrBySet := ''
    else
      begin
        q := p;
        while (q <= length (s)) and not (s[q] in c) do
          inc (q);
        getPartStrBySet := copy (s, p, q-p);
      end;
  end;


function IncStr(Var S: String; Base: Byte): Boolean;
Var
  P, Q: Integer;
  Stop: Boolean;
begin
  {$ifopt r+}
  if (Base < 2) or (Base > 36) then
    Fatal('IncStr: Basis mu· im Bereich 2..36 liegen.');
  {$endif}

  P := Length (S);
  Stop := False;

  while (P <> 0) and not Stop do
    begin
      Q := Byte(S[P]) - 48;
      if Q > 9 then Dec(Q, 7);

      if (Q < 0) or (Q >= Base) then
        begin
          S[P] := '1';
          Stop := True;
        end
      else
        begin
          Inc (Q);
          if Q >= Base then
            begin
              S[P] := '0';
              Dec (P);
            end
          else
            begin
              if Q < 10 then
                S[P] := Chr(48 + Q)
              else
                S[P] := Chr(55 + Q);

              Stop := True;
            end;
        end;
    end;
  IncStr := (P = 0);
end;


Function IndexStr (Const S: String; Cut: Boolean): String;
  Var
    t: String;
    i, j: Integer;
  Begin
    j := 1;

    For I := 1 to Length (S) do
      begin
        If _IndexChar (s[i], t[j], t[j+1]) then
          Inc (j);

        Inc (j);
      end;

    if cut then
      t [0] := s[0]
    else
      t[0] := char (j-1);

    IndexStr := t;
  End;



function KryptStr (S: String): String;
  var
    n: integer;
  begin
    for n := 1 to length (s) do
      s[n] := Char (ord (s [n]) xor 15);
    kryptStr := s;
  end;

{$IfNDef Speed}
Function LeftStr (Const S: String; N: Byte): String; Assembler;
  Asm
    mov dx, ds
    les di, @result
    lds si, s

    mov al, ds:[si]
    inc si
    cmp al, n
    jc @ok
    mov al, n
  @ok:
    stosb
    or al, al
    jz @ende
    movsb
    mov cl, al
    mov ch, 0
    dec cx
    shr cx, 1
    rep movsw
    adc cx, cx
    rep movsb
  @ende:
    mov ds, dx
  end;
{$else}
Function LeftStr (Const S: String; N: Byte): String;
  Begin
    LeftStr := Copy (S, 1, N);
  End;
{$endIf}

Function LFillStr (Const S: String; C: Char; Laenge: Byte): String;
  Begin
    If Length (S) > Laenge then
      LFillStr := LeftStr (S, Laenge)
    else If Length (S) = Laenge then
      LFillStr := S
    else
      LFillStr := CopyChar (C, Laenge - Length (S)) + S;
  End;

{$IfNDef Speed}
Function LTrimStr (Const S: String): String; Assembler;
  asm
    cld
    mov  dx, ds
    les  di, s
    mov  cx, 0
    or   cl, es:[di]
    jz   @notfound
    inc  di
    mov  al, 32
    repe scasb
    jz   @notfound
    dec  di
    inc  cl
  @notfound:
    mov  si, es
    mov  ds, si
    mov  si, di
    les  di, @result
    mov  al, cl
    stosb
    rep movsb
    mov ds, dx
  end;
{$else}
Function LTrimStr (Const S: String): String;
  Var
    I: Integer;
  Begin
    I := 1;
    While (I <= Length (S)) AND (S[i] = ' ') do
      Inc (I);

    If I <> 1 then
      LtrimStr := Copy (S, I, 255)
    Else
      LtrimStr := S;
  End;
{$EndIf}


Function Long2StrUsing (L: LongInt; Using: String): String;
  Var
    U: String;
    Fmt: Integer;
    Hex: Boolean;

  Begin
    Fmt := 0;
    Hex := False;

    While Using <> '' do
      begin
        U := CutStr (Using);
        Case U [1] of
          '0'..'9': Fmt := Str2Int (U);
          'F': Fmt := -Str2Int (FromStr (U, 2));
          'H': Hex := true;
        end;
      end;

    If Hex then
      Long2StrUsing := Long2Hex (L, Fmt)
    else
      Long2StrUsing := Long2Str (L, Fmt);
  End;


Function LowChar (C: Char): Char;
  Begin
    LowChar := _LowXLatTable [byte (C)];
  End;

{$IfNDef Speed}
Function LowStr (Const S:String): String; Assembler;
  Asm
    les di, s
    push es
    push di
    les di, @result
    push es
    push di
    push seg (_LowXLatTable)
    push offset (_LowXLatTable)
    Call XlatPStr
  End;
{$Else}
Function LowStr (Const S:String): String;
  Var
    D: String;
  Begin
    XLatPStr (@S, @D, @_LowXLatTable);
    LowStr := D;
  End;
{$EndIf}


function MatchStr(Txt, Pat: string): Boolean;
  var
    Match: Boolean;
    ComPos, NextStar, SubPos: Byte;
    SubPat: string;

  begin
    Txt := #255 + Txt + #255;
    Pat := #255 + Pat + #255 + '*';

      { Zuerst erzwingen wir, da· die Patterns nie mit einem '*' anfangen und }
      { immer mit einem '*' aufhîren. Trotzdem sollen sie immer noch mit dem  }
      { Text Åbereinstimmen, also wird der Text auch geÑndert.                }

    Match := True;

      { Au·erdem sind wir optimistisch, da· es klappt. }

    while (Pat <> '') and Match do
      begin
        { Solange das Pattern noch nicht abgearbeitet ist, und der Vergleich }
        { noch kein negatives Ergebnis liefert, arbeiten wir daran.          }

        NextStar := Pos('*', Pat);

          { Wir suchen die Position des ersten '*'. Nach Voraussetzung ist }
          { davor mindestens 1 Zeichen <> '*'. Das kann auch ein '?' sein. }

        SubPat := Copy(Pat, 1, NextStar - 1);

          { Dieses Sub-Pattern kann Buchstaben und  }
          { Fragezeichen enthalten, aber keine '*'. }

        while (NextStar < Length(Pat)) and (Pat[NextStar + 1] = '*') do
          Inc(NextStar);

          { Au·erdem werden doppelte '*' einfach ignoriert. }

        SubPos := 0;

        repeat
          { Wenn wir eine Position finden, an der das Sub-Pattern in den Text   }
          { pa·t, sieht es gut aus. Sonst kînnen wir direkt den Lîffel abgeben. }

          Inc(SubPos);
          Match := True;
          ComPos := 0;
          while (ComPos < Length(SubPat)) and Match do
            begin
              if (Txt[SubPos + ComPos] <> Pat[ComPos + 1]) and
                 (Pat[ComPos + 1] <> '?') then
                   Match := False;
              Inc(ComPos);
            end;
        until (SubPos + Length(SubPat) > Length(Txt)) or Match;

        if Match then
          begin

            { Wenn wir fÅr das Sub-Pattern eine Entsprechung gefunden haben, }
            { dann kînnen wir von Text und Pattern ein StÅck abschneiden und }
            { mit dem Rest weiterarbeiten. Da wir nach dem '*' abschneiden,  }
            { genÅgt auch das neue Pattern wieder der oben beschriebenen     }
            { Bedingung.                                                     }

            Txt := Copy(Txt, SubPos + Length(SubPat), 255);
            Pat := Copy(Pat, NextStar + 1, 255);

          end;

      end;
    MatchStr := Match;
  end;

Function MaxCommonSubStr(A, B: string): string;
  Var
    Len, P: Byte;
    Res: string;
    Found: Boolean;

  Begin
    Found := False;
    If Length(A) > Length(B) then
      Len := Length(A)
    Else
      Len := Length(B);

    While (not Found) and (Len > 0) do
      begin
        P := 1;
        while (not Found) and (P + Len - 1 <= Length(A)) do
          begin
            Res := Copy(A, P, Len);
            if Pos(Res, B) > 0 then
              Found := True;
            Inc(P);
          end;
        Dec (Len);
      end;

    if Found then
      MaxCommonSubStr := Res
    else
      MaxCommonSubStr := '';
  end;


function MergeStr(Pattern, Template: string): string;
var
  Counter, Y: Byte;
  xResult: string;
begin
  xResult := '';
  Counter := 1;
  while Counter <= Length(Pattern) do begin
    if Pattern[Counter] = '*' then begin
      Y := Pos('|', Template);
      if Y <> 0 then begin
        xResult := xResult + Copy(Template, 1, Y - 1);
        Template := Copy(Template, Y + 1, 255);
      end;
    end
    else xResult := xResult + Pattern[Counter];
    Inc(Counter);
  end;
  MergeStr := xResult;
end;


function MkI (i: integer): string;
  var
    s: string;
  begin
    s[0] := Char (sizeof (i));
    move (i, s[1], 2);
    mkI := s;
  end;

function MkL (l: longint): string;
  var
    s: string;
  begin
    s[0] := Char (sizeof (l));
    move (l, s[1], 4);
    mkL := s;
  end;

function MkP (p: pointer): string;
  var
    s: string;
  begin
    s[0] := Char (sizeof (p));
    move (p, s[1], 4);
    mkp := s;
  end;

function MkR (r: real): string;
  var
    s: string;
  begin
    s[0] := Char (sizeof (r));
    move (r, s[1], 6);
    mkR := s;
  end;

Function NthPos (n: integer; Const SubStr, S: String): integer;
  var
    i, cut, p: Integer;
  begin
    cut := 0;

    for i := 1 to n do
      begin
        p := pos (subStr, FromStr (s, cut+1));
        if p <> 0 then
          cut := cut + p
        else
          begin
            NthPos := 0;
            exit;
          end;
      end;

    NthPos := cut;
  end;

Function PosAfter (Const substr, s: String; Startpos: Byte): Integer;
  Var
    p: Integer;
  Begin
    If Startpos=0 then StartPos := 1;
    P := Pos (SubStr, FromStr (s, StartPos));
    If p = 0 then
      PosAfter :=  0
    else
      PosAfter := p+StartPos-1;
  End;

Function PosBefore (Const substr, s: String; Startpos: Byte): Integer;
  Var
    np,p: Integer;
    t: String;
  Begin
    If Startpos=0 then StartPos := 1;
    t := Leftstr (s, Startpos);
    np := 0;
    repeat
      P := PosAfter (SubStr, t, np+1);
      if p<>0 then
        np := p;
    until p=0;
    PosBefore := np;
  End;

Function PosCharSet (C: TCharSet; Const S: String): Integer;
   Var
     P: Byte;
   Begin
     P := 1;
     While (P <= Length (S)) and not (S [P] in C) do
       Inc (P);

     If P <= Length (S) then
       PosCharSet := P
     Else
       PosCharSet := 0;
   End;


{korrigiert: }

Function ReplaceStr (Const OldS, NewS: String; S: String; n: integer): String;
  var
    p, q, c: byte;
  begin
    q := 1;
    c := 1;
    repeat
      p := pos (olds, copy (s, q, 255));
      if p <> 0 then begin
        if (n = 0) or (c = n) then
          begin
            q := q + p - 1;
            delete (s, q, length (olds));
            insert (newS, s, q);
            q := q + length (newS);
          end
        else
          q := p + q + length (oldS) - 1;
        inc (c);
      end;
    until (p = 0) or (p>length (s));
    replaceStr := s;
  end;

(* Dirk's Version:

Function ReplaceStr (Const OldS, NewS: String; S: String; n: integer): String;
  Var
    rp, p, c: byte;
  Begin
    p := 0;
    c := 1;
    repeat
      rp := pos (olds, FromStr (s, p+1));   {Position von OldS im Rest bestimmen}
      if rp <> 0 then
        begin
          if (n = 0) or (c = n) then
            begin
              delete (s, rp+p, length (olds));
              insert (newS, s, rp+p);
              p := p + rp - length (newS)+length (OldS);
            end
          else
            p := p + length (oldS);
          inc (c);
        end;
    until rp = 0;
    replaceStr := s;
  end;

*)

Function ReplaceChar (OldChar, NewChar: Char; Const S: String; N: integer): String;
  Var
    C, I: Integer;
    R: String;

  Begin
    C := 1;
    R := S;

    For I := 1 to Length (S) Do
      If S [I] = OldChar then
        Begin
          If (N = 0) Or (C = N) then
            R [I] := NewChar;

          Inc (C);
        End;

    ReplaceChar := R;
  End;


function PrettyStr (S: String): String;
  var
    big: boolean;
    n: byte;
  begin
    big := true;
    for n := 1 to length (s) do begin
      if s[n] = '_' then s[n] := '-';

      if (s[n] = ' ') or (s[n] = '-') then big := true
      else begin
        if big then begin
          s [n] := UpChar (s[n]);
          big := false;
        end
        else s[n] := lowChar (s[n]);
      end;
    end;
    prettyStr := s;
  end;


Function RightStr (Const S: String; N: Integer): String;
  begin
    rightStr := copy (s, length (s) - n + 1, 255);
  end;

{$IfNDef Speed}
Function Space (n: byte): string; Assembler;
  Asm
    mov al, n
    les di, @result
    stosb
    or al, al
    jz @ende
    cld
    mov cl, al
    mov ch, 0
    mov ax, $2020
    stosb
    dec cx
    shr cx, 1
    rep stosw
    adc cx, cx
    rep stosb
  @ende:
  End;
{$Else}
Function Space (n: byte): string;
  Begin
    Space := CopyChar (' ', n);
  End;
{$EndIf}

function SplitStr(Txt, Pat: string): string;
var
  Match: Boolean;
  ComPos, NextStar, SubPos: Byte;
  Res, SubPat: string;
begin
  Txt := #255 + Txt + #255;
  Pat := #255 + Pat + #255 + '*';
  Res := '';
  Match := True;
  while (Pat <> '') and Match do begin
    NextStar := Pos('*', Pat);
    SubPat := Copy(Pat, 1, NextStar - 1);
    while (NextStar < Length(Pat)) and (Pat[NextStar + 1] = '*') do begin
      Inc(NextStar);
    end;
    SubPos := Pos(SubPat, Txt);
    if SubPos = 0 then Match := False
    else begin
      Res := Res + Copy(Txt, 1, SubPos - 1) + '|';
      Txt := Copy(Txt, SubPos + Length(SubPat), 255);
      Pat := Copy(Pat, NextStar + 1, 255);
    end;
  end;
  Res := Copy(Res, 2, 255);
  if Match then SplitStr := Res else SplitStr := '';
end;


Function StartStr (Const Substr, S: String): Boolean;
  Var
    I: Integer;
  Begin
    StartStr := False;
    If Length (SubStr) > Length (S) then
      Exit;

    I := 1;
    While I <= Length (Substr) do
      If S [I] <> SubStr [I] then
        Exit
      Else
        Inc (I);

    StartStr := True;
  End;


Function Str2FloatUsing (S: String; Const Using: String): Float;
  begin
    Str2FloatUsing := Str2Float (UnFormatNumber (S, Using));
  end;


Function SuperTrimStr (S: String): String;
  Var
    I, J: Integer;
  Begin
    S := AlltrimStr (S);
    I := 2;
    while i+1 < length (S) do  {wg alltrim kann am ende kein ' ' stehen}
      begin
        j := i;
        while ((S[j] = ' ') or (s[j]=#9)) do  {wg alltrim kann am ende kein ' ' stehen}
          Inc (j);

        if j > i+1 then     {1 space lassen   }
          S := Copy (S, 1, i) + Copy (S, j, 255);

        Inc (i);
      end;
    SuperTrimStr := S;
  End;


Function TrimStr (Const S: String): String;
  var
    l: byte;
  begin
    l := length (s);
    while (l > 0) and ((s[l] = ' ') or (s[l]=#9)) do
      Dec (l);
    TrimStr := Copy (S, 1, L);
  end;


Function UnFormatNumber (const s, using: String): String;
  var
    i, j: Integer;
    sep1000, sepDec: Char;
    d: String;
    lsep1000: Integer;

  begin
    Sep1000 := SepThousand;
    SepDec  := SepDecimal;

    If Using = '?' then
      begin
        For I := length (s) downto 1 do
          If s [i] = ',' then
            begin
              Sep1000 := '.';
              SepDec  := ',';
              break;
            end
          else If s[i] = '.' then
            begin
              Sep1000 := ',';
              SepDec  := '.';
              break;
            end;
      end
    else If Using = ',' then
      begin
        SepDec := ',';
        Sep1000 := '.';
      end
    else If Using = '.' then
      begin
        SepDec := '.';
        Sep1000 := ',';
      end;

    j := 1;
    lSep1000 := 0;

    For i := 1 to length (s) do
      if s [i] = sep1000 then
        begin
          If (lsep1000 <> 0) and (i - lsep1000 <> 4) then
            begin
              UnformatNumber := '#SeperatorError!';
              exit;
            end;

          lsep1000 := i;
        end
      else if (s [i] <> ' ') then
        begin
          If s[i] = SepDec then
            begin
              If (lsep1000 <> 0) and (i - lsep1000 <> 4) then
                begin
                  UnformatNumber := '#SeperatorError!';
                  exit;
                end;

              lsep1000 := 0;
              d [j] := '.';
            end
          else
            d [j] := s[i];

          inc (j);
        end;

    If (lsep1000 <> 0) and (i - lsep1000 <> 3) then
      begin
        UnformatNumber := '#SeperatorError!';
        exit;
      end;

    d [0] := char (j-1);

    UnFormatNumber := d;
  end;


Function UpChar (C: Char): Char;
  Begin
    UpChar := _UpXlatTable [Byte (C)];
  End;


{$IfNDef Speed}
Function UpStr (Const S: String): String; Assembler;
  Asm
    les di, s
    push es
    push di
    les di, @result
    push es
    push di
    push seg (_UpXLatTable)
    push offset (_UpXLatTable)
    Call XlatPStr
  End;
{$Else}
Function UpStr (Const S: String): String;
  Var
    D: String;
  Begin
    XLatPStr (@S, @D, @_UpXLatTable);
    UpStr := D;
  End;
{$EndIf}


Procedure Wordwrap (Var S, T: String; w: Integer);
  Var
    i : Integer;
  Begin
    If length (s) < w then
      begin
        t := '';
        exit;
      end;

    for i := w+1 downto 1 do
      if s[i]=' ' then
        Begin
          t := FromStr (s, i+1);
          s := LeftStr (s, i-1);
          exit;
        End;
    t := FromStr (s, w+1);
    s := LeftStr (s, w);
  End;


Function XCutStrByChar (Var S: String; Sep, A, B: Char): String;
 Var
   Cut: Integer;
   L: Byte;
  Begin
    Cut := 0;
    For L := 1 to Length (S) do
      Begin
        If (Cut = 0) AND (S [L] = Sep) then
          Begin
            XCutStrByChar := Copy (S, 1, L - 1);
            S := FromStr (S, L + 1);
            Exit;
          End;
        If S [L] = A then
          If A = B then
            Cut := 1 - Cut
          else
            Inc (Cut)
        else if (S [L] = B) AND (Cut > 0) then
          Dec (Cut);
      End;
    XCutStrByChar := S;
    S := '';
  End;


Procedure XDisposeStr (Var p: pString);
  Begin
    If Assigned (P) And (P <> NullStr) then
      Begin
        FreeMem (p, Ord (p^ [0]) + 1);
        P := NIL;
      End;
  End;

{$IfNDef Speed}
Procedure XlatPStr (S, D: PString; XlatTable: PXlatTable); Assembler;
  Asm
    push ds
    push bp
    lds si, S
    les di, D
    xor cx, cx
    add cl, ds:[si]
    mov es:[di], cl
    jz @ende
    mov dx, ds
    lds bx, XlatTable
    mov bp, ds        (* ab hier dÅrfen param nicht mehr adressiert werden (bp) *)
    inc di
    inc si
    cld
   @loop:
    mov ds, dx
    lodsb
    mov ds, bp
    xlat
    stosb
    loop @loop
   @ende:
    pop bp
    pop ds
  End;
{$Else}
Procedure XlatPStr (S, D: PString; XlatTable: PXlatTable);
  Var
    I: Integer;
  begin
    d^[0] := s^[0];
    For I := 1 to Length (S^) do
      d^ [i] := XLatTable^ [Byte(S^ [i])];
  End;
{$EndIf}

{$IfDef Speed}
Var
  C: Char;

Begin
  For C := #0 to #255 do
    Begin
      _UpXLatTable [Byte(c)] := UpCase (C);

      If (C >= 'A') and (C <= 'Z') then
        _LowXLatTable [Byte(c)] := char (ord (C) - ord ('A') + ord ('a'))
      else
        _LowXLatTable [Byte(c)] := c;
    End;

  _LowXLatTable [Byte('ô')] := 'î';
  _LowXLatTable [Byte('é')] := 'Ñ';
  _LowXLatTable [Byte('ö')] := 'Å';

  _UpXLatTable [Byte('Ñ')] := 'é';
  _UpXLatTable [Byte('î')] := 'ô';
  _UpXLatTable [Byte('Å')] := 'ö';
{$EndIf}
End.

(* Standard XLatTable

    Table: TXlatTable = #00#01#02#03#04#05#06#07#08#09#10#11#12#13#14#15 +
                        #16#17#18#19#20#21#22#23#24#25#26#27#28#29#30#31 +
                        ' !"#$%&'#39'()*+,-./0123456789:;<=>?'           +
                        '@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_'               +
                        '`abcdefghijklmnopqrstuvwxyz{|}~'               +
                        'ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûü'               +
                        '†°¢£§•¶ß®©™´¨≠ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø'               +
                        '¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ'               +
                        '‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘˙˚¸˝˛'#255;

18.12.1995  xReplaceStr eingefÅgt

19.08.1995  IncStr eingefÅgt

*)


