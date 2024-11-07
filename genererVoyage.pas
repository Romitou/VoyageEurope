unit genererVoyage;

interface
uses types,TriDesPays,dijkstra,calculCout;

function genererVoyage(criteres: TCriteres; europe: TEurope): TVoyage;

implementation

function genererVoyage(criteres: TCriteres; europe: TEurope): TVoyage;
var listePaysValables,alle,retour,itineraire:TEurope;
voyage:TVoyage;
i:Integer;
begin
    listePaysValables:=filtrerPays(criteres,europe);
    alle:=calculItineraire(criteres.paysDepart,criteres.paysArrivee,listePaysValables);
    listePaysValables:=suppressionPaysVisite(listePaysValables,alle);
    retour:=calculItineraire(criteres.paysArrivee,criteres.paysDepart,listePaysValables);
    setlength(itineraire,(length(alle)+length(retour)));
    for i:=0 to length(alle)-1 do
        voyage.itineraire[i]:=alle[i];
    //il faudrait probablement retirer le premier pays de retour si on ne veut pas qu'il y ait deux fois le pays d'arrivée
    //on peut faire ca en modifiant les indices en dessous et en réduisant la taille de itineraire de 1
    for i:=0 to length(retour)-1 do
        voyage.itineraire[length(alle)+i]:=retour[i];
    //ajouter champ message dans TVoyage et l'afficher plus tard
    if not(verifDuree(itineraire,criteres)) then
        writeln('Il n''est pas possible de trouver un voyage en considérant à la fois les types d''activités choisies et la durée trop faible de votre séjour. Essayez, sans modifier vos préférences d''augmenter la durée du voyage.');
    genererActivitePays(itineraire,criteres);
    calculDistanceTotal(voyage);
    coutTotal(voyage);
    genererVoyage:=voyage;
end;
end.