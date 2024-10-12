unit chargerDonnees;

interface
uses types;

function chargerPays(): TEurope;
function serialiserPays(pays: TPays): string;
function splitString(value: string; delimiter: string): TStringArray;
procedure sauvegarderPays(europe: TEurope);

implementation

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


function serialiserPays(pays: TPays): string;
var i: Integer;
begin
    serialiserPays := '';
    serialiserPays += pays.nom + ',' + pays.capitale + ',';
    for i := 0 to length(pays.nomFrontieres) - 1 do
    begin
        serialiserPays += pays.nomFrontieres[i];
        if (i <> length(pays.nomFrontieres) - 1) then
            serialiserPays += '|';
    end;
    writeln('done');
end;

function deserialiserPays(valeur: String): TPays;
var split: Array of String;
begin
    split := SplitString(valeur, ',');
    deserialiserPays.nom := split[0];
    deserialiserPays.capitale := split[1];
    deserialiserPays.nomFrontieres := splitString(split[2], '|');
end;


function chargerPays(): TEurope;
var fichierPays: Text;
var ligne: String;
var tempEurope: TEurope;
begin
    setlength(tempEurope, 0);
    assign(fichierPays, 'pays.csv');
    reset(fichierPays);
    while not eof(fichierPays) do
    begin
        readln(fichierPays, ligne);
        setlength(tempEurope, length(tempEurope) + 1);
        tempEurope[length(tempEurope) - 1] := deserialiserPays(ligne);
    end;
    close(fichierPays);
    chargerPays := tempEurope;
end;

procedure sauvegarderPays(europe: TEurope);
var
  fichierPays: Text;
  i: Integer;
begin
  assign(fichierPays, 'pays.csv');
  rewrite(fichierPays);
  
  writeln(length(europe));
  for i := 0 to length(europe) - 1 do
  begin
    writeln(fichierPays, serialiserPays(europe[i]));
    writeln('ok ', i);
  end;
  
  close(fichierPays);
end;

end.
