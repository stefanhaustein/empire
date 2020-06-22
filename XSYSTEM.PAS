  {}
  {#F}
 { Verwalter.......: Markus Mathuis}
  {Erstes Datum....: 08.10.1992}
  {Letztes Datum...: 16.04.1996}
  {#F}
  {}

Unit xSystem;

{$IfDef SPEED}
  {$Define ObjPas}
{$Else}
  {$IfDef Ver80}
    {$Define ObjPas}
  {$EndIf}
{$EndIf}

{$IfDef ObjPas}
  {$Define CoPro}
{$Else}
  {$IfOpt N+}
    {$Define CoPro}
  {$EndIf}
{$EndIf}

Interface

{$IfDef SPEED}

Type
  Float = Double;

Const
  MinFloat: Double = 5.0E-324;
  MaxFloat: Double = 1.7E308;

{$Else} {$IfDef CoPro}

Type
  Float = Extended;

Const
  MinFloat: Extended = 3.4E-4932;
  MaxFloat: Extended = 1.1E4932;

{$Else}

Type
  Float = Real;

Const
  MinFloat: Real = 2.9E-39;
  MaxFloat: Real = 1.7E-38;

{$EndIf}
{$EndIf}

Type
  TCharSet = Set of Char;
  {TCharSet ist ein Grundtyp fÅr Mengen von Chars}

Type
  TShortStr = String [31];
  TLineStr  = String [80];

{***************************** Time/Date - Types ****************************}

Type
  pTime = ^TTime;
  {Zeiger auf den Typ #TTime#}

  TTime = LongInt;
  {#X TTimeRec Hour Minute Second Sec100}

Type
  pTimeRec = ^TTimeRec;
  {Zeiger auf den Typ #TTime}

  TTimeRec = Record
   {Record zum einfachen Zugreifen auf ein #TTime# Typ}
    Sec100: Byte;
    Sec: Byte;
    Min: Byte;
    Hour: Byte;
  End;

Type
  pDate = ^TDate;
  {Zeiger auf den Typ #TDate}

  TDate = LongInt;
  {Die Variablen dieses Types enthÑlt ein Datum.
   Dabei wird im hochwertigem Integer das Jahr, im hochwertigem Byte des
   niederwertigen Wort der Monat und im niederwertigen Byte des niederwertigen
   Wortes der Tag gespeichert}
  {#X TDateRec SetDate SysDate Day Month Year}

Type
  pDateRec = ^TDateRec;
  {Zeiger auf den Typ #TDate}

  TDateRec = Record
  {Record zum einfachen Zugreifen auf ein #TDate# Typ}
    Day: Byte;
    Month: Byte;
    Year: Integer;
  End;

Type
  pTimeStamp = ^TTimeStamp;
  TTimeStamp = Record
    Case Byte of
      0:(Time: TTime;
         Date: TDate);
      1:(Sec100, Sec, Min, Hour: Byte;
         Day, Month: Byte;
         Year: Integer);
  End;

Type
  pBoolean = ^Boolean;
  {pBoolean ist ein Zeiger auf einen Typ Boolean}
{$IfDef Ver70}
  pByte = ^Byte;
  {pByte ist ein Zeiger auf einen Typ Byte}
  pString = ^String;
  {pString ist ein Zeiger auf einen String}
{$EndIf}
  pFloat = ^Float;
  {pFloat ist ein Zeiger auf einen Typ Float}
  pInteger = ^Integer;
  {pInteger ist ein Zeiger auf einen Typ Integer}
  pLongInt = ^LongInt;
  {PLongInt ist ein Zeiger auf einen Typ LongInt}
  pPointer = ^Pointer;
  {PPointer ist ein Zeiger auf einen Typ Pointer}
  pReal = ^Real;
  {PReal ist ein Zeiger auf einen Typ Real}
  pShortInt = ^ShortInt;
  {PShortInt ist ein Zeiger auf einen Typ ShortInt}
  pPString = ^pString;
  {pPString ist ein Zeiger auf einen Typ pString}
  pWord = ^Word;
  {PWord ist ein Zeiger auf einen Typ Word}

{$IfDef CoPro}

{$IfNDef SPEED}
  pComp = ^Comp;
  {pComp ist ein Zeiger auf einen Typ Comp. Nur bei Compilerschalter N+
   wirksam}
{$EndIf}
  pDouble = ^Double;
  {pDouble ist ein Zeiger auf einen Typ Double. Nur bei Compilerschalter N+
   wirksam}
  pExtended = ^Extended;
  {pExtended ist ein Zeiger auf einen Typ Extended. Nur bei Compilerschalter
   N+ wirksam}
  pSingle = ^Single;
  {pSingle ist ein Zeiger auf einen Typ Single. Nur bei Compilerschalter N+
   wirksam}

{$EndIf}

{Type conversion records}
Type
  pIntRec = ^IntRec;
  {pIntRec ist ein Zeiger auf einen Typ #IntRec#}
  IntRec = Record
    {IntRec ist ein Record fÅr die Typenkonvertierung}
    Lo: Byte;
    {Lo ist das niederwertige Byte des IntRecs} {#X Hi}
    Hi: Byte;
    {Hi ist das hîherwertige Byte des IntRecs} {#X Lo}
  End;

  pWordRec = ^WordRec;
  {PWordRec ist ein Zeiger auf einen Typ #WordRec#}
  WordRec = Record
    {WordRec ist ein Record fÅr die Typenkonvertierung}
    Lo: Byte;
    {Lo ist das niederwertige Byte des WordRecs} {#X Hi}
    Hi: Byte;
    {Hi ist das hîherwertige Byte des WordRecs} {#X Lo}
  End;

  pLongRec = ^LongRec;
  {PLongRec ist ein Zeiger auf einen Typ #LongRec#}
  LongRec = Record
  {LongRec ist ein Record fÅr die Typenkonvertierung}
    Case Byte of
      0:(Lo: Word;
         {niederwertige Word im LongRec} {#X Hi LoLo LoHi HiLo HiHi}
         Hi: Word
         {hîherwertige Word im LongRec}  {#X Lo LoLo LoHi HiLo HiHi}
         );
      1:(LoLo: Byte;
         {niederwertiges Byte im niederwertigen Word des LongRec}
         LoHi: Byte;
         {hîherwertiges Byte im niederwertigen Word des LongRec}
         HiLo: Byte;
         {niederwertiges Byte im hîherwertigen Word des LongRec}
         HiHi: Byte;)
         {hîherwertiges Byte im hîherwertigen Word des LongRec}
  End;

Type
  pPtrRec  = ^PtrRec;
  {pPtrRec ist ein Zeiger auf einen Typ #PtrRec#}
  PtrRec = Record
  {PtrRec ist ein Record fÅr die Typenkonvertierung}
    Ofs: Word;
    {Ofs gibt die Offsetadresse des PtrRecs an} {#X Seg}
    Seg: Word;
    {Seg gibt die Segmentadresse des PtrRecs an} {#X Ofs}
  End;

Type
  pExtendedRec = ^TExtendedRec;
  TExtendedRec = Record
    Exponent: Integer;
    Negative: Boolean;
    Digits: Array [0..18] of Char;
  end;

{$IfNDef ObjPas}
{$IfDef CoPro}
Type
  pFloatRec = ^TFloatRec;
  TFloatRec = ^TExtendedRec;
{$EndIf}
{$EndIf}

{$IfNDef SPEED}
{$IfDef CoPro}
  pCompRec = ^CompRec;
  {pCompRec ist ein Zeiger auf einen Typ #CompRec#}
  CompRec = Record
  {CompRec ist ein Record fÅr die Typenkonvertierung}
    Lo: LongInt;
    {Lo ist der niederwertige LongInt des CompRecs} {#X Hi}
    Hi: LongInt;
    {Hi ist der hîherwertige LongInt des CompRecs} {#X Lo}
  End;
{$EndIf}
{$EndIf}

Type
  pByteArr = ^TByteArr;
  TByteArr = Array [0..65534] of Byte;

  pCharArr = ^TCharArr;
  TCharArr = Array [0..65534] of Char;

  pIntArr = ^TIntArr;
  TIntArr = Array [0..32766] of Integer;

  pLongArr = ^TLongArr;
  TLongArr = Array [0..16382] of LongInt;

  pStringArr = ^TStringArr;
  TStringArr = Array [0..254] of String;

  pWordArr = ^TWordArr;
  TWordArr = Array [0..32766] of Word;

  pFloatArr = ^TFloatArr;
  TFloatArr = Array [0..6552] of Float;

  pPtrArr = ^TPtrArr;
  TPtrArr = Array [0..16382] of Pointer;

{$IfDef CoPro}
  pDoubleArr = ^TDoubleArr;
  TDoubleArr = Array [0..8190] of Double;

  pExtArr = ^TExtArr;
  TExtArr = Array [0..6552] of Extended;

  pSingleArr = ^TSingleArr;
  TSingleArr = Array [0..16382] of Single;

{$IfNDef SPEED}
  pCompArr = ^TCompArr;
  TCompArr = Array [0..8190] of Comp;
{$EndIf}
{$EndIf}

Const
  Digits = ['0'..'9'];
  {Digits vom Typ #TCharSet# ist die Menge aller Ziffern}
  {#X AllChars HexDigits}
Const
  HexDigits = ['0'..'9', 'A'..'F', 'a'..'f'];
  {Digits vom Typ #TCharSet# ist die Menge aller Hexadezimalziffern}
  {#X AllChars Digits}
Const
  AllChars = [#0..#255];
  {AllChars vom Typ #TCharSet# ist die Menge aller Zeichen}
  {#X Digits HexDitgits}
  FormatErrChar: Char = '#';
  {Dieses Zeichen wird bei Format-Umwandlungsfunktionen benutzt, wenn die
   gewÅnschte LÑnge nicht eingehalten werden kann}

Const
  sepDecimal: Char = '.';
  sepThousand: Char = ',';
  StandardDateFormat: TShortStr = 'DD.MM.YYYY';
  StandardTimeFormat: TShortStr = 'HH:MM:SS';

Const
  MinByte =  0;
  MaxByte =  255;
  (*MinLongInt : LongInt  =  -2147483647; {#X MaxLongInt}
  MinInt     : Integer  =  -32768;      {#X MaxInt}*)
  MinReal    : Real     =  2.9E-39;
  MaxReal    : Real     =  1.7E-38;
  MinShortInt: ShortInt = -127;
  MaxShortInt: ShortInt =  127;
  MinWord =  0;
  MaxWord =  65535;

{$IfDef CoPro}
{$IfNDef SPEED}
  BinComp    : Comp     = -9.2E18;
  MaxComp    : Comp     =  9.2E18;
{$EndIf}
  MinDouble  : Double   =  5.0E-324;
  MaxDouble  : Double   =  1.7E308;
  MinExtended: Extended =  3.4E-4932;
  MaxExtended: Extended =  1.1E4932;
  MinSingle  : Single   =  1.5E-45;
  MaxSingle  : Single   =  3.4E38;
{$EndIf}

Const
  Power2: Array [0..15] of Word =
  {Power2 ist ein konstantes Array mit den Zweierpotenzen von 0 bis 15}
    ($0001, $0002, $0004, $0008,
     $0010, $0020, $0040, $0080,
     $0100, $0200, $0400, $0800,
     $1000, $2000, $4000, $8000);

Const
  HexArr: Array [0..15] of Char = '0123456789ABCDEF';
  {Dieses konstante Array wird zur Umwandlung von Zahlen in die
   Hexadezimalschreibweise benutzt}

Const
  cBoolArr: Array [Boolean] of TShortStr = ('False', 'True');

Type
  TExitProc = Procedure;
  TAlertProc = Function (Title, Text, ButtonStr: String): Integer;
  TGetMsgProc = Function (aUnitID: Word; aMsgID: Integer): String;

Var Alert: TAlertProc;
{LÑ·t eine Box mit dem Titel <Title> und dem Text <Text> auf den Bildschirm
 erscheinen.  Es werden die Knîpfe in <ButtonStr> anzeigt, welche
 dort mit dem Zeichen '|' getrennt werden. RÅckgabewert ist die Nummer des
 gedrÅckten Knopfes. Die Taste ØENTERÆ gibt 1 zurÅck und der Taste ØESCÆ gibt
 die Nummer des hîchsten Knopfes zurÅck. Die Funktion kann Åberschrieben
 werden}
{#X AlertTitel Info Fatal Retry Warning Debug}
Function AlertTitle (Const S: String): String;
{<S> = '?' wird zu "BestÑtigen", '!' wird zu "Warnung" , '*' wird zu
 "Fataler Fehler" und 'I' wird zu "Information". Sonst ist die RÅckgabe <S>}
{$IfDef SPEED}
Function Assigned (Var P: Pointer): Boolean;
{$EndIf}
Function BCD2Byte (BCD: Byte): Byte;
  {$IfNDef SPEED}
  Inline ($58/$88/$C4/$C0/$EC/$04/$24/$0F/$D5/$0A);
  {$EndIf}
{Die Funktion wandelt eine BCD-Kodierte Zahl in ein Byte} {#X Byte2BCD}
Var      Bell: Procedure;  { War: Beep }
{Bell erzeugt einen Ton. Die Procedure kann Åberschriebern werden, um den Ton
 z.B. Åber eine Sound-Karte erklingen zu lassen}
Function BiggerByte (A, B: Byte): Byte;
  {$IfNDef SPEED}
  InLine ($58/$5B/$38/$D8/$77/$02/$88/$D8);
  {$EndIf}
{Die Funktion liefert das grî·ere Byte von <A> oder <B> zurÅck}
{#X SmallerByte}
Function BiggerChar (A, B: Char): Char;
  {$IfNDef SPEED}
  InLine ($58/$5B/$38/$D8/$77/$02/$88/$D8);
  {$EndIf}
{Die Funktion liefert den grî·eren Char von <A> oder <B> zurÅck}
{#X SmallerChar}
Function BiggerInt (A, B: Integer): Integer;
  {$IfNDef SPEED}
  InLine ($58/$5B/$39/$D8/$7F/$02/$89/$D8);
  {$EndIf}
{Die Funktion liefert den grî·eren Integer von <A> oder <B> zurÅck}
{#X SmallerInt}
Function BiggerLong (A, B: LongInt): LongInt;
{Die Funktion liefert den grî·eren LongInt von <A> oder <B> zurÅck}
{#X SmallerLong}
Function BiggerFloat (A, B: Float): Float;
Function BiggerShort (A, B: ShortInt): ShortInt;
  {$IfNDef SPEED}
  InLine ($58/$5B/$38/$D8/$7F/$02/$88/$D8);
  {$EndIf}
{Die Funktion liefert den grî·eren ShortInt von <A> oder <B> zurÅck}
{#X SmallerShort}
Function BiggerStr (Const A, B: String): String;
{Die Funktion liefert den grî·eren String von <A> oder <B> zurÅck}
{#X SmallerStr}
Function BiggerWord (A, B: Word): Word;
  {$IfNDef SPEED}
  InLine ($58/$5B/$39/$D8/$77/$02/$89/$D8);
  {$EndIf}
{Die Funktion liefert das grî·ere Word von <A> oder <B> zurÅck}
{#X SmallerWord}
Function Bin2Byte (Const S: String): Byte;
{Die Funktion wandelt eine BinÑrzahl (als String gespeichert) in ein Byte)
{#X Byte2Bin Bin2Int Bin2Long Bin2Short Bin2Word}
Function Bin2Int (Const S: String): Integer;
{Die Funktion wandelt eine BinÑrzahl (als String gespeichert) in einen
 Integer}
{#X Int2Bin Bin2Byte Bin2Long Bin2Short Bin2Word}
Function Bin2Long (S: String): LongInt;
{Die Funktion wandelt eine BinÑrzahl (als String gespeichert) in einen
 LongInt}
{#X Long2Bin Bin2Byte Bin2Int Bin2Short Bin2Word}
Function Bin2Short (Const S: String): ShortInt;
{Die Funktion wandelt eine BinÑrzahl (als String gespeichert) in einen
 ShortInt}
{#X Short2Bin Bin2Byte Bin2Int Bin2Long Bin2Word}
Function Bin2Word (Const S: String): Word;
{Die Funktion wandelt eine BinÑrzahl (als String gespeichert) in eine Word}
{#X Word2Bin Bin2Byte Bin2Int Bin2Long Bin2Short}
Function Bool2Str (B: Boolean): String;
{Liefert #cBoolArr# [<B>] zurÅck}
{#X Str2Bool}
Function Byte2BCD (B: Byte): Byte;
  {$IfNDef SPEED}
  Inline ($58/$D4/$0A/$C0/$E4/$04/$08/$E0);
  {$EndIf}
{Die Funktion wandelt ein Byte in eine BCD-Kodierte Zahl}
{#X BCD2Byte Byte2Bin Byte2Char Byte2Hex Byte2Str}
Function Byte2Bin (B: Byte; N: Integer): String;
{Die Funktion wandelt ein Byte <B> in eine BinÑrzahl (als String gespeichert).
 Der Absolutwert von <N> gibt die Anzahl der Stellen an, wobei ein negatives
 <N> fÅhrende Nullen erzeugt. Bei <N> = 0 bekommt der String die minimale
 LÑnge}
{#X Bin2Byte Byte2BCD Byte2Char Byte2Hex Byte2Str}
Function Byte2Char (B: Byte): Char;
  {$IfNDef SPEED}
  InLine ($58/$04/$30);
  {$EndIf}
{Die Funktion wandelt ein Byte <B> in ein Char. Zu Beachten ist, das aus
 <B> = 0 der Char '0', also NICHT #0 wird}
{#X Char2Byte Byte2BCD Byte2Bin Byte2Hex Byte2Str}
Function Byte2Hex (B: Byte; N: Integer): String;
{Die Funktion wandelt ein Byte <B> in eine Hexadezimalzahl (als String
 gespeichert). Der Absolutwert von <N> gibt die Anzahl der Stellen an,
 wobei ein negatives <N> fÅhrende Nullen erzeugt. Bei <N> = 0 bekommt der
 String die minimale LÑnge}
{#X Hex2Byte Byte2BCD Byte2Bin Byte2Char Byte2Str}
Function Byte2Str (B: Byte; N: Integer): String;
{Die Funktion wandelt ein Byte <B> in ein String. Der Absolutwert von <N>
 gibt die Anzahl der Stellen an, wobei ein negatives <N> fÅhrende Nullen
 erzeugt. Bei <N> = 0 bekommt der String die minimale LÑnge}
{#X Str2Byte Byte2BCD Byte2Bin Byte2Char Byte2Hex Byte2Str}
Function Char2Byte (C: Char): Byte;
  {$IfNDef SPEED}
  InLine ($58/$2C/$30);
  {$EndIf}
{Die Funktion wandelt ein Char <C> in ein Byte. Zu Beachten ist, das aus
 <C> = '0' das Byte 0, also NICHT Ord (C) wird}
{#X Byte2Char}
Procedure ClearBit (Var W: Word; Bit: Byte);
{Die Procedure lîscht das Bit <Bit> aus dem Word <W>}
{#X SetBit GetBit ToggelBit ClearFlag}
Procedure ClearFlag (Var W: Word; Flags: Word);
{Die Procedure lîscht die Flags <Flags> aus dem Word <W>}
{#X GetFlag SetFlag ToggleFlag ClearBit}
Function CompareByte (A, B: Byte): Integer;
{Die Funktion vergleicht die Bytes <A> und <B>. Ist <A> grîsser als <B>,
 dann ist das Ergebnis 1, ist <A> kleiner als <B>, dann ist das Ergebnis -1,
 sonst 0 (also <A> gleich <B>)}
{#X BiggerByte SmallerByte}
Function CompareChar (A, B: Char): Integer;
{Die Funktion vergleicht die Chars <A> und <B>. Ist <A> grîsser als <B>,
 dann ist das Ergebnis 1, ist <A> kleiner als <B>, dann ist das Ergebnis -1,
 sonst 0 (also <A> gleich <B>)}
{#X BiggerChar SmallerChar}
Function CompareFloat (A, B: Float): Integer;
{Die Funktion vergleicht die Floats <A> und <B>. Ist <A> grîsser als <B>,
 dann ist das Ergebnis 1, ist <A> kleiner als <B>, dann ist das Ergebnis -1,
 sonst 0 (also <A> gleich <B>)}
{#X BiggerFloat SmallerFloat}
Function CompareInt (A, B: Integer): Integer;
{Die Funktion vergleicht die Integer <A> und <B>. Ist <A> grîsser als <B>,
 dann ist das Ergebnis 1, ist <A> kleiner als <B>, dann ist das Ergebnis -1,
 sonst 0 (also <A> gleich <B>)}
{#X BiggerInt SmallerInt}
Function CompareLong (A, B: LongInt): Integer;
{Die Funktion vergleicht die LongInts <A> und <B>. Ist <A> grîsser als <B>,
 dann ist das Ergebnis 1, ist <A> kleiner als <B>, dann ist das Ergebnis -1,
 sonst 0 (also <A> gleich <B>)}
{#X BiggerLong SmallerLong}
Function CompareReal (A, B: Real): Integer;
{Die Funktion vergleicht die Realzahlen <A> und <B>. Ist <A> grîsser als <B>,
 dann ist das Ergebnis 1, ist <A> kleiner als <B>, dann ist das Ergebnis -1,
 sonst 0 (also <A> gleich <B>)}
{#X BiggerReal SmallerReal}
Function CompareShort (A, B: ShortInt): Integer;
{Die Funktion vergleicht die ShortInts <A> und <B>. Ist <A> grîsser als <B>,
 dann ist das Ergebnis 1, ist <A> kleiner als <B>, dann ist das Ergebnis -1,
 sonst 0 (also <A> gleich <B>)}
{#X BiggerShort SmallerShort}
Function CompareStr (Const A, B: String): Integer;
{Die Funktion vergleicht die Strings <A> und <B>. Ist <A> grîsser als <B>,
 dann ist das Ergebnis 1, ist <A> kleiner als <B>, dann ist das Ergebnis -1,
 sonst 0 (also <A> gleich <B>)}
{#X BiggerStr MinStr}
{Function CompareVar (Const A, B; Count: Word): Integer;}
Function CompareVar (Var A, B; Count: Word): Integer;
{Die Funktion vergleicht die Varparameter <A> und <B> in der LÑnge <Count>
 Byteweise. Ist <A> grîsser als <B>, dann ist das Ergebnis 1, ist <A> kleiner
 als <B>, dann ist das Ergebnis -1, sonst 0 (also <A> gleich <B>)}
{#X IsEqualVar}
Function CompareWord (A, B: Word): Integer;
{Die Funktion vergleicht die Words <A> und <B>. Ist <A> grîsser als <B>,
 dann ist das Ergebnis 1, ist <A> kleiner als <B>, dann ist das Ergebnis -1,
 sonst 0 (also <A> gleich <B>)}
{#X BiggerWord SmallerWord}
Procedure Debug (Const S: String);
{Nur fÅr Debugzwecke. Ruft #Alert# mit Titel 'Debug', Text <S> + 'F:B' und
 Button ØOkÆ nur bei Compierschalter #$R+# auf}
{#X Info Fatal Warning Retry}
Function DiffByte (A, B: Byte): Byte;
{Die Funktion gibt die Differenz zwischen <A> und <B> zurÅck}
{#X SmallerByte BiggerByte}
Function DiffFloat (A, B: Float): Float;
{Die Funktion gibt die Differenz zwischen <A> und <B> zurÅck}
{#X SmallerFloat BiggerFloat}
Function DiffInt (A, B: Integer): Integer;
{Die Funktion gibt die Differenz zwischen <A> und <B> zurÅck}
{#X SmallerInt BiggerInt}
Function DiffLong (A, B: LongInt): LongInt;
{Die Funktion gibt die Differenz zwischen <A> und <B> zurÅck}
{#X SmallerLong BiggerLong}
Function DiffReal (A, B: Real): Real;
{Die Funktion gibt die Differenz zwischen <A> und <B> zurÅck}
{#X SmallerReal BiggerReal}
Function DiffShort (A, B: ShortInt): ShortInt;
{Die Funktion gibt die Differenz zwischen <A> und <B> zurÅck}
{#X SmallerShort BiggerShort}
Function DiffWord (A, B: Word): Word;
{Die Funktion gibt die Differenz zwischen <A> und <B> zurÅck}
{#X SmallerWord BiggerWord}
Procedure DisableInterrupt; {$IfNDef SPEED} InLine ($FA); {$EndIf}
{Die Procedure schaltet die Interrupt-Unterbrechung des Prozessors aus}
{# EnableInterrupt}
Procedure DisposePChar (Var P: PChar);
{Gibt einen PChar wieder frei}
Procedure EnableInterrupt; {$IfNDef SPEED} InLine ($FB); {$EndIf}
{Die Procedure schaltet die Interrupt-Unterbrechung des Prozessors ein}
{# DisableInterrupt}
Procedure Fatal (Const S: String);
{Ruft #Alert# mit dem Titel 'Fataler Fehler', dem Text <S> + '|LOG|F:B'
 und dem Button ØOkÆ auf, und beendet das Programm mit dem Exitcode 255}
{#X Info Retry Warning Debug}
Procedure FillWord (Var Dest; Count, Value: Word);
{Arbeitet genau wie #FillChar#, nur das Wortweise mit <Value> aufgefÅllt wird}
Function Float2Str (F: Float; St: Integer; Nk: Byte): String;
{Die Funktion wandelt einen Float <F> in einen String. Der Absolutwert von
 <St> gibt die Anzahl der Stellen an, wobei ein negatives <St> fÅhrende Nullen
 erzeugt. Bei <St> = 0 bekommt der String die minimale LÑnge. Nk gibt die
 Anzahl der Nachkommastellen an}
Function ForceByte (B, Min, Max: Byte): Byte;
  {$IfNDef SPEED}
  InLine ($5B/$5A/$58/$38/$D8/$72/$04/$88/$D8/$EB/$06/$38/$D0/$77/$02/$88/$D0);
  {$EndIf}
{Die Funktion liefert das in den Grenzen <Min> und <Max> gebrachte Byte <B>
 zurÅck}
{#X SmallerByte BiggerByte InRangeByte SortByte}

Function ForceChar (C, Min, Max: Char): Char;
  {$IfNDef SPEED}
  InLine ($5B/$5A/$58/$38/$D8/$72/$04/$88/$D8/$EB/$06/$38/$D0/$77/$02/$88/$D0);
  {$EndIf}
{Die Funktion liefert den in den Grenzen <Min> und <Max> gebrachte Char <C>
 zurÅck}
{#X SmallerChar BiggerChar InRangeChar SortChar}
Function ForceInt (I, Min, Max: Integer): Integer;
  {$IfNDef SPEED}
  InLine ($5B/$5A/$58/$39/$D8/$7C/$04/$89/$D8/$EB/$06/$39/$D0/$7F/$02/$89/$D0);
  {$EndIf}
{Die Funktion liefert den in den Grenzen <Min> und <Max> gebrachten Integer
 <I> zurÅck}
{#X SmallerInt BiggerInt InRangeInt SortInt}
Function ForceLong (L, Min, Max: LongInt): LongInt;
{Die Funktion liefert den in den Grenzen <Min> und <Max> gebrachten LongInt
 <L> zurÅck}
{#X SmallerLong BiggerLong InRangeLong SortLong}
Function ForceReal (R, Min, Max: Real): Real;
{Die Funktion liefert den in den Grenzen <Min> und <Max> gebrachten Realwert
 <R> zurÅck}
{#X SmallerReal BiggerReal InRangeReal SortReal}
Function ForceShort (Sh, Min, Max: ShortInt): ShortInt;
  {$IfNDef SPEED}
  InLine ($5B/$5A/$58/$38/$D8/$7C/$04/$88/$D8/$EB/$06/$38/$D0/$7F/$02/$88/$D0);
  {$EndIf}
{Die Funktion liefert den in den Grenzen <Min> und <Max> gebrachten ShortInt
 <Sh> zurÅck}
{#X SmallerShort MaxShort InRangeShort SortShort}
Function ForceStr (Const S, Min, Max: String): String;
{Die Funktion liefert den in den Grenzen <Min> und <Max> gebrachten String <S>
 zurÅck}
{#X SmallerStr BiggerStr InRangeStr SortStr}
Function ForceWord (W, Min, Max: Word): Word;
  {$IfNDef SPEED}
  InLine ($5B/$5A/$58/$39/$D8/$72/$04/$89/$D8/$EB/$06/$39/$D0/$77/$02/$89/$D0);
  {$EndIf}
{Die Funktion liefert das in den Grenzen <Min> und <Max> gebrachte Word <W>
 zurÅck}
{#X SmallerWord MaxWord InRangeWord SortWord}
Function GetBit (W: Word; Bit: Byte): Boolean;
  {$IfNDef SPEED}
  InLine ($59/$5B/$B8/$01/$00/$D3/$E0/$21/$D8/$74/$02/$B0/$01);
  {$EndIf}
{GetBit liefert nur dann TRUE, wenn im Word <W> das Bit <Bit> gesetzt ist}
{#X ClearBit SetBit ToggelBit ClearFlag}
Function GetFlag (W, Flags: Word): Boolean;
{GetFlag liefert nur dann TRUE, wenn im Word <W> die Flags <Flags> gesetzt
 sind}
{#X ClearFlag SetFlag ToggleFlag GetFlagLong GetBit}
Var      GetMsg: TGetMsgProc;
{Abstrakte Prozedur. Liefert hier nur <aUnitID> und <aMsgID> als String
 zurÅck. Sinnvoll im zusammenspiel mit der Unit #XMessage#}
Function Hex2Byte (Const S: String): Byte;
{Die Funktion wandelt eine Hexadezimalzahl (als String gespeichert) in ein
 Byte}
{#X Byte2Hex Hex2Int Hex2Long Hex2Short Hex2Var Hex2Word}
Function Hex2Int (Const S: String): Integer;
{Die Funktion wandelt eine Hexadezimalzahl (als String gespeichert) in einen
 Integer}
{#X Int2Hex Hex2Byte Hex2Long Hex2Short Hex2Var Hex2Word}
Function Hex2Long (Const S: String): LongInt;
{Die Funktion wandelt eine Hexadezimalzahl (als String gespeichert) in einen
 LongInt}
{#X Long2Hex Hex2Byte Hex2Int Hex2Short Hex2Var Hex2Word}
Function Hex2Short (Const S: String): ShortInt;
{Die Funktion wandelt eine Hexadezimalzahl (als String gespeichert) in einen
 ShortInt}
{#X Short2Hex Hex2Byte Hex2Int Hex2Long Hex2Short Hex2Var Hex2Word}
Function Hex2Var (Const Hex: String; Var Arr): Boolean;
{Die Funktion wandelt eine Hexadezimalzahl (als String gespeichert) in ein
 Varparameter. Seperatoren wie '$' weden Åberlesen}
{#X Var2Hex Hex2Byte Hex2Int Hex2Long Hex2Short Hex2Word}
Function Hex2Word (Const S: String): Word;
{Die Funktion wandelt eine Hexadezimalzahl (als String gespeichert) in ein
 Word}
{#X Word2Hex Hex2Byte Hex2Int Hex2Long Hex2Short Hex2Var}
Function IfByte (C: Boolean; T, F: Byte): Byte;
{Ist die Bedingung <C> wahr, so wird das Byte <T>, ansonsten das Byte <F>
 zurÅckgeliefert}
Function IfChar (C: Boolean; T, F: Char): Char;
{Ist die Bedingung <C> wahr, so wird der Char <T>, ansonsten der Char <F>
 zurÅckgeliefert}
Function IfFloat (C: Boolean; T, F: Float): Float;
{Ist die Bedingung <C> wahr, so wird der Float <T>, ansonsten der Float <F>
 zurÅckgeliefert}
Function IfInt (C: Boolean; T, F: Integer): Integer;
{Ist die Bedingung <C> wahr, so wird der Integer <T>, ansonsten der Integer <F>
 zurÅckgeliefert}
Function IfLong (C: Boolean; T, F: LongInt): LongInt;
{Ist die Bedingung <C> wahr, so wird der LongInt <T>, ansonsten der LongInt <F>
 zurÅckgeliefert}
Function IfPtr (C: Boolean; T, F: Pointer): Pointer;
{Ist die Bedingung <C> wahr, so wird der Pointer <T>, ansonsten der Pointer <F>
 zurÅckgeliefert}
Function IfReal (C: Boolean; T, F: Real): Real;
{Ist die Bedingung <C> wahr, so wird die Realzahl <T>, ansonsten die Realzahl
 <F> zurÅckgeliefert}
Function IfShort (C: Boolean; T, F: ShortInt): ShortInt;
{Ist die Bedingung <C> wahr, so wird der ShortInt <T>, ansonsten der ShortInt
 <F> zurÅckgeliefert}
Function IfStr (C: Boolean; Const T, F: String): String;
{Ist die Bedingung <C> wahr, so wird der String <T>, ansonsten der String <F>
 zurÅckgeliefert}
Function IfWord (C: Boolean; T, F: Word): Word;
{Ist die Bedingung <C> wahr, so wird das Word <T>, ansonsten das Word <F>
 zurÅckgeliefert}
Procedure Info (Const S: String);
{Gibt den Text S mit Hilfe von #Alert# aus und wartet auf Return}
Function InRangeByte (A, Min, Max: Byte): Boolean;
  {$IfNDef SPEED}
  InLine ($5B/$5A/$59/$B8/1/0/$38/$D9/$76/3/$48/$EB/5/$38/$D1/$73/1/$48);
  {$EndIf}
{Die Funktion liefert TRUE zurÅck, wenn das Byte <A> (einschlie·lich)
 zwischen <Min> und <Max> liegt, sonst FALSE}
{#X SmallerByte BiggerByte ForceByte SortByte}
Function InRangeInt (A, Min, Max: Integer): Boolean;
  {$IfNDef SPEED}
  InLine ($5B/$5A/$59/$B8/1/0/$39/$D9/$7E/3/$48/$EB/5/$39/$D1/$7D/1/$48);
  {$EndIf}
{Die Funktion liefert TRUE zurÅck, wenn der Integer <A> (einschlie·lich)
 zwischen <Min> und <Max> liegt, sonst FALSE}
{#X SmallerInt BiggerInt ForceInt SortInt}
Function InRangeLong (A, Min, Max: LongInt): Boolean;
{Die Funktion liefert TRUE zurÅck, wenn der LongInt <A> (einschlie·lich)
 zwischen <Min> und <Max> liegt, sonst FALSE}
{#X SmallerLong BiggerLong ForceLong SortLong}

Function InRangeFloat (A, Min, Max: Float): Boolean;

Function InRangeReal (A, Min, Max: Real): Boolean;
{Die Funktion liefert TRUE zurÅck, wenn die Realzahl <A> (einschlie·lich)
 zwischen <Min> und <Max> liegt, sonst FALSE}
{#X SmallerReal BiggerReal ForceReal SortReal}
Function InRangeShort (A, Min, Max: ShortInt): Boolean;
  {$IfNDef SPEED}
  InLine ($5B/$5A/$59/$B8/$01/$00/$38/$D9/$7E/$03/$48/$EB/$05/$38/$D1/$7D/$01/$48);
  {$EndIf}
{Die Funktion liefert TRUE zurÅck, wenn der ShortInt <A> (einschlie·lich)
 zwischen <Min> und <Max> liegt, sonst FALSE}
{#X SmallerShort MaxShort ForceShort SortShort}
Function InRangeStr (Const A, Min, Max: String): Boolean;
{Die Funktion liefert TRUE zurÅck, wenn die Realzahl <A> (einschlie·lich)
 zwischen <Min> und <Max> liegt, sonst FALSE}
{#X SmallerStr BiggerStr ForceStr SortStr}
Function InRangeWord (A, Min, Max: Word): Boolean;
  {$IfNDef SPEED}
  InLine ($5B/$5A/$59/$B8/1/0/$39/$D9/$76/3/$48/$EB/5/$39/$D1/$73/1/$48);
  {$EndIf}
{Die Funktion liefert TRUE zurÅck, wenn das Word <A> (einschlie·lich)
 zwischen <Min> und <Max> liegt, sonst FALSE}
{#X SmallerWord BiggerWord ForceWord SortWord}
Function Int2Bin (I, N: Integer): String;
{Die Funktion wandelt ein Integer <I> in eine BinÑrzahl (als String
 gespeichert). Der Absolutwert von <N> gibt die Anzahl der Stellen an, wobei
 ein negatives <N> fÅhrende Nullen erzeugt. Bei <N> = 0 bekommt der String
 die minimale LÑnge}
{#X Bin2Int Int2Hex Int2Str}
Function Int2Hex (I, N: Integer): String;
{Die Funktion wandelt einen Integer <I> in einen Hexadezimalzahl (als String
 gespeichert). Der Absolutwert von <N> gibt die Anzahl der Stellen an, wobei
 ein negatives <N> fÅhrende Nullen erzeugt. Bei <N> = 0 bekommt der String
 die minimale LÑnge}
{#X Hex2Int Int2Bin Int2Str}
Function Int2Str (I, N: Integer): String;
{Der Absolutwert von <N> gibt die Anzahl der Stellen an, wobei ein negatives
 <N> fÅhrende Nullen erzeugt. Bei <N> = 0 bekommt der String die minimale
 LÑnge}
Function IsEqualVar (Var A, B; Count: Word): Boolean;
{IsEqualVar liefert nur dann TRUE zurÅck, wenn die Varparameter <A> und <B>
 <Count>-Stellen gleich sind}
{#X CompareVar}
Function Long2Bin (L: Longint; N: Integer): String;
{Die Funktion wandelt ein LongInt <I> in eine BinÑrzahl (als String
 gespeichert). Der Absolutwert von <N> gibt die Anzahl der Stellen an, wobei
 ein negatives <N> fÅhrende Nullen erzeugt. Bei <N> = 0 bekommt der String
 die minimale LÑnge}
{#X Bin2Long LLong2Hex Long2Str}
Function Long2Hex (L: Longint; N: Integer): String;
{Die Funktion wandelt einen LongInt <L> in einen Hexadezimalzahl (als String
 gespeichert). Der Absolutwert von <N> gibt die Anzahl der Stellen an, wobei
 ein negatives <N> fÅhrende Nullen erzeugt. Bei <N> = 0 bekommt der String
 die minimale LÑnge}
{#X Hex2Long Long2Bin Long2Str}
Function Long2Str (L: Longint; N: Integer): String;
{Die Funktion wandelt einen LongInt <L> in einen String. Der Absolutwert von
 <N> gibt die Anzahl der Stellen an, wobei ein negatives <N> fÅhrende Nullen
 erzeugt. Bei <N> = 0 bekommt der String die minimale LÑnge}
{#X Str2Long Long2Bin Long2Hex}
Function PChar2Str (P: PChar): String;
{Konvertiert den PChar <P> in einen String. Achtung: Hîchstens 255 Zeichen
 kînnen konvertiert werden!}
Function Ptr2Str (P: Pointer): String;
{Ptr2Str wandelt den Pointer <P> in einen String der Form 'SSSS:OOOO', wobei
 die SSSS's das Segment und die OOOO's den Ofset angeben. Zeigt der Pointer
 auf NIL, wird jedoch 'NIL' zurÅckgegeben}
{#X Str2Ptr}
Function Real2Str (R: Real; St: Integer; Nk: Byte): String;
{Die Funktion wandelt eine Realzahl <R> in einen String. Der Absolutwert von
 <St> gibt die Anzahl der Stellen an, wobei ein negatives <St> fÅhrende Nullen
 erzeugt. Bei <St> = 0 bekommt der String die minimale LÑnge. Nk gibt die
 Anzahl der Nachkommastellen an}
Procedure ReAlloc (Var P: Pointer; OldSize, At, Count: Word);
{Allokiert p neu mit der Grî·e <OldSize> + <Count> neu und fÅgt bei <at>
 <Count> Nullbytes ein. Der alte Speicherberecheich wird kopiert und
 freigegeben}
Function Retry (Const S: String): Boolean;
{Ruft #Alert# mit Titel "Bitte BestÑtigen", dem Text <S> + '|F:B'
 und den Buttons 'Ja|Nein' auf. RÅckgabewert: "Ja" wurde gedrÅckt}
{#X Info Fatal Warning Debug}
Function ROLWord (W: Word; N: Byte): Word;
  {$IfNDef SPEED}
  Inline ($59/$58/$D3/$C0);
  {$EndIf}
{Das Word <W> wird bitweise um <N> Stellen nach links rotiert}
{#X RORWord}
Function RORWord (W: Word; N: Byte): Word;
  {$IfNDef SPEED}
  Inline ($59/$58/$D3/$C8);
  {$EndIf}
{Das Word <W> wird bitweise um <N> Stellen nach rechts rotiert}
{#X ROLWord}
Procedure SetBit (Var W: Word; Bit: Byte);
{SetBit setzt im Word <W> das Bit <Bit>}
{#X ClearBit GetBit ToggelBit SetFlag}
Procedure SetFlag (Var W: Word; Flags: Word);
  {$IfNDef SPEED}
  InLine ($58/$5F/$07/$26/$09/$05);
  {$EndIf}
{SetFlag setzt im Word <W> die Flags <Flags>}
{#X ClearFlag GetFlag ToggleFlag SetBit}
Function SgnFloat (F: Float): Integer;

Function SgnInt (I: Integer): Integer;
  {$IfNDef SPEED}
  Inline ($58/$09/$C0/$74/$0A/$78/$05/$B8/$01/$00/$EB/$03/$B8/$FFFF);
  {$EndIf}
{Die Funktion liefert bei negativem <I> eine -1, bei positiven <I> eine 1 und
 bei <I> = 0 eine 0 zurÅck}
Function SgnLong (L: LongInt): Integer;
{Die Funktion liefert bei negativem <L> eine -1, bei positiven <L> eine 1 und
 bei <L> = 0 eine 0 zurÅck}
Function SgnReal (R: Real): Integer;
{Die Funktion liefert bei negativem <R> eine -1, bei positiven <R> eine 1 und
 bei <R> = 0 eine 0 zurÅck}
Function SgnShort (Sh: ShortInt): Integer;
{Die Funktion liefert bei negativem <Sh> eine -1, bei positiven <Sh> eine 1
 und bei <Sh> = 0 eine 0 zurÅck}
Function Short2Bin (Sh: ShortInt; N: Integer): String;
{Die Funktion wandelt ein ShortInt <Sh> in eine BinÑrzahl (als String
 gespeichert). Der Absolutwert von <N> gibt die Anzahl der Stellen an, wobei
 ein negatives <N> fÅhrende Nullen erzeugt. Bei <N> = 0 bekommt der String
 die minimale LÑnge}
{#X Bin2Short Short2Hex Short2Str}
Function Short2Hex (Sh: ShortInt; N: Integer): String;
{Die Funktion wandelt einen ShortInt <Sh> in einen Hexadezimalzahl (als String
 gespeichert). Der Absolutwert von <N> gibt die Anzahl der Stellen an, wobei
 ein negatives <N> fÅhrende Nullen erzeugt. Bei <N> = 0 bekommt der String
 die minimale LÑnge}
{#X Hex2Short Short2BCD Short2Bin Short2Char Short2Str}
Function Short2Str (Sh: ShortInt; N: Integer): String;
{Die Funktion wandelt einen ShortInt <Sh> in einen String. Der Absolutwert von
 <N> gibt die Anzahl der Stellen an, wobei ein negatives <N> fÅhrende Nullen
 erzeugt. Bei <N> = 0 bekommt der String die minimale LÑnge}
{#X Str2Short Short2BCD Short2Bin Short2Char Short2Hex}
Function SmallerByte (A, B: Byte): Byte;
  {$IfNDef SPEED}
  InLine ($58/$5B/$38/$D8/$72/$02/$88/$D8);
  {$EndIf}
{Die Funktion liefert das kleinere Byte von <A> oder <B> zurÅck}
{#X BiggerByte}
Function SmallerChar (A, B: Char): Char;
  {$IfNDef SPEED}
  InLine ($58/$5B/$38/$D8/$72/$02/$88/$D8);
  {$EndIf}
{Die Funktion liefert den kleineren Char von <A> oder <B> zurÅck}
{#X BiggerChar}
Function SmallerFloat (A, B: Float): Float;

Function SmallerInt (A, B: Integer): Integer;
  {$IfNDef SPEED}
  InLine ($58/$5B/$39/$D8/$7C/$02/$89/$D8);
  {$EndIf}
{Die Funktion liefert den kleineren Integer von <A> oder <B> zurÅck}
{#X BiggerInt}
Function SmallerLong (A, B: LongInt): LongInt;
{Die Funktion liefert den kleineren LongInt von <A> oder <B> zurÅck}
{#X BiggerLong}
Function SmallerShort (A, B: ShortInt): ShortInt;
  {$IfNDef SPEED}
  InLine ($58/$5B/$38/$D8/$7C/$02/$88/$D8);
  {$EndIf}
{Die Funktion liefert den kleineren ShortInt von <A> oder <B> zurÅck}
{#X BiggerShort}
Function SmallerStr (Const A, B: String): String;
{Die Funktion liefert den kleineren String von <A> oder <B> zurÅck}
{#X BiggerString}
Function SmallerWord (A, B: Word): Word;
  {$IfNDef SPEED}
  InLine ($58/$5B/$39/$D8/$72/$02/$89/$D8);
  {$EndIf}
{Die Funktion liefert das kleinere Word von <A> oder <B> zurÅck}
{#X BiggerWord}
Procedure SortByte (Var A, B: Byte);
{Die Variablen <A> und <B> weden nach Grî·e sortiert, so da· in <A> das
 kleinere und in <B> das grî·ere Byte steht}
{#X SmallerByte BiggerByte  ForceByte InRangeByte}
Procedure SortChar (Var A, B: Char);
{Die Variablen <A> und <B> weden nach Grî·e sortiert, so da· in <A> der
 kleinere und in <B> der grî·ere Char steht}
{#X SmallerChar BiggerChar  ForceChar InRangeChar}
Procedure SortInt (Var A, B: Integer);
{Die Variablen <A> und <B> weden nach Grî·e sortiert, so da· in <A> der
 kleinere und in <B> der grî·ere Integer steht}
{#X SmallerInt BiggerInt  ForceInt InRangeInt}
Procedure SortLong (Var A, B: LongInt);
{Die Variablen <A> und <B> weden nach Grî·e sortiert, so da· in <A> der
 kleinere und in <B> der grî·ere LongInt steht}
{#X SmallerLong BiggerLong  ForceLong InRangeLong}
Procedure SortReal (Var A, B: Real);
{Die Variablen <A> und <B> weden nach Grî·e sortiert, so da· in <A> die
 kleinere und in <B> die grî·ere Realzahl steht}
{#X SmallerReal BiggerReal  ForceReal InRangeReal}
Procedure SortShort (Var A, B: ShortInt);
{Die Variablen <A> und <B> weden nach Grî·e sortiert, so da· in <A> der
 kleinere und in <B> der grî·ere ShortInt steht}
{#X SmallerShort BiggerShort  ForceShort InRangeShort}
Procedure SortStr (Var A, B: String);
{Die Variablen <A> und <B> weden nach Grî·e sortiert, so da· in <A> der
 kleinere und in <B> der grî·ere String steht}
{#X SmallerStr BiggerStr  ForceStr InRangeStr}
Procedure SortWord (Var A, B: Word);
{Die Variablen <A> und <B> weden nach Grî·e sortiert, so da· in <A> das
 kleinere und in <B> das grî·ere Byte steht}
{#X SmallerByte BiggerByte  ForceByte InRangeByte}
Function Str2Bool (Const S: String): Boolean;
{Liefert, wenn S = #cBoolArr# [True] oder S [1] in
 ['J', 'j', 'T', 't', '1', 'W', 'w'] ist, True zurÅck}
{#X Bool2Str}
Function Str2Byte (Const S: String): Byte;
{Wandelt einen String <S> in ein Byte}
{#X Byte2Str Str2Int Str2Long Str2Real Str2Ptr Str2Short Str2Word}
Function Str2Float (Const S: String): Float;
Function Str2Int (Const S: String): Integer;
{Wandelt einen String <S> in einen Integer}
{#X Int2Str Str2Byte Str2Long Str2Real Str2Ptr Str2Short Str2Word}
Function Str2Long (Const S: String): LongInt;
{Wandelt einen String <S> in einen LongInt}
{#X Long2Str Str2Byte Str2Int Str2Real Str2Ptr Str2Short Str2Word}
Function Str2PChar (S: String): PChar;
{Konvertiert den String <S> in ein PChar}
Function Str2Real (Const S: String): Real;
{Wandelt einen String <S> in eine Realzahl}
{#X Real2Str Str2Byte Str2Int Str2Long Str2Ptr Str2Short Str2Word}
Function Str2Ptr (Const S: String): Pointer;
{Wandelt einen String <S> in der Form 'SSSS:OOOO' oder 'NIL' in einen Pointer}
{#X Ptr2Str Str2Byte Str2Int Str2Long Str2Real Str2Short Str2Word}
Function Str2Short (Const S: String): ShortInt;
{Wandelt einen String <S> in einen ShortInt}
{#X ShortStr Str2Byte Str2Int Str2Long Str2Ptr Str2Real Str2Word}
Function Str2Word (Const S: String): Word;
{Wandelt einen String <S> in ein Word}
{#X Word2Str Str2Byte Str2Int Str2Long Str2Ptr Str2Real Str2Short}
Procedure SwapByte (Var A, B: Byte);
  {$IfNDef SPEED}
  InLine ($8C/$DB/$5E/$1F/$5F/$07/$8A/$04/$26/$86/$05/$88/$04/$8E/$DB);
  {$EndIf}
{Die Funktion tauscht den Inhalt von <A> und <B>}
Procedure SwapBool (Var A, B: Boolean);
  {$IfNDef SPEED}
  InLine ($8C/$DB/$5E/$1F/$5F/$07/$8A/$04/$26/$86/$05/$88/$04/$8E/$DB);
  {$EndIf}
{Die Funktion tauscht den Inhalt von <A> und <B>}
Procedure SwapChar (Var A, B: Char);
  {$IfNDef SPEED}
  InLine ($8C/$DB/$5E/$1F/$5F/$07/$8A/$04/$26/$86/$05/$88/$04/$8E/$DB);
  {$EndIf}
{Die Funktion tauscht den Inhalt von <A> und <B>}
Procedure SwapInt (Var A, B: Integer);
  {$IfNDef SPEED}
  InLine ($8C/$DB/$5E/$1F/$5F/$07/$8B/$04/$26/$87/$05/$89/$04/$8E/$DB);
  {$EndIf}
{Die Funktion tauscht den Inhalt von <A> und <B>}
Procedure SwapLong (Var A, B: LongInt);
{Die Funktion tauscht den Inhalt von <A> und <B>}
Procedure SwapReal (Var A, B: Real);
{Die Funktion tauscht den Inhalt von <A> und <B>}
Procedure SwapPtr (Var A, B: Pointer);
{Die Funktion tauscht den Inhalt von <A> und <B>}
Procedure SwapShort (Var A, B: ShortInt);
  {$IfNDef SPEED}
  InLine ($8C/$DB/$5E/$1F/$5F/$07/$8A/$04/$26/$86/$05/$88/$04/$8E/$DB);
  {$EndIf}
{Die Funktion tauscht den Inhalt von <A> und <B>}
Procedure SwapStr (Var A, B: String);
{Die Funktion tauscht den Inhalt von <A> und <B>}
Procedure SwapVar (Var A, B; Count: Word);
{Die Funktion tauscht den Inhalt von <A> und <B>}
Procedure SwapWord (Var A, B: Word);
  {$IfNDef SPEED}
  InLine ($8C/$DB/$5E/$1F/$5F/$07/$8B/$04/$26/$87/$05/$89/$04/$8E/$DB);
  {$EndIf}
{Die Funktion tauscht den Inhalt von <A> und <B>}
Procedure ToggleBit (Var W: Word; Bit: Byte);
{ToggleBit invertiert im Word <W> das Bit <Bit>}
{#X ClearBit GetBit SetBit ToggleFlag}
Procedure ToggleFlag (Var W: Word; Flags: Word);
{ToggleFlag invertiert im Word <W> die Flags <Flags>}
{#X ClearFlag GetFlag SetFlag ToggleBit}
Function Var2Hex (Var Arr; Count: Byte; Const Seperator: String): String;
{Die Funktion wandelt einen Varparameter <Arr> in einen Hexadezimalzahl
(als String gespeichert). <Count> gibt die Anzahl an, und <Seperator> die
 Trennzeichen zwischen zwei Bytes}
{#X Hex2Var}
Procedure Warning (Const S: String);
{Ruft #Alert# mit dem Titel "Warnung", dem Text <S> + '|F:B'
 und dem Button "Ok" auf}
{#X Info Fatal Retry Debug}
Function Word2Bin (W: Word; N: Integer): String;
{Die Funktion wandelt ein Word <W> in eine BinÑrzahl (als String gespeichert).
 Der Absolutwert von <N> gibt die Anzahl der Stellen an, wobei ein negatives
 <N> fÅhrende Nullen erzeugt. Bei <N> = 0 bekommt der String die minimale
 LÑnge}
{#X Bin2Word Word2Hex Word2Str}
Function Word2Hex (W: Word; N: Integer): String;
{Die Funktion wandelt eine Word <W> in einen Hexadezimalzahl (als String
 gespeichert). Der Absolutwert von <N> gibt die Anzahl der Stellen an, wobei
 ein negatives <N> fÅhrende Nullen erzeugt. Bei <N> = 0 bekommt der String
 die minimale LÑnge}
{#X Hex2Word Word2BCD Word2Bin Word2Str}
Function Word2Str (W: Word; N: Integer): String;
{Die Funktion wandelt einen ShortInt <Sh> in einen String. Der Absolutwert von
 <N> gibt die Anzahl der Stellen an, wobei ein negatives <N> fÅhrende Nullen
 erzeugt. Bei <N> = 0 bekommt der String die minimale LÑnge}
{#X Str2Short Short2BCD Short2Bin Short2Char Short2Hex}
Procedure XSystemSetErrorProcs;
{Setzt die Procedurvariablen #Warning#, #Retry# und #Fatal# auf die
 Standardprozeduren der XSystem}

{$IfNDef SPEED}

Function GetMemSeg (Anz: LongInt): Word;
{Keine Ahnung was das macht (Stefan?)}
{#X FreeMemSeg}
Procedure FreeMemSeg (S: Word; Anz: LongInt);
{Keine Ahnung was das macht (Stefan?)}
{#X GetMemSeg}

{$EndIf}

{Only with Coprocessor}
{$IfDef CoPro}

{$IfNDef SPEED}
Function Bin2Comp (S: String): Comp;
{Die Funktion wandelt eine BinÑrzahl (als String gespeichert) in ein Comp)
{#X Comp2Bin Bin2Int Bin2Long Bin2Short Bin2Word}
Function Comp2Bin (C: Comp; N: Integer): String;
{Die Funktion wandelt ein Comp <C> in eine BinÑrzahl (als String gespeichert).
 Der Absolutwert von <N> gibt die Anzahl der Stellen an, wobei ein negatives
 <N> fÅhrende Nullen erzeugt. Bei <N> = 0 bekommt der String die minimale
 LÑnge}
{#X Bin2Comp Comp2Hex Comp2Str}
Function Comp2Hex (C: Comp; N: Integer): String;
{Die Funktion wandelt einen Comp <I> in einen Hexadezimalzahl (als String
 gespeichert). Der Absolutwert von <N> gibt die Anzahl der Stellen an, wobei
 ein negatives <N> fÅhrende Nullen erzeugt. Bei <N> = 0 bekommt der String
 die minimale LÑnge}
{#X Hex2Comp Comp2Bin Comp2Str}
Function Comp2Str (C: Comp; N: Integer): String;
{Die Funktion wandelt einen Comp <C> in einen String. Der Absolutwert von <N>
 gibt die Anzahl der Stellen an, wobei ein negatives <N> fÅhrende Nullen
 erzeugt. Bei <N> = 0 bekommt der String die minimale LÑnge}
{#X Str2Comp Comp2Bin Comp2Hex}
Function CompareComp (A, B: Comp): Integer;
{Die Funktion vergleicht die Comps <A> und <B>. Ist <A> grîsser als <B>,
 dann ist das Ergebnis 1, ist <A> kleiner als <B>, dann ist das Ergebnis -1,
 sonst 0 (also <A> gleich <B>)}
{#X BiggerComp SmallerComp}
Function DiffComp (A, B: Comp): Comp;
{Die Funktion gibt die Differenz zwischen <A> und <B> zurÅck}
{#X SmallerComp BiggerComp}
Function ForceComp (C, Min, Max: Comp): Comp;
{Die Funktion liefert den in den Grenzen <Min> und <Max> gebrachten Comp <C>
 zurÅck}
{#X SmallerComp MaxComp InRangeComp SortComp}
Function IfComp (C: Boolean; T, F: Comp): Comp;
{Ist die Bedingung <C> wahr, so wird der Comp <T>, ansonsten der Comp <F>
 zurÅckgeliefert}
Function InRangeComp (C, Min, Max: Comp): Boolean;
{Die Funktion liefert TRUE zurÅck, wenn der Comp <C> (einschlie·lich)
 zwischen <Min> und <Max> liegt, sonst FALSE}
{#X SmallerComp BiggerComp ForceComp SortComp}
Function BiggerComp (A, B: Comp): Comp;
{Die Funktion liefert den grî·eren Comp von <A> oder <B> zurÅck}
{#X SmallerComp}
Function SmallerComp (A, B: Comp): Comp;
{Die Funktion liefert den kleineren Comp von <A> oder <B> zurÅck}
{#X BiggerComp}
Function SgnComp (C: Comp): Integer;
{Die Funktion liefert bei negativem <C> eine -1, bei positiven <C> eine 1 und
 bei CL> = 0 eine 0 zurÅck}
Procedure SortComp (Var A, B: Comp);
{Die Variablen <A> und <B> weden nach Grî·e sortiert, so da· in <A> das
 kleinere und in <B> der grî·ere Byte steht}
Procedure SwapComp (Var A, B: Comp);
{Die Funktion tauscht den Inhalt von <A> und <B>}
Function Str2Comp (Const S: String): Comp;
{Wandelt einen String <S> in einen Comp}
{#X Comp2Str Str2Byte Str2Int Str2Long Str2Ptr Str2Real Str2Short}

{$EndIf}

Function CompareDouble (A, B: Double): Integer;
{Die Funktion vergleicht die Doubles <A> und <B>. Ist <A> grîsser als <B>,
 dann ist das Ergebnis 1, ist <A> kleiner als <B>, dann ist das Ergebnis -1,
 sonst 0 (also <A> gleich <B>)}
{#X BiggerDouble SmallerDouble}
Function CompareExt (A, B: Extended): Integer;
{Die Funktion vergleicht die Extendeds <A> und <B>. Ist <A> grîsser als <B>,
 dann ist das Ergebnis 1, ist <A> kleiner als <B>, dann ist das Ergebnis -1,
 sonst 0 (also <A> gleich <B>)}
{#X BiggerExt SmallerExt}
Function CompareSingle (A, B: Single): Integer;
{Die Funktion vergleicht die Singles <A> und <B>. Ist <A> grîsser als <B>,
 dann ist das Ergebnis 1, ist <A> kleiner als <B>, dann ist das Ergebnis -1,
 sonst 0 (also <A> gleich <B>)}
{#X BiggerExt SmallerExt}
Function DiffDouble (A, B: Double): Double;
{Die Funktion gibt die Differenz zwischen <A> und <B> zurÅck}
{#X SmallerDouble BiggerDouble}
Function DiffExt (A, B: Extended): Extended;
{Die Funktion gibt die Differenz zwischen <A> und <B> zurÅck}
{#X SmallerExt BiggerExt}
Function DiffSingle (A, B: Single): Single;
{Die Funktion gibt die Differenz zwischen <A> und <B> zurÅck}
{#X SmallerSingle BiggerSingle}
Function Ext2Str (E: Extended; St: Integer; Nk: Byte): String;
{Die Funktion wandelt eine Extendedzahl <E> in einen String. Der Absolutwert
 von <St> gibt die Anzahl der Stellen an, wobei ein negatives <St> fÅhrende
 Nullen erzeugt. Bei <St> = 0 bekommt der String die minimale LÑnge. Nk gibt
 die Anzahl der Nachkommastellen an}
Function ForceDouble (D, Min, Max: Double): Double;
{Die Funktion liefert den in den Grenzen <Min> und <Max> gebrachten Double <D>
 zurÅck}
{#X SmallerDouble MaxDouble InRangeDouble SortDouble}
Function ForceExt (E, Min, Max: Extended): Extended;
{Die Funktion liefert den in den Grenzen <Min> und <Max> gebrachten Extended
 <E> zurÅck}
{#X SmallerExt BiggerExt InRangeExt SortExt}
Function ForceSingle (Si, Min, Max: Single): Single;
{Die Funktion liefert den in den Grenzen <Min> und <Max> gebrachten Single
 <Si> zurÅck}
{#X SmallerSingle BiggerSingle InRangeSingle SortSingle}
Function Double2Str (D: Double; St: Integer; Nk: Byte): String;
{Die Funktion wandelt eine Doublezahl <D> in einen String. Der Absolutwert
 von <St> gibt die Anzahl der Stellen an, wobei ein negatives <St> fÅhrende
 Nullen erzeugt. Bei <St> = 0 bekommt der String die minimale LÑnge. Nk gibt
 die Anzahl der Nachkommastellen an}
Function IfDouble (C: Boolean; T, F: Double): Double;
{Ist die Bedingung <C> wahr, so wird der Double <T>, ansonsten der Double <F>
 zurÅckgeliefert}
Function IfExt (C: Boolean; T, F: Extended): Extended;
{Ist die Bedingung <C> wahr, so wird der Extended <T>, ansonsten der Extended
 <F> zurÅckgeliefert}
Function IfSingle (C: Boolean; T, F: Single): Single;
{Ist die Bedingung <C> wahr, so wird der Single <T>, ansonsten der Single <F>
 zurÅckgeliefert}
Function InRangeDouble (D, Min, Max: Double): Boolean;
{Die Funktion liefert TRUE zurÅck, wenn der Double <D> (einschlie·lich)
 zwischen <Min> und <Max> liegt, sonst FALSE}
{#X SmallerDouble BiggerDouble ForceDouble SortDouble}
Function InRangeExt (E, Min, Max: Extended): Boolean;
{Die Funktion liefert TRUE zurÅck, wenn der Extended <E> (einschlie·lich)
 zwischen <Min> und <Max> liegt, sonst FALSE}
{#X SmallerExt BiggerExt ForceExt SortExt}
Function InRangeSingle (Si, Min, Max: Single): Boolean;
{Die Funktion liefert TRUE zurÅck, wenn der Single <Si> (einschlie·lich)
 zwischen <Min> und <Max> liegt, sonst FALSE}
{#X SmallerSingle BiggerSingle ForceSingle SortSingle}
Function BiggerDouble (A, B: Double): Double;
{Die Funktion liefert den grî·eren Double von <A> oder <B> zurÅck}
{#X SmallerDouble}
Function BiggerExt (A, B: Extended): Extended;
{Die Funktion liefert den grî·eren Extended von <A> oder <B> zurÅck}
{#X SmallerExt}
Function BiggerSingle (A, B: Single): Single;
{Die Funktion liefert den grî·eren Single von <A> oder <B> zurÅck}
{#X SmallerSingle}
Function SmallerDouble (A, B: Double): Double;
{Die Funktion liefert den kleineren Double von <A> oder <B> zurÅck}
{#X BiggerDouble}
Function SmallerExt (A, B: Extended): Extended;
{Die Funktion liefert den kleineren Extended von <A> oder <B> zurÅck}
{#X BiggerExt}
Function SmallerSingle (A, B: Single): Single;
{Die Funktion liefert den kleineren Single von <A> oder <B> zurÅck}
{#X BiggerSingle}
Function SgnDouble (D: Double): Integer;
{Die Funktion liefert bei negativem <D> eine -1, bei positiven <D> eine 1 und
 bei <D> = 0 eine 0 zurÅck}
Function SgnExt (E: Extended): Integer;
{Die Funktion liefert bei negativem <E> eine -1, bei positiven <E> eine 1 und
 bei <E> = 0 eine 0 zurÅck}
Function SgnSingle (Si: Single): Integer;
{Die Funktion liefert bei negativem <Si> eine -1, bei positiven <Si> eine 1
 und bei <Si> = 0 eine 0 zurÅck}
Function Single2Str (Si: Single; St: Integer; Nk: Byte): String;
{Die Funktion wandelt eine Singlezahl <Si> in einen String. Der Absolutwert
 von <St> gibt die Anzahl der Stellen an, wobei ein negatives <St> fÅhrende
 Nullen erzeugt. Bei <St> = 0 bekommt der String die minimale LÑnge. Nk gibt
 die Anzahl der Nachkommastellen an}
Function Str2Double (Const S: String): Double;
{Wandelt einen String <S> in einen Double}
{#X Double2Str Str2Byte Str2Int Str2Long Str2Ptr Str2Real Str2Short}
Function Str2Ext (Const S: String): Extended;
{Wandelt einen String <S> in einen Extended}
{#X Ext2Str Str2Byte Str2Int Str2Long Str2Ptr Str2Real Str2Short}
Function Str2Single (Const S: String): Single;
{Wandelt einen String <S> in einen Single}
{#X Single2Str Str2Byte Str2Int Str2Long Str2Ptr Str2Real Str2Short}
Procedure SwapDouble (Var A, B: Double);
{Die Funktion tauscht den Inhalt von <A> und <B>}
Procedure SwapExt (Var A, B: Extended);
{Die Funktion tauscht den Inhalt von <A> und <B>}
Procedure SwapSingle (Var A, B: Single);
{Die Funktion tauscht den Inhalt von <A> und <B>}
{#X SmallerByte BiggerByte  ForceByte InRangeByte}
Procedure SortDouble (Var A, B: Double);
{Die Variablen <A> und <B> weden nach Grî·e sortiert, so da· in <A> das
 kleinere und in <B> der grî·ere Double steht}
{#X SmallerDouble BiggerDouble  ForceDouble InRangeDouble}
Procedure SortExt (Var A, B: Extended);
{Die Variablen <A> und <B> weden nach Grî·e sortiert, so da· in <A> das
 kleinere und in <B> der grî·ere Extended steht}
{#X SmallerExt BiggerExt  ForceExt InRangeExt}
Procedure SortSingle (Var A, B: Single);
{Die Variablen <A> und <B> weden nach Grî·e sortiert, so da· in <A> das
 kleinere und in <B> der grî·ere Single steht}
{#X SmallerSingle BiggerSingle  ForceSingle InRangeSingle}

{$EndIf}

Implementation

{$IfDef ObjPas}
Uses
  SysUtils;
{$EndIf}

{$IfDef SPEED}
Function Assigned (Var P: Pointer): Boolean;
  Begin
    Assigned := P <> nil;
  End;
{$EndIf}

{Da Speed kein Inline kann, mÅssen diese Prozeduren hier implementiert werden}

{$IfDef SPEED}

Function BCD2Byte (BCD: Byte): Byte;
  Begin
    BCD2Byte := ((BCD SHR 4) * 10) + (BCD AND $0F);
  End;

Function Byte2BCD (B: Byte): Byte;
  Begin
    Byte2BCD := ((B DIV 10) SHL 4) + (B MOD 10);
  End;

Function Byte2Char (B: Byte): Char;
  Begin
    Byte2Char := Char (B + Ord ('0'))
  End;

Function Char2Byte (C: Char): Byte;
  Begin
    Char2Byte := Byte (C) - Ord ('0');
  End;

Procedure DisableInterrupt;
  Begin
  End;

Procedure EnableInterrupt;
  Begin
  End;

Function ForceByte (B, Min, Max: Byte): Byte;
  Begin
    If B < Min then
      ForceByte := Min
    else If B > Max then
      ForceByte := Max
    else
      ForceByte := B;
  End;

Function ForceChar (C, Min, Max: Char): Char;
  Begin
    If C < Min then
      ForceChar := Min
    else If C > Max then
      ForceChar := Max
    else
      ForceChar := C;
  End;

Function ForceInt (I, Min, Max: Integer): Integer;
  Begin
    If I < Min then
      ForceInt := Min
    else If I > Max then
      ForceInt := Max
    else
      ForceInt := I;
  End;

Function ForceShort (Sh, Min, Max: ShortInt): ShortInt;
  Begin
    If Sh < Min then
      ForceShort := Min
    else If Sh > Max then
      ForceShort := Max
    else
      ForceShort := Sh;
  End;

Function ForceWord (W, Min, Max: Word): Word;
  Begin
    If W < Min then
      ForceWord := Min
    else If W > Max then
      ForceWord := Max
    else
      ForceWord := W;
  End;

Function GetBit (W: Word; Bit: Byte): Boolean;
  Begin
    GetBit := (W AND Power2 [Bit]) = Power2 [Bit];
  End;

Function InRangeByte (A, Min, Max: Byte): Boolean;
  Begin
    InRangeByte := (A >= Min) AND (A <= Max);
  End;

Function InRangeInt (A, Min, Max: Integer): Boolean;
  Begin
    InRangeInt := (A >= Min) AND (A <= Max);
  End;

Function InRangeShort (A, Min, Max: ShortInt): Boolean;
  Begin
    InRangeShort := (A >= Min) AND (A <= Max);
  End;

Function InRangeWord (A, Min, Max: Word): Boolean;
  Begin
    InRangeWord := (A >= Min) AND (A <= Max);
  End;

Function BiggerByte (A, B: Byte): Byte;
  Begin
    If A > B then
      BiggerByte := A
    else
      BiggerByte := B;
  End;

Function BiggerChar (A, B: Char): Char;
  Begin
    If A > B then
      BiggerChar := A
    else
      BiggerChar := B;
  End;

Function BiggerInt (A, B: Integer): Integer;
  Begin
    If A > B then
      BiggerInt := A
    else
      BiggerInt := B;
  End;

Function BiggerShort (A, B: ShortInt): ShortInt;
  Begin
    If A > B then
      BiggerShort := A
    else
      BiggerShort := B;
  End;

Function BiggerWord (A, B: Word): Word;
  Begin
    If A > B then
      BiggerWord := A
    else
      BiggerWord := B;
  End;

Function SmallerByte (A, B: Byte): Byte;
  Begin
    If A < B then
      SmallerByte := A
    else
      SmallerByte := B;
  End;

Function SmallerChar (A, B: Char): Char;
  Begin
    If A < B then
      SmallerChar := A
    else
      SmallerChar := B;
  End;

Function SmallerInt (A, B: Integer): Integer;
  Begin
    If A < B then
      SmallerInt := A
    else
      SmallerInt := B;
  End;

Function SmallerShort (A, B: ShortInt): ShortInt;
  Begin
    If A < B then
      SmallerShort := A
    else
      SmallerShort := B;
  End;

Function SmallerWord (A, B: Word): Word;
  Begin
    If A < B then
      SmallerWord := A
    else
      SmallerWord := B;
  End;

Function ROLWord (W: Word; N: Byte): Word;
  Begin
    {XXX}
    N := N MOD 16;
    W := (W SHL N) OR (W SHR (N - 16));
  End;

Function RORWord (W: Word; N: Byte): Word;
  Begin
    {XXX}
    N := N MOD 16;
    W := (W SHR N) OR (W SHL (N - 16));
  End;

Procedure SetFlag (Var W: Word; Flags: Word);
  Begin
    W := W OR Flags;
  End;

Function SgnInt (I: Integer): Integer;
  Begin
    If I = 0 then
      SgnInt := 0
    else If I > 0 then
      SgnInt := 1
    else
      SgnInt := -1;
  End;

Procedure SwapByte (Var A, B: Byte);
  Var
    T: Byte;
  Begin
    T := A;
    A := B;
    B := T;
  End;

Procedure SwapBool (Var A, B: Boolean);
  Var
    T: Boolean;
  Begin
    T := A;
    A := B;
    B := T;
  End;

Procedure SwapChar (Var A, B: Char);
  Var
    T: Char;
  Begin
    T := A;
    A := B;
    B := T;
  End;

Procedure SwapInt (Var A, B: Integer);
  Var
    T: Integer;
  Begin
    T := A;
    A := B;
    B := T;
  End;

Procedure SwapShort (Var A, B: ShortInt);
  Var
    T: ShortInt;
  Begin
    T := A;
    A := B;
    B := T;
  End;

Procedure SwapWord (Var A, B: Word);
  Var
    T: Word;
  Begin
    T := A;
    A := B;
    B := T;
  End;

{$EndIf}

{***************************** Sound-Procedures *****************************}

Procedure _Bell; far;
  Begin
    Write (#7);
  End;

{***************************** Error-Procedures *****************************}

Function _Alert (Title, Text, ButtonStr: String): Integer; far;
  Var
    I: Byte;
    S: String;
    Count: Word;
  Begin
    {Bell;}
    WriteLn ('<' + AlertTitle (Title) + '>');
    I := Pos ('|', Text);
    If I > 0 then
      Text := Copy (Text, 1, I - 1);
    WriteLn (Text);
    Write ('1 - ');
    Count := 2;
    For I := 1 to Length (ButtonStr) do
      If ButtonStr [I] = '|' then
        Begin
          WriteLn;
          Write (Byte2Char (Count) + ' - ');
          Inc (Count);
        End
      else
        Write (ButtonStr [I]);
    WriteLn;
    Write ('? ');
    ReadLn (S);
    _Alert := Str2Word (S);
  End;

Function _GetMsg (aUnitID: Word; aMsgID: Integer): String; far;
  Begin
    _GetMsg := 'Unbekannte Nachricht ' + Int2Str (aUnitID, 0) + '/'
             + Int2Str (aMsgID, 0) + '!';
  End;

Function _TrimmHex (S: String; N: Integer): String;
  Var
    I: Byte;
  Begin
    While (Length (S) > Abs (N)) AND (S [1] = '0') do
      S := Copy (S, 2, 255);
    If N <> 0 then
      Begin
        If Abs (N) < Length (S) then
          Begin
            S [0] := Char (Abs (N));
            FillChar (S [1], Abs (N), FormatErrChar);
          End
        else If N > 0 then
          Begin
            I := 1;
            While S [I] = '0' do
              Begin
                S [I] := ' ';
                Inc (I);
              End;
          End;
        If N > 0 then
          While Length (S) < N do
            S := ' ' + S
        else
          While Length (S) < -N do
            S := '0' + S;
      End;
    _TrimmHex := S;
  End;

Function _TrimmStr (S: String; N: Integer): String;
  Var
    B: Byte;
  Begin
    If N <> 0 then
      Begin
        If Abs (N) < Length (S) then
          Begin
            S [0] := Char (Abs (N));
            FillChar (S [1], Abs (N), FormatErrChar);
          End
        else If N > 0 then
          While Length (S) < N do
            S := ' ' + S
        else
          Begin
            If S [1] = '-' then
              Begin
                S [1] := '0';
                While Length (S) < -N do
                  S := '0' + S;
                S [1] := '-';
              End
            else
              While Length (S) < -N do
                S := '0' + S;
          End
      End
    Else
      While (S <> '') AND (S [1] = ' ') do
        S := Copy (S, 2, 255);

     _TrimmStr := S;
  End;

{***************************** public Procedures ****************************}

Function AlertTitle (Const S: String): String;
  Begin
    If S = '!' then
      AlertTitle := 'Warnung'
    else If S = '?' then
      AlertTitle := 'BestÑtigen'
    else If S = 'I' then
      AlertTitle := 'Information'
    else If S = '*' then
      AlertTitle := 'Fataler Fehler'
    else
      AlertTitle := S;
  End;

Function BiggerFloat (A, B: Float): Float;
  Begin
    If A > B then
      BiggerFloat := A
    else
      BiggerFloat := B;
  End;

Function BiggerLong (A, B: LongInt): LongInt;
  Begin
    If A > B then
      BiggerLong := A
    else
      BiggerLong := B;
  End;

Function BiggerStr (Const A, B: String): String;
  Begin
    If A > B then
      BiggerStr := A
    else
      BiggerStr := B;
  End;

Function Bin2Byte (Const S: String): Byte;
  Var
    T1, T2, B: Byte;
  Begin
    B := 0;
    T2 := 0;
    For T1 := Length (S) downto 1 do
      Begin
        If S [T1] = '1' then
          B := B OR Power2 [T2];
        Inc (T2);
      End;
    Bin2Byte := B;
  End;

Function Bin2Int (Const S: String): Integer;
  Begin
    Bin2Int := Integer (Bin2Word (S));
  End;

Function Bin2Long (S: String): LongInt;
  Var
    L: LongInt;
  Begin
    S := _TrimmStr (S, -32);
    Bin2Long := LongInt (Bin2Word (Copy (S,  1, 16))) SHL 16
              + LongInt (Bin2Word (Copy (S, 17, 16)));
  End;

Function Bin2Short (Const S: String): ShortInt;
  Begin
    Bin2Short := ShortInt (Bin2Byte (S));
  End;

Function Bin2Word (Const S: String): Word;
  {$IfDef SPEED}
  Var
    W: Word;
    T1, T2: Byte;
  Begin
    W := 0;
    T2 := 0;
    For T1 := Length (S) downto 1 do
      Begin
        If S [T1] = '1' then
          W := W OR Power2 [T2];
        Inc (T2);
      End;
    Bin2Word := W;
  End;
  {$Else}
  assembler;
  asm
    xor ax, ax
    les di, S
    mov cl, es:[di]
    or cl, cl
    jz @ende
    xor ch, ch
    add di, cx
    mov bx, 0
    @Loop:
    mov dl, es:[di]
    and dl, 1
    jz @Null
    add ax, word ptr [Power2 + bx]
   @null:
    inc bx
    inc bx
    dec di
    Loop @loop
   @Ende:
  End;
  {$EndIf}

Function Bool2Str (B: Boolean): String;
  Begin
    Bool2Str := cBoolArr [B];
  End;

Function Byte2Bin (B: Byte; N: Integer): String;
  Var
    T: Byte;
    S: String;
  Begin
    S := '';
    For T := 7 downto 0 do
      If GetBit (Word (B), T) then
        S := S + '1'
      else If S <> '' then
        S := S + '0';
    If S = '' then
      S := '0';
    Byte2Bin := _TrimmStr (S, N);
  End;

Function Byte2Hex (B: Byte; N: Integer): String;
  Begin
    Byte2Hex := _TrimmHex (HexArr [B SHR 4] + HexArr [B AND $F], N);
  End;

Function Byte2Str (B: Byte; N: Integer): String;
  Var
    S: String;
  Begin
    Str (B, S);
    Byte2Str := _TrimmStr (S, N);
  End;

Procedure ClearBit (Var W: Word; Bit: Byte);
  Begin
    W := W AND NOT Power2 [Bit];
  End;

Procedure ClearFlag (Var W: Word; Flags: Word);
  Begin
    W := W AND NOT Flags;
  End;

Function CompareByte (A, B: Byte): Integer;
  Begin
    If A > B then
      CompareByte := 1
    else if A < B then
      CompareByte := -1
    else
      CompareByte := 0;
  End;

Function CompareChar (A, B: Char): Integer;
  Begin
    If A > B then
      CompareChar := 1
    else if A < B then
      CompareChar := -1
    else
      CompareChar := 0;
  End;

Function CompareFloat (A, B: Float): Integer;
  Begin
    If A > B then
      CompareFloat := 1
    else if A < B then
      CompareFloat := -1
    else
      CompareFloat := 0;
  End;

Function CompareInt (A, B: Integer): Integer;
  {$IfDef SPEED}
  Begin
    If A > B then
      CompareInt := 1
    else if A < B then
      CompareInt := -1
    else
      CompareInt := 0;
  End;
  {$Else}
  assembler;
  asm
    mov ax, a
    cmp ax, b
    je @null
    jl @negativ
    mov ax, 1
    jmp @ende
   @null:
    xor ax, ax
    jmp @ende
   @negativ:
    mov ax, -1
   @ende:
  end;
  {$EndIf}

Function CompareLong (A, B: LongInt): Integer;
{$IfDef Speed}
  Begin
    If A > B then
      CompareLong := 1
    else if A < B then
      CompareLong := -1
    else
      CompareLong := 0;
  End;
{$Else}
  assembler;
  asm
    mov ax, Word Ptr A + 2
    cmp ax, Word Ptr B + 2
    jg @groesser
    jl @kleiner
    mov ax, word Ptr A
    cmp ax, word Ptr B
    jg @groesser
    jl @kleiner
    xor ax, ax
    jmp @ende
  @groesser:
    mov ax, 1
    jmp @ende
  @kleiner:
    mov ax, -1
  @ende:
End;
{$EndIf}

Function CompareReal (A, B: Real): Integer;
  Begin
    If A > B then
      CompareReal := 1
    else If A < B then
      CompareReal := -1
    else
      CompareReal := 0;
  End;

Function CompareShort (A, B: ShortInt): Integer;
  Begin
    If A > B then
      CompareShort := 1
    else if A < B then
      CompareShort := -1
    else
      CompareShort := 0;
  End;

Function CompareStr (Const A, B: String): Integer;
{$IfDef Speed}
  Begin
    If A > B then
      CompareStr := 1
    else if A < B then
      CompareStr := -1
    else
      CompareStr := 0;
  End;
{$Else}
  assembler;
  asm
    cld
    mov dx, ds
    lds si, a
    les di, b
    lodsb
    mov ah, es:[di]
    inc di
    mov cl, al
    cmp cl, ah
    jbe @L1
    mov cl, ah
  @L1:
    or cl, cl
    je @L2
    xor ch, ch
    repe cmpsb
    jne @unterschied
  @L2:
    cmp al, ah
    je @gleich
  @unterschied:
    ja @groesser
    mov ax, -1
    jmp @ende
  @groesser:
    mov ax, 1
    jmp @ende
  @gleich:
    xor ax, ax
  @ende:
    mov ds, dx
  End;
{$EndIf}

Function CompareVar (var A, B; Count: Word): Integer;
{$IfDef Speed}
  Var
    W: Word;
  Begin
    For W := 0 to Count - 1 do
      If TByteArr (A) [W] > TByteArr (B) [W] then
        Begin
          CompareVar := 1;
          Exit;
        End
      else if TByteArr (A) [W] < TByteArr (B) [W] then
        Begin
          CompareVar := -1;
          Exit;
        End;
    CompareVar := 0;
  End;
{$Else}
  assembler;
  asm
    cld
    mov dx, ds
    lds si, a
    les di, b
    mov cx, count
    repe cmpsb
    je @gleich
    ja @groesser
    mov ax, -1
    jmp @ende
  @groesser:
    mov ax, 1
    jmp @ende
  @gleich:
    xor ax, ax
  @ende:
    mov ds, dx
  End;
{$EndIf}

Function CompareWord (A, B: Word): Integer;
  {$IfDef SPEED}
  Begin
    If A > B then
      CompareWord := 1
    else if A < B then
      CompareWord := -1
    else
      CompareWord := 0;
  End;
  {$Else}
  assembler;
  asm
    mov ax, a
    cmp ax, b
    je @null
    jb @negativ
    mov ax, 1
    jmp @ende
   @null:
    xor ax, ax
    jmp @ende
   @negativ:
    mov ax, -1
   @ende:
  end;
  {$EndIf}

Procedure Debug (Const S: String);
  Begin
    {$IfOpt R+}
    Alert ('Debug', S + '|F:B', 'Ok');
    {$EndIf}
  End;

Function DiffByte (A, B: Byte): Byte;
  Begin
    DiffByte := Abs (B - A);
  End;

Function DiffFloat (A, B: Float): Float;
  Begin
    DiffFloat := Abs (B - A);
  End;

Function DiffInt (A, B: Integer): Integer;
  Begin
    DiffInt := Abs (B - A);
  End;

Function DiffLong (A, B: LongInt): LongInt;
  Begin
    DiffLong := Abs (B - A);
  End;

Function DiffReal (A, B: Real): Real;
  Begin
    DiffReal := Abs (B - A);
  End;

Function DiffShort (A, B: ShortInt): ShortInt;
  Begin
    DiffShort := Abs (B - A);
  End;

Function DiffWord (A, B: Word): Word;
  Begin
    DiffWord := Abs (B - A);
  End;

Procedure DisposePChar (Var P: PChar);
  Var
    W: Word;
  Begin
    If Assigned (P) then
      Begin
        w := 0;
        While pCharArr (p)^[w] <> #0 do
          Inc (W);
        FreeMem (P, W+1);
        P := Nil;
      End;
  End;

Procedure Fatal (Const S: String);
  Begin
    {$IfOpt R-}
    Alert ('*', S + '|LOG|F:B', 'Ok');
    Halt (255);
    {$Else}
    If Alert ('*', S + '|LOG|F:B', 'Halt|Weiter') = 1 then
      Halt (255);
    {$EndIf}
  End;

Procedure FillWord (Var Dest; Count, Value: Word);
  {$IfDef SPEED}
  Var
    L: Word;
  Begin
    For L := 0 to Count - 1 do
      TWordArr (Dest) [L] := Value;
  End;
  {$Else}
  assembler;
  Asm
    les di, dest
    mov ax, value
    mov cx, count
    rep stosw
  End;
  {$EndIf}

Function Float2Str (F: Float; St: Integer; Nk: Byte): String;
  Var
    S: String;
  Begin
    Str (F: St: Nk, S);
    Float2Str := S;
  End;

Function ForceLong (L, Min, Max: LongInt): LongInt;
  Begin
    If L < Min then
      ForceLong := Min
    else If L > Max then
      ForceLong := Max
    else
      ForceLong := L;
  End;

Function ForceReal (R, Min, Max: Real): Real;
  Begin
    If R < Min then
      ForceReal := Min
    else If R > Max then
      ForceReal := Max
    else
      ForceReal := R;
  End;

Function ForceStr (Const S, Min, Max: String): String;
  Begin
    If S < Min then
      ForceStr := Min
    else If S > Max then
      ForceStr := Max
    else
      ForceStr := S;
  End;

{$IfNDef SPEED}
Procedure FreeMemSeg (S: Word; Anz: LongInt);
  Begin
    FreeMem (Pointer (MemL [S-1:0]), MemL [S-1:4]);
  End;
{$EndIf}

Function GetFlag (W, Flags: Word): Boolean;
  Begin
    GetFlag := (W AND Flags) = Flags;
  End;

{$IfNDef SPEED}
Function GetMemSeg (Anz: LongInt): Word;
  Var
    P: Pointer;
    S: Word;
  Begin
    GetMem (P, Anz + 32);

    S := Seg (P^) + 1;

    MemL [S:0] := LongInt (P);
    MemL [S:4] := Anz+32;

    GetMemSeg := S + 1;
  End;
{$EndIf}

Function Hex2Byte (Const S: String): Byte;
  Begin
    Hex2Byte := Str2Byte ('$' + S);
  End;

Function Hex2Int (Const S: String): Integer;
  Begin
    Hex2Int := Str2Int ('$' + S);
  End;

Function Hex2Long (Const S: String): LongInt;
  Begin
    Hex2Long := Str2Long ('$' + S);
  End;

Function Hex2Var (Const Hex: String; Var Arr): Boolean;
  Var
    P: Integer;
    B: Byte;
  Begin
    P := 1;
    B := 0;
    While P <= Length (Hex) do
      Begin
        If Hex [P] in HexDigits then
          If Hex [P + 1] in HexDigits then
            Begin
              TByteArr (Arr) [B] := Hex2Byte (Copy (Hex, P, 2));
              Inc (B);
              Inc (P);
            End;
        Inc (P);
      End;
  End;

Function Hex2Word (Const S: String): Word;
  Begin
    Hex2Word := Str2Word ('$' + S);
  End;

Function Hex2Short (Const S: String): ShortInt;
  Begin
    Hex2Short := Str2Short ('$' + S);
  End;

Function IfByte (C: Boolean; T, F: Byte): Byte;
  {$IfDef SPEED}
  Begin
    If C then
      IfByte := T
    else
      IfByte := F;
  End;
  {$Else}
  assembler;
  asm
    mov cl, c
    mov al, t
    cmp cl, false
    jne @ok
    mov al, f
   @ok:
  End;
  {$EndIf}

Function IfChar (C: Boolean; T, F: Char): Char;
  {$IfDef SPEED}
  Begin
    If C then
      IfChar := T
    else
      IfChar := F;
  End;
  {$Else}
  assembler;
  asm
    mov cl, c
    mov al, t
    cmp cl, false
    jne @ok
    mov al, f
  @ok:
  End;
  {$EndIf}

Function IfFloat (C: Boolean; T, F: Float): Float;
  Begin
    If C then
      IfFloat := T
    else
      IfFloat := F;
  End;

Function IfInt (C: Boolean; T, F: Integer): Integer;
  {$IfDef SPEED}
  Begin
    If C then
      IfInt := T
    else
      IfInt := F;
  End;
  {$Else}
  assembler;
  asm
    mov cl, c
    mov ax, t
    cmp cl, false
    jne @ok
    mov ax, f
   @ok:
  End;
  {$EndIf}

Function IfLong (C: Boolean; T, F: LongInt): LongInt;
  Begin
    If C then
      IfLong := T
    else
      IfLong := F;
  End;

Function IfPtr (C: Boolean; T, F: Pointer): Pointer;
  Begin
    If C then
      IfPtr := T
    else
      IfPtr := F;
  End;

Function IfReal (C: Boolean; T, F: Real): Real;
  Begin
    If C then
      IfReal := T
    else
      IfReal := F;
  End;

Function IfShort (C: Boolean; T, F: ShortInt): ShortInt;
  {$IfDef SPEED}
  Begin
    If C then
      IfShort := T
    else
      IfShort := F;
  End;
  {$Else}
  assembler;
  asm
    mov cl, c
    mov al, t
    cmp cl, false
    jne @ok
    mov al, f
   @ok:
  End;
  {$EndIf}

Function IfStr (C: Boolean; Const T, F: String): String;
  Begin
    If C then
      IfStr := T
    else
      IfStr := F;
  End;

Function IfWord (C: Boolean; T, F: Word): Word;
  {$IfDef SPEED}
  Begin
    If C then
      IfWord := T
    else
      IfWord := F;
  End;
  {$Else}
  assembler;
  asm
    mov cl, c
    mov ax, t
    cmp cl, false
    jne @ok
    mov ax, f
   @ok:
  End;
  {$EndIf}

Function InRangeFloat (A, Min, Max: Float): Boolean;
  Begin
    InRangeFloat := (A >= Min) AND ( A <= Max);
  End;

Function SgnFloat (F: Float): Integer;
  Begin
    If F = 0 then
      SgnFloat := 0
    else If F > 0 then
      SgnFloat := 1
    else
      SgnFloat := -1;
  End;

Function Str2Float (Const S: String): Float;
  Var
    F: Float;
    T: Integer;
  Begin
    Val (S, F, T);
    Str2Float := F;
  End;

Procedure Info (Const S: String);
  Begin
    Alert ('I', S, 'Ok');
  End;

Function InRangeLong (A, Min, Max: LongInt): Boolean;
  Begin
    InRangeLong := (A >= Min) AND (A <= Max);
  End;

Function InRangeReal (A, Min, Max: Real): Boolean;
  Begin
    InRangeReal := (A >= Min) AND (A <= Max);
  End;

Function InRangeStr (Const A, Min, Max: String): Boolean;
  Begin
    InRangeStr := (A >= Min) AND (A <= Max);
  End;

Function Int2Bin (I, N:Integer): String;
  Var
    T: Byte;
    S: String;
  Begin
    S := '';
    For T := 15 downto 0 do
      If GetBit (Word (I), T) then
        S := S + '1'
      else If S <> '' then
        S := S + '0';
    If S = '' then
      S := '0';
    Int2Bin := _TrimmStr (S, N);
  End;

Function Int2Hex (I, N:Integer): String;
  Var
    S: String;
  Begin
    Int2Hex := _TrimmHex (HexArr [I SHR 12]
      + HexArr [(I AND $F00) SHR 8]
      + HexArr [(I AND $F0) SHR 4]
      + HexArr [I AND $F], N);
  End;

Function Int2Str (I, N: Integer): String;
  Var
    S: String;
  Begin
    Str (I, S);
    Int2Str := _TrimmStr (S, N);
  End;

Function IsEqualVar (Var A, B; Count: Word): Boolean;
{$IfDef Speed}
  Var
    W: Word;
  Begin
    IsEqualVar := False;
    For W := 0 to Count - 1 do
      If TByteArr (A) [W] <> TByteArr (B) [W] then
        Exit;
    IsEqualVar := True;
  End;
{$Else}
  assembler;
  asm
    cld
    mov dx, ds
    lds si, a
    les di, b
    mov cx, Count
    repe cmpsb
    je @gleich
    mov al, false
    jmp @ende
   @gleich:
    mov al, true
   @ende:
    mov ds, dx
  End;
{$EndIf}

Function Long2Bin (L: LongInt; N:Integer): String;
  Var
    T: Byte;
    S: String;
  Begin
    S := '';
    For T := 15 downto 0 do
      If GetBit (LongRec (L).Hi, T) then
        S := S + '1'
      else If S <> '' then
        S := S + '0';
    For T := 15 downto 0 do
      If GetBit (LongRec (L).Lo, T) then
        S := S + '1'
      else If S <> '' then
        S := S + '0';
    If S = '' then
      S := '0';
    Long2Bin := _TrimmStr (S, N);
  End;

Function Long2Hex (L: LongInt; N:Integer): String;
  Begin
    {Ñndern}
    Long2Hex := _TrimmHex (Word2Hex (LongRec (L).HI, 0) + Word2Hex (LongRec (L).Lo, -4), N);

    {HexArr [L SHR 28]
      + HexArr [(L AND $F000000) SHR 24]
      + HexArr [(L AND $F00000) SHR 20]
      + HexArr [(L AND $F0000) SHR 16]
      + HexArr [(L AND $F000) SHR 12]
      + HexArr [(L AND $F00) SHR 8]
      + HexArr [(L AND $F0) SHR 4]
      + HexArr [L AND $F], N);}
  End;

Function Long2Str (L: LongInt; N: Integer): String;
  Var
    S: String;
  Begin
    Str (L, S);
    Long2Str := _TrimmStr (S, N);
  End;

Function SmallerFloat (A, B: Float): Float;
  Begin
    If A < B then
      SmallerFloat := A
    else
      SmallerFloat := B;
  End;

Function SmallerLong (A, B: LongInt): LongInt;
  Begin
    If A < B then
      SmallerLong := A
    else
      SmallerLong := B;
  End;

Function SmallerStr (Const A, B: String): String;
  Begin
    If A < B then
      SmallerStr := A
    else
      SmallerStr := B;
  End;

Function pChar2Str (P: pChar): String;
  Var
    S: String;
    C: Char;
    B: Byte;
  Begin
    {$IfDef SPEED}
    {XXX}
    {$Else}
    B := 0;
    Repeat
      C := pCharArr (P)^ [B];
      If C = #0 then
        Begin
          S [0] := Char (B);
          Break;
        End
      else
        Begin
          Inc (B);
          S [B] := C;
        End;
    Until False;

    pChar2Str := S;
    {$EndIf}
  End;

Function Ptr2Str (P: Pointer): String;
  Begin
    If P = NIL then
      Ptr2Str := 'NIL'
    else
      Ptr2Str := Word2Hex (PtrRec (P).Seg, -4) + ':' + Word2Hex (PtrRec (P).Ofs, -4);
  End;

Function Real2Str (R: Real; St: Integer; Nk: Byte): String;
  Var
    S: String;
  Begin
    Str (R: 0: Nk, S);
    Real2Str := _TrimmStr (S, St);
  End;

Procedure ReAlloc (Var P: Pointer; OldSize, At, Count: Word);
  Var
    P2: pByteArr;
  begin
    GetMem (P2, OldSize + Count);

    If At > 0 then
      Move (P^, P2^, At);

    FillChar (P2^ [At], Count, #0);

    If At < OldSize then
      Move (pByteArr (P)^ [At], P2^ [At + Count], OldSize - At);

    FreeMem (P, OldSize);

    P := P2;
  End;

Function Retry (Const S: String): Boolean;
  Begin
    Retry := Alert ('?', S , 'Ja|Nein') = 1;
  End;

Procedure SetBit (Var W: Word; Bit: Byte);
  Begin
    W := W OR Power2 [Bit];
  End;

Function SgnLong (L: LongInt): Integer;
  Begin
    If L = 0 then
      SgnLong := 0
    else If L > 0 then
      SgnLong := 1
    else
      SgnLong := -1;
  End;

Function SgnReal (R: Real): Integer;
  Begin
    If R = 0 then
      SgnReal := 0
    else If R > 0 then
      SgnReal := 1
    else
      SgnReal := -1;
  End;

Function SgnShort (Sh: ShortInt): Integer;
  Begin
    If Sh = 0 then
      SgnShort := 0
    else If Sh > 0 then
      SgnShort := 1
    else
      SgnShort := -1;
  End;

Function Short2Bin (Sh :ShortInt; N:Integer): String;
  Var
    T: Byte;
    S: String;
  Begin
    S := '';
    For T := 7 downto 0 do
      If GetBit (Word(Sh), T) then
        S := S + '1'
      else If S <> '' then
        S := S + '0';
    If S = '' then
      S := '0';
    Short2Bin := _TrimmStr (S, N);
  End;


Function Short2Hex (Sh: ShortInt; N: Integer): String;
  Begin
    Short2Hex := _TrimmHex (HexArr [Sh SHR 4] + HexArr [Sh AND $F], N);
  End;

Function Short2Str (Sh: ShortInt; N: Integer): String;
  Var
    S: String;
  Begin
    Str (Sh, S);
    Short2Str := _TrimmStr (S, N);
  End;

Procedure SortByte (Var A, B: Byte);
  Begin
    If A > B then
      SwapByte (A, B);
  End;

Procedure SortChar (Var A, B: Char);
  Begin
    If A > B then
      SwapChar (A, B);
  End;

Procedure SortInt (Var A, B: Integer);
  Begin
    If A > B then
      SwapInt (A, B);
  End;

Procedure SortLong (Var A, B: LongInt);
  Begin
    If A > B then
      SwapLong (A, B);
  End;

Procedure SortReal (Var A, B: Real);
  Begin
    If A > B then
      SwapReal (A, B);
  End;

Procedure SortShort (Var A, B: ShortInt);
  Begin
    If A > B then
      SwapShort (A, B);
  End;

Procedure SortStr (Var A, B: String);
  Begin
    If A > B then
      SwapStr (A, B);
  End;

Procedure SortWord (Var A, B: Word);
  Begin
    If A > B then
      SwapWord (A, B);
  End;

Function Str2Bool (Const S: String): Boolean;
  Begin
    Str2Bool := (S = cBoolArr [True])
             OR ((Length (S) > 0) AND (UpCase (S [1]) IN ['J', 'W', 'T', '1']));
  End;

Function Str2Byte (Const S: String): Byte;
  Var
    B: Byte;
    T: Integer;
  Begin
    Val (S, B, T);
    Str2Byte := B;
  End;

Function Str2Int (Const S: String): Integer;
  Var
    I, T: Integer;
  Begin
    Val (S, I, T);
    Str2Int := I;
  End;

Function Str2Long (Const S: String): LongInt;
  Var
    L: LongInt;
    T: Integer;
  Begin
    Val (S, L, T);
    Str2Long := L;
  End;

Function Str2Ptr (Const S: String): Pointer;
  Var
    P: Pointer;
  Begin
    If S = 'NIL' then
      Str2Ptr := NIL
    else
      {$IfDef SPEED}
      Str2Ptr := Pointer (Hex2Long (Copy (S, 1, 4) + Copy (S, 6, 4)));
      {$Else}
      Str2Ptr := Ptr (Hex2Word (Copy (S, 1, 4)), Hex2Word (Copy (S, 6, 4)));
      {$EndIf}
  End;

Function Str2PChar (S: String): PChar;
  Var
    P: PChar;
  Begin
    GetMem (P, Length (S) + 1);
    Move (S [1], PCharArr (P)^, Length (S));
    PCharArr (P)^ [Length (S)] := #0;
    Str2PChar := P;
  End;

Function Str2Real (Const S: String): Real;
  Var
    R: Real;
    T: Integer;
  Begin
    Val (S, R, T);
    Str2Real := R;
  End;

Function Str2Short (Const S: String): ShortInt;
  Var
    Sh: ShortInt;
    T: Integer;
  Begin
    Val (S, Sh, T);
    Str2Short := Sh;
  End;

Function Str2Word (Const S: String): Word;
  Var
    W: Word;
    T: Integer;
  Begin
    Val (S, W, T);
    Str2Word := W;
  End;

Procedure SwapLong (Var A, B: LongInt);
  Var
    T: LongInt;
  Begin
    T := A;
    A := B;
    B := T;
  End;

Procedure SwapReal (Var A, B: Real);
  Var
    T: Real;
  Begin
    T := A;
    A := B;
    B := T;
  End;

Procedure SwapPtr (Var A, B: Pointer);
  Var
    T: Pointer;
  Begin
    T := A;
    A := B;
    B := T;
  End;

Procedure SwapStr (Var A, B: String);
  Var
    T: String;
  Begin
    T := A;
    A := B;
    B := T;
  End;

procedure SwapVar (Var A, B; Count: Word);
  {$IfDef SPEED}
  Var
    W: Word;
  Begin
    {XXX}
    For W := 0 to Count - 1 do
      SwapByte (TByteArr (A) [W], TByteArr (B) [W]);
  End;
  {$Else}
  assembler;
  asm
    cld                          {exchange goes upward}
    mov dx, ds                   {save DS}
    lds si, A                    {get first address}
    les di, B                    {get second address}
    mov cx, count                {get number of bytes to move}
    shr cx, 1                    {get word count (low bit -> carry)}
    jnc @ExchangeWords           {if no odd byte, enter loop}
    mov al, es:[di]              {read odd byte from var2}
    movsb                        {move a byte from var1 to var2}
    mov [si-1], al               {write var2 byte to var1}
    jz @Finis                    {done if only 1 byte to exchange}
  @ExchangeWords:
    mov bx, -2                   {BX is a handy place to keep -2}
  @ExchangeLoop:
    mov ax, es:[di]              {read a word from var2}
    movsw                        {do a move from var1 to var2}
    mov [bx][si], ax             {write var2 word to var1}
    loop @ExchangeLoop           {repeat "count div 2" times}
  @Finis:
    mov ds,dx                    {get back Turbo's DS}
 end;
 {$EndIf}

Procedure ToggleBit (Var W: Word; Bit: Byte);
  Begin
    W := W XOR Power2 [Bit];
  End;

Procedure ToggleFlag (Var W: Word; Flags: Word);
  Begin
    W := W XOR Flags;
  End;

Function Var2Hex (Var Arr; Count: Byte; Const Seperator: String): String;
  Var
    I: Integer;
    S: String;
  Begin
    {$IfNDef SPEED}
    {$IfOpt Q+}
    If (Length (Seperator) + 2) * Count > 255 then
      Fatal ('XSystem.Var2Hex: <Seperator> zu lang oder <Count> zu gro·!');
    {$EndIf}
    {$EndIf}
    S := '';
    For I := 0 to Count - 1 do
      S := S + Seperator + Byte2Hex (TByteArr (Arr) [I], -2);
    Var2Hex := S;
  End;

Procedure Warning (Const S: String);
  Begin
    Alert ('!', S + '|F:B', 'Ok');
  End;

Function Word2Bin (W: Word; N:Integer): String;
  Var
    T: Byte;
    S: String;
  Begin
    S := '';
    For T := 15 downto 0 do
      If GetBit (W, T) then
        S := S + '1'
      else If S <> '' then
        S := S + '0';
    If S = '' then
      S := '0';
    Word2Bin := _TrimmStr (S, N);
  End;

Function Word2Hex (W: Word; N: Integer): String;
  Begin
    Word2Hex := _TrimmHex (HexArr [W SHR 12]
      + HexArr [(W AND $F00) SHR 8]
      + HexArr [(W AND $F0) SHR 4]
      + HexArr [W AND $F], N);
  End;

Function Word2Str (W: Word; N: Integer): String;
  Var
    S: String;
  Begin
    Str (W, S);
    Word2Str := _TrimmStr (S, N);
  End;

{Only with Coprocessor}

{$IfDef CoPro}

{$IfNDef SPEED}

Function Bin2Comp (S: String): Comp;
  Var
    C: Comp;
  Begin
    S := _TrimmStr (S, -64);
    CompRec (C).Hi := Bin2Long (Copy (S, 1, 32));
    CompRec (C).Lo := Bin2Long (Copy (S, 33, 32));
    Bin2Comp := C;
  End;

Function Comp2Bin (C: Comp; N:Integer): String;
  Var
    T: Byte;
    S: String;
  Begin
    S := '';
    For T := 15 downto 0 do
      If GetBit (LongRec (CompRec (C).Hi).Hi, T) then
        S := S + '1'
      else If S <> '' then
        S := S + '0';
    For T := 15 downto 0 do
      If GetBit (LongRec (CompRec (C).Hi).Lo, T) then
        S := S + '1'
      else If S <> '' then
        S := S + '0';
    For T := 15 downto 0 do
      If GetBit (LongRec (CompRec (C).Lo).Hi, T) then
        S := S + '1'
      else If S <> '' then
        S := S + '0';
    For T := 15 downto 0 do
      If GetBit (LongRec (CompRec (C).Lo).Lo, T) then
        S := S + '1'
      else If S <> '' then
        S := S + '0';
    If S = '' then
      S := '0';
    Comp2Bin := _TrimmStr (S, N);
  End;

Function Comp2Hex (C: Comp; N:Integer): String;
  Begin
    Comp2Hex := _TrimmHex (Long2Hex (CompRec (C).Hi, -8)
                         + Long2Hex (CompRec (C).Lo, -8), N);
  End;

Function Comp2Str (C: Comp; N: Integer): String;
  Var
    S: String;
  Begin
    Str (C, S);
    Comp2Str := _TrimmStr (S, N);
  End;

Function CompareComp (A, B: Comp): Integer;
  Begin
    If A > B then
      CompareComp := 1
    else if A < B then
      CompareComp := -1
    else
      CompareComp := 0;
  End;

Function DiffComp (A, B: Comp): Comp;
  Begin
    DiffComp := Abs (B - A);
  End;

Procedure SwapComp (Var A, B: Comp);
  Var
    T: Comp;
  Begin
    T := A;
    A := B;
    B := T;
  End;

Function ForceComp (C, Min, Max: Comp): Comp;
  Begin
    If C < Min then
      ForceComp := Min
    else If C > Max then
      ForceComp := Max
    else
      ForceComp := C;
  End;

Function IfComp (C: Boolean; T, F: Comp): Comp;
  Begin
    If C then
      IfComp := T
    else
      IfComp := F;
  End;

Function InRangeComp (C, Min, Max: Comp): Boolean;
  Begin
    InRangeComp := (C >= Min) AND (C <= Max);
  End;

Function BiggerComp (A, B: Comp): Comp;
  Begin
    If A > B then
      BiggerComp := A
    else
      BiggerComp := B;
  End;

Function SmallerComp (A, B: Comp): Comp;
  Begin
    If A < B then
      SmallerComp := A
    else
      SmallerComp := B;
  End;

Function SgnComp (C: Comp): Integer;
  Begin
    If C = 0 then
      SgnComp := 0
    else If C > 0 then
      SgnComp := 1
    else
      SgnComp := -1;
  End;

Function Str2Comp (Const S: String): Comp;
  Var
    C: Comp;
    T: Integer;
  Begin
    Val (S, C, T);
    Str2Comp := C;
  End;

Procedure SortComp (Var A, B: Comp);
  Begin
    If A > B then
      SwapComp (A, B);
  End;

{$EndIf}

Function CompareDouble (A, B: Double): Integer;
  Begin
    If A > B then
      CompareDouble := 1
    else if A < B then
      CompareDouble := -1
    else
      CompareDouble := 0;
  End;

Function CompareExt (A, B: Extended): Integer;
  Begin
    If A > B then
      CompareExt := 1
    else if A < B then
      CompareExt := -1
    else
      CompareExt := 0;
  End;

Function CompareSingle (A, B: Single): Integer;
  Begin
    If A > B then
      CompareSingle := 1
    else if A < B then
      CompareSingle := -1
    else
      CompareSingle := 0;
  End;

Function DiffDouble (A, B: Double): Double;
  Begin
    DiffDouble := Abs (B - A);
  End;

Function DiffExt (A, B: Extended): Extended;
  Begin
    DiffExt := Abs (B - A);
  End;

Function DiffSingle (A, B: Single): Single;
  Begin
    DiffSingle := Abs (B - A);
  End;

Function Double2Str (D: Double; St: Integer; Nk: Byte): String;
  Var
    S: String;
  Begin
    Str (D: 0: Nk, S);
    Double2Str := _TrimmStr (S, St);
  End;

Function Ext2Str (E: Extended; St: Integer; Nk: Byte): String;
  Var
    S: String;
  Begin
    Str (E: 0: Nk, S);
    Ext2Str :=  _TrimmStr (S, St);;
  End;

Function ForceDouble (D, Min, Max: Double): Double;
  Begin
    If D < Min then
      ForceDouble := Min
    else If D > Max then
      ForceDouble := Max
    else
      ForceDouble := D;
  End;

Function ForceExt (E, Min, Max: Extended): Extended;
  Begin
    If E < Min then
      ForceExt := Min
    else If E > Max then
      ForceExt := Max
    else
      ForceExt := E;
  End;

Function ForceSingle (Si, Min, Max: Single): Single;
  Begin
    If Si < Min then
      ForceSingle := Min
    else If Si > Max then
      ForceSingle := Max
    else
      ForceSingle := Si;
  End;

Function IfDouble (C: Boolean; T, F: Double): Double;
  Begin
    If C then
      IfDouble := T
    else
      IfDouble := F;
  End;

Function IfExt (C: Boolean; T, F: Extended): Extended;
  Begin
    If C then
      IfExt := T
    else
      IfExt := F;
  End;

Function IfSingle (C: Boolean; T, F: Single): Single;
  Begin
    If C then
      IfSingle := T
    else
      IfSingle := F;
  End;

Function InRangeDouble (D, Min, Max: Double): Boolean;
  Begin
    InRangeDouble := (D >= Min) AND (D <= Max);
  End;

Function InRangeExt (E, Min, Max: Extended): Boolean;
  Begin
    InRangeExt := (E >= Min) AND (E <= Max);
  End;

Function InRangeSingle (Si, Min, Max: Single): Boolean;
  Begin
    InRangeSingle := (Si >= Min) AND (Si <= Max);
  End;

Function BiggerDouble (A, B: Double): Double;
  Begin
    If A > B then
      BiggerDouble := A
    else
      BiggerDouble := B;
  End;

Function BiggerExt (A, B: Extended): Extended;
  Begin
    If A > B then
      BiggerExt := A
    else
      BiggerExt := B;
  End;

Function BiggerSingle (A, B: Single): Single;
  Begin
    If A > B then
      BiggerSingle := A
    else
      BiggerSingle := B;
  End;

Function SmallerDouble (A, B: Double): Double;
  Begin
    If A < B then
      SmallerDouble := A
    else
      SmallerDouble := B;
  End;

Function SmallerExt (A, B: Extended): Extended;
  Begin
    If A < B then
      SmallerExt := A
    else
      SmallerExt := B;
  End;

Function SmallerSingle (A, B: Single): Single;
  Begin
    If A < B then
      SmallerSingle := A
    else
      SmallerSingle := B;
  End;

Function SgnDouble (D: Double): Integer;
  Begin
    If D = 0 then SgnDouble := 0
    else If D > 0 then
      SgnDouble := 1
    else
      SgnDouble := -1;
  End;

Function SgnExt (E: Extended): Integer;
  Begin
    If E = 0 then
      SgnExt := 0
    else If E > 0 then
      SgnExt := 1
    else
      SgnExt := -1;
  End;

Function SgnSingle (Si: Single): Integer;
  Begin
    If Si = 0 then
      SgnSingle := 0
    else If Si > 0 then
      SgnSingle := 1
    else
      SgnSingle := -1;
  End;

Function Single2Str (Si: Single; St: Integer; Nk: Byte): String;
  Begin
    Single2Str := Float2Str (Si, St, Nk);
  End;

Function Str2Double (Const S: String): Double;
  Var
    D: Double;
    T: Integer;
  Begin
    Val (S, D, T);
    Str2Double := D;
  End;

Function Str2Ext (Const S: String): Extended;
  Var
    E: Extended;
    T: Integer;
  Begin
    Val (S, E, T);
    Str2Ext := E;
  End;

Function Str2Single (Const S: String): Single;
  Var
    Si: Single;
    T: Integer;
  Begin
    Val (S, Si, T);
    Str2Single := Si;
  End;

Procedure SortDouble (Var A, B: Double);
  Begin
    If A > B then
      SwapDouble (A, B);
  End;

Procedure SortExt (Var A, B: Extended);
  Begin
    If A > B then
      SwapExt (A, B);
  End;

Procedure SortSingle (Var A, B: Single);
  Begin
    If A > B then
      SwapSingle (A, B);
  End;

Procedure SwapDouble (Var A, B: Double);
  Var
    T: Double;
  Begin
    T := A;
    A := B;
    B := T;
  End;

Procedure SwapExt (Var A, B: Extended);
  Var
    T: Extended;
  Begin
    T := A;
    A := B;
    B := T;
  End;

Procedure SwapSingle (Var A, B: Single);
  Var
    T: Single;
  Begin
    T := A;
    A := B;
    B := T;
  End;

{$EndIf}

Procedure XSystemSetErrorProcs;
  Begin
{$IfDef Speed}
    Alert := @_Alert;
{$Else}
    Alert := _Alert;
{$EndIf}
  End;

Begin
  {$IfNDef SPEED}
  {$IfOpt G+}
  If Test8086 < 1 then
    Fatal ('FÅr dieses Programm ist mindestens ein 80286 Prozessor nîtig!');
  {$EndIf}
  {$EndIf}

  {$IfDef SPEED}
  Bell := @_Bell;
  GetMsg := @_GetMsg;
  {$Else}
  Bell := _Bell;
  GetMsg := _GetMsg;
  {$EndIf}

  XSystemSetErrorProcs;
End.
