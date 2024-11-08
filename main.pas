program main;
uses types,chargerDonnees,ChoixCriteres,genererVoyage,afficherVoyage;

var europe: TEurope;
var criteres: TCriteres;
var voyage: TVoyage;
begin
    europe:=chargerEurope();
    demanderCriteres(criteres,europe);
    WriteLn('test');
    generer(criteres,europe);
    WriteLn('test');
    afficher(voyage,criteres);
end.
