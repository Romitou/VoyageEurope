unit utils;

interface
uses voyageTypes, sysutils;

function trouverIndexPays(nom: String; europe: TEurope): Integer;
function splitStringQuotes(value: string; delimiter: string): TStringArray;
function splitString(value: string; delimiter: string): TStringArray;
function strToInt(mot: String): Integer;

implementation

function splitStringQuotes(value: string; delimiter: string): TStringArray;
var
    resultArray: TStringArray;
    i, startPos, delimLength: Integer;
    inQuotes: Boolean;
    currentSegment: string;
begin
    i := 0;
    startPos := 1;
    delimLength := Length(delimiter);
    SetLength(resultArray, 0);
    inQuotes := False;
    currentSegment := '';

    while startPos <= Length(value) do
    begin
        if value[startPos] = '"' then
        begin
            inQuotes := not inQuotes;
        end
        else if (not inQuotes) and (Copy(value, startPos, delimLength) = delimiter) then
        begin
            SetLength(resultArray, i + 1);
            resultArray[i] := currentSegment;
            Inc(i);
            currentSegment := '';
            Inc(startPos, delimLength - 1);
        end
        else
        begin
            currentSegment := currentSegment + value[startPos];
        end;

        Inc(startPos);
    end;

    SetLength(resultArray, i + 1);
    resultArray[i] := currentSegment;

    splitStringQuotes := resultArray;
end;

function splitString(value: string; delimiter: string): TStringArray;
var resultArray: TStringArray;
    i, startPos, delimLength: Integer;
    foundPos: Integer;
begin
    i := 0;
    startPos := 1;
    delimLength := length(delimiter);
    setlength(resultArray, 0);

    repeat
        foundPos := pos(delimiter, value);
        setlength(resultArray, i + 1);

        if foundPos > 0 then
        begin
            resultArray[i] := copy(value, startPos, foundPos - startPos);
            value := copy(value, foundPos + delimLength, Length(value) - foundPos - delimLength + 1);
        end
        else
        begin
            resultArray[i] := value;
        end;

        i := i + 1;
    until foundPos = 0;

    splitString := resultArray;
end;

function trouverIndexPays(nom: String; europe: TEurope): Integer;
var
    i: Integer;
begin
    for i := 0 to high(europe) do
        if europe[i].nom = nom then
            Exit(i);
    Exit(-1);
end;

function strToInt(mot: String): Integer;
var 
  k: Integer;
  m: Boolean;
  p: Extended;
begin
  m:=TryStrToFloat(mot,p);
  k:=Round(p);
  strToInt:=k;
end;
end.