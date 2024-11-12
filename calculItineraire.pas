unit calculItineraire;

interface
uses voyageTypes, dijkstra;

function convertirEuropeAdjacence(europe: TEurope): TAdjacenceListe;
function trouverIndexPays(nom: String; europe: TEurope): Integer;
function calculerItineraire(paysValables: TEurope; paysDepart, paysArrivee: TPays): TEurope;

implementation

function calculerItineraire(paysValables: TEurope; paysDepart, paysArrivee: TPays): TEurope;
var adjacence: TAdjacenceListe;
var chemin: TNoeudList;
var distance: TDistance;
var i, indexPays: Integer;
var noeudDepart, noeudFin: Integer;
var cheminPays: TEurope;
begin
    adjacence := convertirEuropeAdjacence(paysValables);
    noeudDepart := trouverIndexPays(paysDepart.nom, paysValables);
    noeudFin := trouverIndexPays(paysArrivee.nom, paysValables);
    writeln('length(adjacence):',length(adjacence),'noeudDepart:',noeudDepart,'noeudFin:',noeudFin);
    shortestPath(adjacence, length(adjacence), noeudDepart, noeudFin, chemin, distance);
    writeln(distance);
    writeln(length(chemin));

    setlength(cheminPays, length(chemin));
    for i := 0 to length(chemin) - 1 do
    begin
        // destructuration obligatoire
        indexPays := chemin[i];
        cheminPays[i] := paysValables[indexPays];
        writeln('i', i);
        writeln('cheminPays[i]', cheminPays[i].nom);
    end;
    
    calculerItineraire := cheminPays;
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
                listeAdjacence[i][n].distance := 1;
            end;
        end;
    end;
    convertirEuropeAdjacence := listeAdjacence;
end;

end.