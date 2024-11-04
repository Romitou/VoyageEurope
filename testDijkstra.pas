program main;
uses types, chargerDonnees, ChoixCriteres,TriDesPays,calculItineraire;

var europe:TEurope;
var criteres: TCriteres;
var resultat: TDijkstraResult;
begin
    europe :=chargerEurope();
    demanderCriteres(criteres, europe);
    resultat := Dijkstra(criteres.paysDepart.nom, criteres.paysArrivee.nom, europe);
    writeln('erreur: ', resultat.error);
    writeln('distance: ', resultat.distance);
end.
