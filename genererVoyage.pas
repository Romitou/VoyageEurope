unit genererVoyage;

interface
uses voyageTypes, triDesPays, calculItineraire, calculCout;

function generer(criteres: TCriteres; europe: TEurope): TVoyage;

implementation

function generer(criteres: TCriteres; europe: TEurope): TVoyage;
var listePaysValables,aller,retour:TEurope;
    voyage:TVoyage;
    i:Integer;
begin
    //
    // ** Filtrage des pays **
    //
    writeln('Filtrage des pays (', length(europe), ' pays)...');
    listePaysValables:=filtrerPays(criteres,europe);
    writeln('Pays filtrés (', length(listePaysValables), ' pays compatibles).');
    // TODO: Gérer si listePaysValables est vide => les algorithmes ne fonctionneront pas

    //
    // ** Génération itinéraire aller **
    //
    writeln('Calcul de l''itinéraire aller...');
    aller:=calculerItineraire(listePaysValables,criteres);
    writeln('Itinéraire aller généré :');
    for i:=0 to length(aller)-1 do writeln('- ', aller[i].nom);

    //
    // ** Suppression pays visités **
    //
    writeln('Suppression des pays visités (', length(listePaysValables), ' pays)...');
    listePaysValables:=suppressionPaysVisite(listePaysValables,aller);
    writeln('Pays visités supprimés (', length(listePaysValables), ' pays restants).');

    //
    // ** Génération itinéraire retour **
    //
    writeln('Calcul de l''itinéraire retour...');
    retour:=calculerItineraire(listePaysValables,criteres);
    writeln('Itinéraire retour généré :');
    for i:=0 to length(retour)-1 do writeln('- ', retour[i].nom);

    setlength(voyage.itineraire,(length(aller)+length(retour)));
    for i:=0 to length(aller)-1 do
        voyage.itineraire[i]:=aller[i];
    //il faudrait probablement retirer le premier pays de retour si on ne veut pas qu'il y ait deux fois le pays d'arrivée
    //on peut faire ca en modifiant les indices en dessous et en réduisant la taille de itineraire de 1
    for i:=0 to length(retour)-1 do
        voyage.itineraire[length(aller)+i]:=retour[i];
    //ajouter champ message dans TVoyage et l'afficher plus tard
    if not(verifDuree(voyage.itineraire,criteres)) then
        writeln('Il n''est pas possible de trouver un voyage en considérant à la fois les types d''activités choisies et la durée trop faible de votre séjour. Essayez, sans modifier vos préférences d''augmenter la durée du voyage.');
    genererActivitePays(voyage.itineraire,criteres);
    calculDistanceTotal(voyage);
    coutTotal(voyage);
    generer:=voyage;
end;
end.