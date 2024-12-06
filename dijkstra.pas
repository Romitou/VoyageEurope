unit dijkstra;

interface
uses constantes, sysutils, voyageTypes;

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


procedure shortestPath(listeAdjacence: TAdjacenceListe; noeudDepart, noeudFin: TNoeud; var chemin: TNoeudList; var distance: TDistance);

implementation

{ Affiche la liste d'adjacence d'un graphe pondéré
    @param(listeAdjacence Liste d'adjacence du graphe)
}
procedure afficherAdjacence(listeAdjacence: TAdjacenceListe);
var i, j: Integer;
begin
    Writeln('Liste d''adjacence :');
    for i := 0 to length(listeAdjacence) - 1 do
    begin
        writeln('Nœud ', i, ':');
        for j := 0 to length(listeAdjacence[i]) - 1 do
            writeln(' -> (Voisin: ', ListeAdjacence[i][j].voisin, ', Distance: ', ListeAdjacence[i][j].distance, ')');
        writeln();
    end;
end;


{ Calcule le chemin le plus court entre deux noeuds d'un graphe pondéré par des distances positives avec l'algorithme de Dijkstra
Source : https://github.com/dmahugh/dijkstra-algorithm/blob/master/dijkstra_algorithm.py
    @param(listeAdjacence Liste d'adjacence du graphe)
    @param(noeudDepart Noeud de départ)
    @param(noeudFin Noeud de fin)
    @param(chemin Chemin le plus court)
    @param(distance Distance du chemin le plus court)
}
procedure shortestPath(listeAdjacence: TAdjacenceListe; noeudDepart, noeudFin: TNoeud; var chemin: TNoeudList; var distance: TDistance);
var noeudsInitial: TNoeudList;
    distanceDepart: TDistanceDict;
    noeudPrecedent: TPrecedentDict;
    noeudActuel, voisin, i, j, minDistNoeud: TNoeud;
    nouveauChemin, minDist: TDistance;
begin
    if MODE_DEBUG then
        afficherAdjacence(listeAdjacence);

    setlength(noeudsInitial, length(listeAdjacence));
    setlength(distanceDepart, length(listeAdjacence));
    setlength(noeudPrecedent, length(listeAdjacence));

    for i := 0 to length(listeAdjacence) - 1 do
    begin
        noeudsInitial[i] := i;
        if i = noeudDepart then
            distanceDepart[i] := 0
        else
            distanceDepart[i] := INFINITY;
        noeudPrecedent[i] := -1;
    end;

    while length(noeudsInitial) > 0 do
    begin
        minDist := INFINITY;
        minDistNoeud := -1;

        for i := 0 to length(noeudsInitial) - 1 do
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

        for i := 0 to length(noeudsInitial) - 1 do
            if noeudsInitial[i] = minDistNoeud then
            begin
                noeudsInitial[i] := noeudsInitial[length(noeudsInitial) - 1];
                setlength(noeudsInitial, length(noeudsInitial) - 1);
                break;
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

    setlength(chemin, 0);
    noeudActuel := noeudFin;
    while (noeudActuel <> noeudDepart) and (noeudPrecedent[noeudActuel] <> -1) do
    begin
        setlength(chemin, length(chemin) + 1);
        chemin[high(chemin)] := noeudActuel;
        noeudActuel := noeudPrecedent[noeudActuel];
    end;

    if noeudActuel = noeudDepart then
    begin
        setlength(chemin, length(chemin) + 1);
        chemin[high(chemin)] := noeudDepart;
        distance := distanceDepart[noeudFin];
    end
    else begin
        setlength(chemin, 0);
        distance := INFINITY;
    end;
end;

end.
