unit genererVoyage;

interface
uses voyageTypes,TriDesPays,calculItineraire,CalculCout;

function generer(criteres: TCriteres; europe: TEurope): TVoyage;

implementation

function generer(criteres: TCriteres; europe: TEurope): TVoyage;
var listePaysValables,aller,retour,itineraire:TEurope;
voyage:TVoyage;
i:Integer;
begin

    listePaysValables:=filtrerPays(criteres,europe);
    // TODO: Gérer si listePaysValables est vide => les algorithmes ne fonctionneront pas
    aller:=calculerItineraire(listePaysValables,criteres);
    listePaysValables:=suppressionPaysVisite(listePaysValables,aller);
    retour:=calculerItineraire(listePaysValables,criteres);
    setlength(itineraire,(length(aller)+length(retour)));
    for i:=0 to length(aller)-1 do
        voyage.itineraire[i]:=aller[i];
    //il faudrait probablement retirer le premier pays de retour si on ne veut pas qu'il y ait deux fois le pays d'arrivée
    //on peut faire ca en modifiant les indices en dessous et en réduisant la taille de itineraire de 1
    for i:=0 to length(retour)-1 do
        voyage.itineraire[length(aller)+i]:=retour[i];
    //ajouter champ message dans TVoyage et l'afficher plus tard
    if not(verifDuree(itineraire,criteres)) then
        writeln('Il n''est pas possible de trouver un voyage en considérant à la fois les types d''activités choisies et la durée trop faible de votre séjour. Essayez, sans modifier vos préférences d''augmenter la durée du voyage.');
    genererActivitePays(itineraire,criteres);
    calculDistanceTotal(voyage);
    coutTotal(voyage);
    generer:=voyage;
end;
end.