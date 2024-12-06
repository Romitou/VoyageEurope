{$H+}

{ Chargement et traitement des données depuis les fichiers CSV }
unit chargerDonnees;

interface
uses constantes, strutils, sysutils, utils, voyageTypes;

{ Charge l'ensemble des pays et activités associées
    @return(Un tableau de pays complétés)
}
function chargerEurope(): TEurope;

implementation

{ Désérialise une ligne CSV en un objet TFilePays. Pour rappel, les champs sont : nom, capitale, iso3, frontieresTrain, frontieresAvion, latlng, climat
    @param(valeur La ligne CSV à désérialiser)
    @return(Un objet TFilePays)
}
function deserialiserPays(valeur: String): TFilePays;
var split, latlngString: TStringArray;
begin
    // On sépare les valeurs de la ligne CSV avec une fonction utilitaire dédiée
    split := splitLigneCsv(valeur, ',');

    deserialiserPays.nom := split[0];
    deserialiserPays.capitale := split[1];
    deserialiserPays.code := split[2];

    // Les frontières ferroviaires et les pays accessibles en avion sont des listes de codes ISO3 séparés par des virgules
    deserialiserPays.codeFrontieres := splitString(split[3], ',');
    deserialiserPays.codeAvions := splitString(split[4], ',');

    // Le climat est une liste de températures moyennes mensuelles séparées par des virgules
    deserialiserPays.climatString := splitString(split[6], ',');

    // Les coordonnées géographiques sont une paire de latitude et longitude séparées par une virgule
    latlngString := splitString(split[5], ',');

    // On convertit les chaînes de caractères en nombres
    // Attention, on change le séparateur décimal pour éviter les erreurs de conversion car sur certaines machines : « EConvertError : "41.0" is an invalid float »
    // Permet d’écraser le séparateur décimal par défaut, probablement défini par la langue du système d’exploitation
    DefaultFormatSettings.DecimalSeparator := '.';
    deserialiserPays.latitude := StrToFloat(latlngString[0]);
    deserialiserPays.longitude := StrToFloat(latlngString[1]);
end;

{ Désérialise une ligne CSV en un objet TFileActivite. Pour rappel, les champs sont : nom, pays, description, duree, cout, latlng, preferences
    @param(valeur La ligne CSV à désérialiser)
    @return(Un objet TFileActivite)
}
function deserialiserActivite(valeur: String): TFileActivite;
var split, categories: TStringArray;
    i: Integer;
begin
    // On sépare les valeurs de la ligne CSV avec une fonction utilitaire dédiée
    split := splitLigneCsv(valeur, ',');

    deserialiserActivite.nom := split[0];
    deserialiserActivite.pays := split[1];
    
    // On convertit le temps et le coût en nombres
    // Attention, on change le séparateur décimal pour éviter les erreurs de conversion car sur certaines machines : « EConvertError : "41.0" is an invalid float »
    // Permet d’écraser le séparateur décimal par défaut, probablement défini par la langue du système d’exploitation
    DefaultFormatSettings.DecimalSeparator := '.';
    deserialiserActivite.minutes := round(StrToFloat(split[2]));
    deserialiserActivite.cout := StrToFloat(split[3]);

    categories := splitString(split[4], ',');
    // On connaît le nombre de catégories "splittées", on peut donc allouer la mémoire nécessaire
    setlength(deserialiserActivite.categories, length(categories));
    for i := 0 to length(categories) - 1 do
        // On convertit la chaîne de caractères en un type TPref (voir constantes.pas)
        readStr(categories[i], deserialiserActivite.categories[i]);
end;

{ Charge l'ensemble des pays depuis le fichier pays.csv
    @return(Un tableau de pays)
}
function chargerPays(): TArrayFilePays;
var fichierPays: Text;
    ligne: String;
    tempPays: TArrayFilePays;
    i: Integer;
begin
    setlength(tempPays, 0);

    // On ouvre le fichier en lecture seule (existence vérifiée au préalable)
    assign(fichierPays, 'data/pays.csv');
    reset(fichierPays);

    i := 0;
    while not eof(fichierPays) do // Tant qu'on n'est pas à la fin du fichier
    begin
        readln(fichierPays, ligne); // On lit une ligne du fichier
        if i <> 0 then // On ignore la première ligne (entête)
        begin
            setlength(tempPays, length(tempPays) + 1);
            // On désérialise (on "transforme") la ligne lue (une chaîne de caractères) en un objet TFilePays
            tempPays[length(tempPays) - 1] := deserialiserPays(ligne); 
        end;
        i := i + 1;
    end;

    // On ferme le fichier
    close(fichierPays);

    // Affichage des pays chargés en mode debug
    if MODE_DEBUG then
    begin
        write('Les ', length(tempPays), ' pays suivants ont été chargés : ');
        for i := 0 to length(tempPays) - 1 do write(tempPays[i].nom, ', ');
        writeln();
    end;

    chargerPays := tempPays;
end;

