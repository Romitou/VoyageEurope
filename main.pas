program main;

uses voyageTypes, chargerDonnees, choixCriteres, genererVoyage, afficherVoyage;

var europe: TEurope;
var criteres: TCriteres;
var voyage: TVoyage;
begin
    europe:=chargerEurope();
    demanderCriteres(criteres,europe);
    voyage := generer(criteres,europe);
    afficher(voyage,criteres);
end.
