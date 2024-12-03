program main;

uses afficherVoyage, chargerDonnees, choixCriteres, genererVoyage, voyageTypes;

var europe: TEurope;
var criteres: TCriteres;
var voyage: TVoyage;
quitter : Boolean;
begin
    europe := chargerEurope();
    demanderCriteres(criteres, europe);

    repeat

    voyage := generer(criteres, europe);
    afficher(voyage, criteres);
    modifierCriteres(criteres,europe,quitter);

    until quitter


end.
