unit calculItineraire;

interface
uses voyageTypes, dijkstra;

function convertirEuropeAdjacence(europe: TEurope): TAdjacenceListe;
function trouverIndexPays(nom: String; europe: TEurope): Integer;
function calculerItineraire(paysValables: TEurope; criteres: TCriteres): TEurope;

implementation

function calculerItineraire(paysValables: TEurope; criteres: TCriteres): TEurope;
var adjacence: TAdjacenceListe;
var chemin: TNoeudList;
var distance: TDistance;
var i, indexPays: Integer;
var noeudDepart, noeudFin: Integer;
var cheminPays: TEurope;
begin
    adjacence := convertirEuropeAdjacence(paysValables);
    noeudDepart := trouverIndexPays(criteres.paysDepart.nom, paysValables);
    writeln('noeudDepart call');
    noeudFin := trouverIndexPays(criteres.paysArrivee.nom, paysValables);
    writeln('noeudFin call');
    shortestPath(adjacence, length(adjacence), noeudDepart, noeudFin, chemin, distance);
    writeln('shortestPath call');

    setlength(cheminPays, length(chemin));
    for i := 0 to length(chemin) - 1 do
    begin
        indexPays := chemin[i];
        cheminPays[i] := paysValables[indexPays];
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
    i, j, voisinIndex: Integer;
begin
    SetLength(listeAdjacence, Length(europe));
    for i := 0 to length(europe) - 1 do
    begin
        SetLength(listeAdjacence[i], Length(europe[i].nomFrontieres));
        for j := 0 to length(europe[i].nomFrontieres) - 1 do
        begin
            // writeln('nom frontiere : ', europe[i].nomFrontieres[j]);
            voisinIndex := trouverIndexPays(europe[i].nomFrontieres[j], europe);
            if voisinIndex <> -1 then
            begin
                listeAdjacence[i][j].voisin := voisinIndex;
                listeAdjacence[i][j].distance := 1;
            end;
        end;
    end;
    convertirEuropeAdjacence := listeAdjacence;
end;

end.