{$H+}

unit utils;

interface
uses sysutils, voyageTypes;

function trouverIndexPays(nom: String; europe: TEurope): Integer;
function splitLigneCsv(ligne: string; delimiteur: char): TStringArray;
function demanderEntier(): Integer;

implementation

function splitLigneCsv(ligne: string; delimiteur: char): TStringArray;
var
  i: integer;
  valeur: string;
  inside_quotes: boolean;
  resultat: TStringArray;
begin
  valeur := '';
  inside_quotes := False;
  SetLength(resultat, 0);

  writeln('splitLigneCsv: ', ligne);

  for i := 1 to Length(ligne) - 1 do
  begin
    if ligne[i] = '"' then
      inside_quotes := not inside_quotes
    else if (ligne[i] = delimiteur) and not inside_quotes then
    begin
      SetLength(resultat, Length(resultat) + 1);
      resultat[High(resultat)] := Trim(valeur);
      valeur := '';
    end
    else
      valeur := valeur + ligne[i];
  end;
  SetLength(resultat, Length(resultat) + 1);
  resultat[High(resultat)] := Trim(valeur);
  splitLigneCsv := resultat;
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

function demanderEntier(): Integer;
var
    input: string;
    value: LongInt;
    success: Boolean;
begin
    repeat
        readln(input);
        success := TryStrToInt(input, value);
        writeln(success);
        if not success then
            writeln('Veuillez entrer un nombre entier.');
    until success;
    demanderEntier := value;
end;

end.
