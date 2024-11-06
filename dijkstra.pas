unit dijkstra;

interface
uses types, sysutils;

const
    INFINITY = MaxInt;

type
    TNoeud = Integer;
    TDistance = Integer;
    TAdjacenceListe = array of array of record
        voisin: TNoeud;
        distance: TDistance;
    end;
    TNoeudList = array of TNoeud;
    TDistanceDict = array of TDistance;
    TPrecedentDict = array of TNoeud;


function convertirEuropeAdjacence(europe: TEurope): TAdjacenceListe;
function trouverIndexPays(nom: String; europe: TEurope): Integer;
procedure shortestPath(listeAdjacence: TAdjacenceListe; nbNoeuds: Integer; noeudDepart, noeudFin: TNoeud; var chemin: TNoeudList; var distance: TDistance);

implementation

procedure shortestPath(listeAdjacence: TAdjacenceListe; nbNoeuds: Integer; noeudDepart, noeudFin: TNoeud; var chemin: TNoeudList; var distance: TDistance);
var
    noeudsInitial: TNoeudList;
    distanceDepart: TDistanceDict;
    noeudPrecedent: TPrecedentDict;
    noeudActuel, voisin, i, j, minDistNoeud: TNoeud;
    nouveauChemin, minDist: TDistance;
begin
    SetLength(noeudsInitial, nbNoeuds);
    SetLength(distanceDepart, nbNoeuds);
    SetLength(noeudPrecedent, nbNoeuds);

    for i := 0 to nbNoeuds - 1 do
    begin
        noeudsInitial[i] := i;
        if i = noeudDepart then
            distanceDepart[i] := 0
        else
            distanceDepart[i] := INFINITY;
        noeudPrecedent[i] := -1;
    end;

    while Length(noeudsInitial) > 0 do
    begin
        minDist := INFINITY;
        minDistNoeud := -1;

        for i := 0 to high(noeudsInitial) do
        begin
            noeudActuel := noeudsInitial[i];
            if distanceDepart[noeudActuel] < minDist then
            begin
                minDist := distanceDepart[noeudActuel];
                minDistNoeud := noeudActuel;
            end;
        end;

        if minDistNoeud = -1 then
            break;

        for i := 0 to high(noeudsInitial) do
        begin
            if noeudsInitial[i] = minDistNoeud then
            begin
                noeudsInitial[i] := noeudsInitial[high(noeudsInitial)];
                SetLength(noeudsInitial, Length(noeudsInitial) - 1);
                break;
            end;
        end;

        if minDistNoeud = noeudFin then
            break;

        for j := 0 to high(listeAdjacence[minDistNoeud]) do
        begin
            voisin := listeAdjacence[minDistNoeud][j].voisin;
            nouveauChemin := distanceDepart[minDistNoeud] + listeAdjacence[minDistNoeud][j].distance;

            if nouveauChemin < distanceDepart[voisin] then
            begin
                distanceDepart[voisin] := nouveauChemin;
                noeudPrecedent[voisin] := minDistNoeud;
            end;
        end;
    end;

    SetLength(chemin, 0);
    noeudActuel := noeudFin;
    while (noeudActuel <> noeudDepart) and (noeudPrecedent[noeudActuel] <> -1) do
    begin
        SetLength(chemin, Length(chemin) + 1);
        chemin[high(chemin)] := noeudActuel;
        noeudActuel := noeudPrecedent[noeudActuel];
    end;

    if noeudActuel = noeudDepart then
    begin
        SetLength(chemin, Length(chemin) + 1);
        chemin[high(chemin)] := noeudDepart;
        distance := distanceDepart[noeudFin];
    end
    else
    begin
        SetLength(chemin, 0);
        distance := INFINITY;
    end;
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