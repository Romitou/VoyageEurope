unit genererVoyage;

interface
uses types,TriDesPays,calculItineraire;

function genererVoyage(criteres: TCriteres; europe: TEurope): TVoyage;

implementation

function genererVoyage(criteres: TCriteres; europe: TEurope): TVoyage;
var listePaysValables,itineraire:TEurope;
begin
    listePaysValables:=paysfiltrerPays(criteres,europe);
    itineraire:=calculItineraire(criteres.paysDepart,criteres.paysArrivee,listePaysValables);
    listePaysValables:=suppressionPaysVisite(listePaysValables,itineraire);
    //ajouter champ message dans TVoyage et l'afficger plus tard

end;
end.