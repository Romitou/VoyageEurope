program main;

uses voyageTypes, chargerDonnees, choixCriteres, genererVoyage, afficherVoyage;

var europe: TEurope;
var criteres: TCriteres;
var voyage: TVoyage;
begin
    europe:=chargerEurope();
    demanderCriteres(criteres,europe);
    // en attendant que ce soit implémenté dans demanderCriteres
    criteres.transport := TrainAvion;
    voyage := generer(criteres,europe);
    afficher(voyage,criteres);
end.
