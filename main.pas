program main;
uses voyageTypes,chargerDonnees,ChoixCriteres,genererVoyage,afficherVoyage;

var europe: TEurope;
var criteres: TCriteres;
var voyage: TVoyage;
begin
    europe:=chargerEurope();
    WriteLn('test');
    demanderCriteres(criteres,europe);
    generer(criteres,europe);
    WriteLn('test');
    afficher(voyage,criteres);
end.
