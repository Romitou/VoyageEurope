program main;
uses types, chargerDonnees, ChoixCriteres;

var europe: TEurope;
var criteres: TCriteres;
begin
    europe := chargerPays();
    demanderCriteres(criteres, europe);
end.
