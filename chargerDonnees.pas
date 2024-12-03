{$H+}

{ Chargement et traitement des données depuis les fichiers CSV }
unit chargerDonnees;

interface
uses strutils, sysutils, utils, voyageTypes;

{ Charge l'ensemble des pays et activités associées
    @return(Un tableau de pays complétés)
}
function chargerEurope(): TEurope;

implementation

{ Désérialise une ligne CSV en un objet TFilePays
    @param(valeur La ligne CSV à désérialiser)
    @return(Un objet TFilePays)
}
function deserialiserPays(valeur: String): TFilePays;
var split, latlngString: TStringArray;
begin
    split := splitLigneCsv(valeur, ',');

    deserialiserPays.nom := split[0];
    deserialiserPays.capitale := split[1];
    deserialiserPays.code := split[2];
    deserialiserPays.codeFrontieres := splitString(split[3], ',');
    deserialiserPays.codeAvions := splitString(split[4], ',');
    deserialiserPays.climatString := splitString(split[7], ',');
    latlngString := splitString(split[6], ',');
    DefaultFormatSettings.DecimalSeparator := '.';
    deserialiserPays.latitude := StrToFloat(latlngString[0]);
    deserialiserPays.longitude := StrToFloat(latlngString[1]);
end;

function deserialiserActivite(valeur: String): TFileActivite;
var split: TStringArray;
var categories: TStringArray;
var i: Integer;
begin
    split := splitLigneCsv(valeur, ',');
    deserialiserActivite.nom := split[0];
    deserialiserActivite.pays := split[1];
    DefaultFormatSettings.DecimalSeparator := '.';
    deserialiserActivite.minutes := round(StrToFloat(split[3]));
    deserialiserActivite.cout := StrToFloat(split[4]);
    categories := splitString(split[6], ',');
    setlength(deserialiserActivite.categories, length(categories));
    for i := 0 to length(categories) - 1 do
        readStr(categories[i], deserialiserActivite.categories[i]);
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
    // writeln();

    chargerPays := tempPays;
end;

function chargerActivites(): TArrayFileActivite;
var fichierActivites: Text;
var ligne: String;
var tempActivites: TArrayFileActivite;
var i: Integer;
var c: Char;
begin
    setlength(tempActivites, 0);
    assign(fichierActivites, 'data/activites.csv');
    reset(fichierActivites);
    i := 0;
    ligne := '';
    while not eof(fichierActivites) do
    begin
        read(fichierActivites, c);
        if c = #10 then
        begin
            if i <> 0 then
            begin
                setlength(tempActivites, length(tempActivites) + 1);
                tempActivites[length(tempActivites) - 1] := deserialiserActivite(ligne);
            end;
            i := i + 1;
            ligne := '';
        end
        else
            ligne := ligne + c;
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
        pays.longitude := listePays[i].longitude;
        pays.latitude := listePays[i].latitude;

        setlength(pays.nomFrontieres, 0);
        setlength(pays.nomAvions, 0);

        for j := 0 to length(listePays[i].codeFrontieres) - 1 do
            for k := 0 to length(listePays) - 1 do
                if listePays[i].codeFrontieres[j] = listePays[k].code then
                begin
                    setlength(pays.nomFrontieres, length(pays.nomFrontieres) + 1);
                    pays.nomFrontieres[length(pays.nomFrontieres) - 1] := listePays[k].nom;
                end;

        for j := 0 to length(listePays[i].codeAvions) - 1 do
            for k := 0 to length(listePays) - 1 do
                if listePays[i].codeAvions[j] = listePays[k].code then
                begin
                    setlength(pays.nomAvions, length(pays.nomAvions) + 1);
                    pays.nomAvions[length(pays.nomAvions) - 1] := listePays[k].nom;
                end;

        setlength(pays.activites, 0);
        for j := 0 to length(listeActivites) - 1 do
            if listeActivites[j].pays = pays.nom then
            begin
                activite.nom := listeActivites[j].nom;
                activite.categories := listeActivites[j].categories;
                activite.minutes := listeActivites[j].minutes;
                activite.cout := listeActivites[j].cout;

                setlength(pays.activites, length(pays.activites) + 1);
                pays.activites[length(pays.activites) - 1] := activite;
            end;

        for j := 0 to length(listePays[i].climatString) - 1 do
            pays.climat[TMois(j)] := round(StrToFloat(listePays[i].climatString[j]));

        europe[i] := pays;
    end;

    // writeln(length(europe), ' pays ont été chargés : ');
    // for i := 0 to length(europe) - 1 do
    // begin
    //     writeln(europe[i].nom, ' (', length(europe[i].activites), ' activités) :');
    //     for j := 0 to length(europe[i].activites) - 1 do
    //         writeln('- ', europe[i].activites[j].nom);
    // end;
    // writeln();

    chargerEurope := europe;

end;

end.
