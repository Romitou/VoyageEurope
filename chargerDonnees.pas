unit chargerDonnees;

interface
uses voyageTypes, sysutils;

function chargerEurope(): TEurope;
// procedure sauvegarderPays(europe: TEurope);

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


// function serialiserPays(pays: TPays): string;
// var i: Integer;
// begin
//     serialiserPays := '';
//     serialiserPays += pays.nom + ',' + pays.capitale + ',';
//     for i := 0 to length(pays.nomFrontieres) - 1 do
//     begin
//         serialiserPays += pays.nomFrontieres[i];
//         if (i <> length(pays.nomFrontieres) - 1) then
//             serialiserPays += '|';
//     end;
//     writeln('done');
// end;

function deserialiserPays(valeur: String): TFilePays;
var split: TStringArray;
begin
    split := splitStringQuotes(valeur, ',');
    deserialiserPays.nom := split[0];
    deserialiserPays.capitale := split[1];
    deserialiserPays.code := split[2];
    deserialiserPays.codeFrontieres := splitString(split[3], ',');
end;

function deserialiserActivite(valeur: String): TFileActivite;
var split: TStringArray;
var categories: TStringArray;
var i: Integer;
begin
    split := splitStringQuotes(valeur, ',');
    deserialiserActivite.nom := split[0];
    deserialiserActivite.pays := split[1];
    deserialiserActivite.cout := StrToFloat(split[2]);
    categories := splitString(split[3], ',');
    setlength(deserialiserActivite.categories, length(categories));
    for i := 0 to length(categories) - 1 do
    begin
        writeln(categories[i]);
        readStr(categories[i], deserialiserActivite.categories[i])
    end;
end;


function chargerPays(): TArrayFilePays;
var fichierPays: Text;
var ligne: String;
var tempPays: TArrayFilePays;
var i: Integer;
begin
    setlength(tempPays, 0);
    assign(fichierPays, 'data/pays.csv');
    reset(fichierPays);
    i := 0;
    while not eof(fichierPays) do
    begin
        readln(fichierPays, ligne);
        if i <> 0 then
        begin
            setlength(tempPays, length(tempPays) + 1);
            tempPays[length(tempPays) - 1] := deserialiserPays(ligne);
        end;
        i := i + 1;
    end;
    close(fichierPays);

    // write('Les ', length(tempPays), ' pays suivants ont été chargés : ');
    // for i := 0 to length(tempPays) - 1 do
    //     write(tempPays[i].nom, ', ');
    writeln();

    chargerPays := tempPays;
end;

function chargerActivites(): TArrayFileActivite;
var fichierActivites: Text;
var ligne: String;
var tempActivites: TArrayFileActivite;
var i: Integer;
begin
    setlength(tempActivites, 0);
    assign(fichierActivites, 'data/activites.csv');
    reset(fichierActivites);
    i := 0;
    while not eof(fichierActivites) do
    begin
        readln(fichierActivites, ligne);
        if i <> 0 then
        begin
            setlength(tempActivites, length(tempActivites) + 1);
            tempActivites[length(tempActivites) - 1] := deserialiserActivite(ligne);
        end;
        i := i + 1;
    end;
    close(fichierActivites);

    // write('Les ', length(tempActivites), ' activités suivantes ont été chargées : ');
    // for i := 0 to length(tempActivites) - 1 do
    //     write(tempActivites[i].nom, ', ');
    // writeln();

    chargerActivites := tempActivites;
end;

function chargerEurope(): TEurope;
var listePays: TArrayFilePays;
    listeActivites: TArrayFileActivite;
    pays: TPays;
    activite: TActivite;
    europe: TEurope;
    i, j, k: Integer;
begin
    listePays := chargerPays();
    listeActivites := chargerActivites();

    setlength(europe, length(listePays));

    for i := 0 to length(listePays) - 1 do
    begin

        pays.nom := listePays[i].nom;
        pays.capitale := listePays[i].capitale;
        setlength(pays.nomFrontieres, 0);

        for j := 0 to length(listePays[i].codeFrontieres) - 1 do
        begin
            for k := 0 to length(listePays) - 1 do
            begin
                if listePays[i].codeFrontieres[j] = listePays[k].code then
                begin
                    writeln(listePays[k].nom);
                    setlength(pays.nomFrontieres, length(pays.nomFrontieres) + 1);
                    pays.nomFrontieres[length(pays.nomFrontieres) - 1] := listePays[k].nom;
                end;
            end;
        end;

        setlength(pays.activites, 0);

        for k := 0 to length(listeActivites) - 1 do
        begin
            if listeActivites[k].pays = pays.nom then
            begin
                activite.nom := listeActivites[k].nom;
                activite.categories := listeActivites[k].categories;
                activite.cout := listeActivites[k].cout;

                setlength(pays.activites, length(pays.activites) + 1);
                pays.activites[length(pays.activites) - 1] := activite;
            end;
        end;

        europe[i] := pays;
    end;

    writeln(length(europe), ' pays ont été chargés : ');
    for i := 0 to length(europe) - 1 do
    begin
        writeln(europe[i].nom, ' (', length(europe[i].activites), ' activités) :');
        for j := 0 to length(europe[i].activites) - 1 do
            writeln('- ', europe[i].activites[j].nom);
    end;
    writeln();

    chargerEurope := europe;

end;


// procedure sauvegarderPays(europe: TEurope);
// var
//   fichierPays: Text;
//   i: Integer;
// begin
//   assign(fichierPays, 'data/pays.csv');
//   rewrite(fichierPays);
  
//   writeln(length(europe));
//   for i := 0 to length(europe) - 1 do
//   begin
//     writeln(fichierPays, serialiserPays(europe[i]));
//     writeln('ok ', i);
//   end;
  
//   close(fichierPays);
// end;

end.
