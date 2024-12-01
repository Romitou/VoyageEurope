program main;

uses afficherVoyage, chargerDonnees, choixCriteres, genererVoyage, voyageTypes;

var europe: TEurope;
var criteres: TCriteres;
var voyage: TVoyage;
begin
    europe := chargerEurope();
    demanderCriteres(criteres, europe);
    voyage := generer(criteres, europe);
    afficher(voyage, criteres);
end.
