unit calculItineraire;

interface
uses voyageTypes, dijkstra, utils,score;

function convertirEuropeAdjacence(europe: TEurope): TAdjacenceListe;
function trouverIndexPays(nom: String; europe: TEurope): Integer;
function calculerItineraire(paysValables: TEurope; paysDepart, paysArrivee: TPays): TItineraireResult;

implementation

function calculerItineraire(paysValables: TEurope; paysDepart, paysArrivee: TPays): TItineraireResult;
var adjacence: TAdjacenceListe;
var chemin: TNoeudList;
var distance: TDistance;
var i, indexPays: Integer;
var noeudDepart, noeudFin: Integer;
var cheminPays: TEurope;
var resultat: TItineraireResult;
begin
    setlength(resultat.itineraire, 0);
    resultat.erreur := true;

    adjacence := convertirEuropeAdjacence(paysValables);
    if length(adjacence) < 2 then
    begin
        resultat.message := 'Pas assez d''adjacences n''ont été générées.';
        exit(resultat);
    end;

    noeudDepart := trouverIndexPays(paysDepart.nom, paysValables);
    if noeudDepart = -1 then
    begin
        resultat.message := 'Impossible de trouver le pays de départ "' + paysDepart.nom + '".';
        exit(resultat);
    end;

    noeudFin := trouverIndexPays(paysArrivee.nom, paysValables);
    if noeudFin = -1 then
    begin
        resultat.message := 'Impossible de trouver le pays d''arrivée "' + paysArrivee.nom + '".';
        exit(resultat);
    end;

    writeln('length(adjacence):',length(adjacence),'noeudDepart:',noeudDepart,'noeudFin:',noeudFin);
    shortestPath(adjacence, length(adjacence), noeudFin, noeudDepart, chemin, distance);

    if distance <= 0 then
    begin
        resultat.message := 'Dijkstra a renvoyé une distance invalide.';
        exit(resultat);
    end;

    if (distance = INFINITY) or (length(chemin) = 0) then
    begin
        resultat.message := 'Aucun chemin n''a été trouvé entre "' + paysDepart.nom + '" et "' + paysArrivee.nom + '".';
        exit(resultat);
    end;

    setlength(cheminPays, length(chemin));
    for i := 0 to length(chemin) - 1 do
    begin
        // TODO: expliquer destructuration obligatoire 
        indexPays := chemin[i];
        cheminPays[i] := paysValables[indexPays];
    end;

    resultat.erreur := false;
    resultat.itineraire := cheminPays;
    
    calculerItineraire := resultat;
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

function convertirEuropeAdjacence(europe: TEurope): TAdjacenceListe;
var
    listeAdjacence: TAdjacenceListe;
    i, j, n, voisinIndex: Integer;
begin
    SetLength(listeAdjacence, Length(europe));
    for i := 0 to length(europe) - 1 do
    begin
        SetLength(listeAdjacence[i], 0);
        for j := 0 to length(europe[i].nomFrontieres) - 1 do
        begin
            voisinIndex := trouverIndexPays(europe[i].nomFrontieres[j], europe);
            if voisinIndex <> -1 then
            begin
                n := length(listeAdjacence[i]);
                SetLength(listeAdjacence[i], n + 1);
                listeAdjacence[i][n].voisin := voisinIndex;
                //à mettre pour la version avec les scores
                listeAdjacence[i][n].distance :=100-round(100*poidsChemin(europe[i],europe[voisinIndex]));
                //listeAdjacence[i][n].distance :=1000;
            end;
        end;
    end;
    convertirEuropeAdjacence := listeAdjacence;
end;

end.