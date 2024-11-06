program main;
uses types, chargerDonnees, ChoixCriteres,TriDesPays,dijkstra;

var europe:TEurope;
var criteres: TCriteres;
var adjacence: TAdjacenceListe;
var chemin: TNoeudList;
var distance: TDistance;
var i, j: Integer;
var noeudDepart, noeudFin: Integer;
begin
    europe :=chargerEurope();
    demanderCriteres(criteres, europe);
    adjacence := convertirEuropeAdjacence(europe);
    noeudDepart := trouverIndexPays(criteres.paysDepart.nom, europe);
    noeudFin := trouverIndexPays(criteres.paysArrivee.nom, europe);
    shortestPath(adjacence, length(adjacence), noeudDepart, noeudFin, chemin, distance);
    writeln('distance : ', distance);
    writeln('length(chemin) : ', length(chemin));
    // for i := 0 to length(chemin) do
    // begin
    //     writeln(i);
    //     writeln(chemin[i]);
    //     writeln();
    // end;
    writeln('end');
end.
