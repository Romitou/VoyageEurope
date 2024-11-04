program main;
uses types, chargerDonnees, ChoixCriteres,triDesPays;

var europe:TEurope;
var criteres: TCriteres;
begin
   
    europe :=chargerEurope();
    demanderCriteres(criteres, europe);
    

end.