{ Charge l'ensemble des activités depuis le fichier activites.csv
    @return(Un tableau d'activités)
}
function chargerActivites(): TArrayFileActivite;
var fichierActivites: Text;
    ligne: String;
    tempActivites: TArrayFileActivite;
    i: Integer;
begin
    setlength(tempActivites, 0);

    // On ouvre le fichier en lecture seule (existence vérifiée au préalable)
    assign(fichierActivites, 'data/activites.csv');
    reset(fichierActivites);

    i := 0;
    while not eof(fichierActivites) do // Tant qu'on n'est pas à la fin du fichier
    begin
        readln(fichierActivites, ligne); // On lit une ligne du fichier
        if i <> 0 then // On ignore la première ligne (entête)
        begin
            setlength(tempActivites, length(tempActivites) + 1);
            // On désérialise (on "transforme") la ligne lue (une chaîne de caractères) en un objet TFilePays
            tempActivites[length(tempActivites) - 1] := deserialiserActivite(ligne); 
        end;
        i := i + 1;
    end;

    close(fichierActivites);

    // Affichage des activités chargées en mode debug
    if MODE_DEBUG then
    begin
        write('Les ', length(tempActivites), ' activités suivantes ont été chargées : ');
        for i := 0 to length(tempActivites) - 1 do write(tempActivites[i].nom, ', ');
        writeln();
    end;

    chargerActivites := tempActivites;
end;

{ Charge l'ensemble des pays et activités associées
    @return(Un tableau de pays complétés)
}
function chargerEurope(): TEurope;
var listePays: TArrayFilePays;
    listeActivites: TArrayFileActivite;
    pays: TPays;
    activite: TActivite;
    europe: TEurope;
    i, j, k: Integer;
    trouve: Boolean;
begin
    // On vérifie que les fichiers de données sont bien présents
    if not fileExists('data/pays.csv') then
    begin
        writeln('Le fichier de données pays.csv est introuvable.');
        exit;
    end;
    if not fileExists('data/activites.csv') then
    begin
        writeln('Le fichier de données activites.csv est introuvable.');
        exit;
    end;

    // On charge les données depuis les fichiers CSV
    listePays := chargerPays();
    listeActivites := chargerActivites();

    // On alloue la mémoire nécessaire pour stocker les pays, sachant qu'on connaît leur nombre
    setlength(europe, length(listePays));

    for i := 0 to length(listePays) - 1 do
    begin
        // On remplit les champs du pays avec les données chargées
        pays.nom := listePays[i].nom;
        pays.capitale := listePays[i].capitale;
        pays.longitude := listePays[i].longitude;
        pays.latitude := listePays[i].latitude;

        setlength(pays.nomFrontieres, 0);
        setlength(pays.nomAvions, 0);

        // On cherche les noms des pays connectés en train parmi les pays chargés
        for j := 0 to length(listePays[i].codeFrontieres) - 1 do
        begin
            trouve := false;
            for k := 0 to length(listePays) - 1 do
                if listePays[i].codeFrontieres[j] = listePays[k].code then
                begin
                    setlength(pays.nomFrontieres, length(pays.nomFrontieres) + 1);
                    pays.nomFrontieres[length(pays.nomFrontieres) - 1] := listePays[k].nom;
                    trouve := true;
                    break;
                end;
            if MODE_DEBUG and not trouve then
                writeln('Frontière ferroviaire non trouvée pour ', listePays[i].nom, ' : ', listePays[i].codeFrontieres[j]);
        end;

        // On cherche les noms des pays connectés en avion parmi les pays chargés
        for j := 0 to length(listePays[i].codeAvions) - 1 do
        begin
            trouve := false;
            for k := 0 to length(listePays) - 1 do
                if listePays[i].codeAvions[j] = listePays[k].code then
                begin
                    setlength(pays.nomAvions, length(pays.nomAvions) + 1);
                    pays.nomAvions[length(pays.nomAvions) - 1] := listePays[k].nom;
                    trouve := true;
                    break;
                end;
            if MODE_DEBUG and not trouve then
                writeln('Frontière aérienne non trouvée pour ', listePays[i].nom, ' : ', listePays[i].codeAvions[j]);
        end;

        // On cherche les activités associées au pays parmi les activités chargées
        setlength(pays.activites, 0);
        for j := 0 to length(listeActivites) - 1 do
            if listeActivites[j].pays = pays.nom then
            begin
                // On remplit les champs de l'activité avec les données chargées
                activite.nom := listeActivites[j].nom;
                activite.categories := listeActivites[j].categories;
                activite.minutes := listeActivites[j].minutes;
                activite.cout := listeActivites[j].cout;

                setlength(pays.activites, length(pays.activites) + 1);
                pays.activites[length(pays.activites) - 1] := activite;
            end;

        // On remplit le climat du pays avec les données chargées
        // StrToFloat renvoie un flottant, on doit donc le convertir en entier avec round
        for j := 0 to length(listePays[i].climatString) - 1 do
            pays.climat[TMois(j)] := round(StrToFloat(listePays[i].climatString[j]));

        europe[i] := pays;
    end;

    // Affichage des pays chargés en mode debug
    if MODE_DEBUG then
    begin
        writeln(length(europe), ' pays ont été chargés : ');
        for i := 0 to length(europe) - 1 do
        begin
            writeln(europe[i].nom, ' (', length(europe[i].activites), ' activités) :');
            for j := 0 to length(europe[i].activites) - 1 do
                writeln('- ', europe[i].activites[j].nom);
        end;
        writeln();
    end;

    chargerEurope := europe;
end;

end.
