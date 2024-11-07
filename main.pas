program main;
uses types, chargerDonnees, ChoixCriteres,TriDesPays,calculItineraire;

var europe:TEurope;
var criteres: TCriteres;
var paysValables: TEurope;
var i: Integer;
begin
    europe :=chargerEurope();
    demanderCriteres(criteres, europe);
    paysValables := calculerItineraire(europe, criteres);
    for i := 0 to length(paysValables) - 1 do writeln(paysValables[i].nom);
end.
