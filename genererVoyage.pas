unit genererVoyage;

interface
uses voyageTypes, triDesPays, calculItineraire, calculCout, score;

function generer(criteres: TCriteres; europe: TEurope): TVoyage;

implementation

function generer(criteres: TCriteres; europe: TEurope): TVoyage;
var aller,retour: TItineraireResult;
    voyage:TVoyage;
    i:Integer;
begin
    voyage.erreur := false;
    voyage.message := '';

    for i:=0 to length(europe)-1 do 
        scorePays(1,1,criteres,1,1,europe[i]);

    //
    // ** Génération itinéraire aller **
    //
    writeln('Calcul de l''itinéraire aller...');
    aller := calculerItineraire(europe, criteres.paysDepart, criteres.paysArrivee);
    if aller.erreur then
    begin
        voyage.erreur := true;
        voyage.message := 'Une erreur est survenue lors de la génération de l''itinéraire : ' + aller.message;
        exit(voyage);
    end;

    writeln('Itinéraire aller généré :');
    for i:=0 to length(aller.itineraire)-1 do writeln('- ', aller.itineraire[i].nom);

    paysVisites(1, aller.itineraire);

    //
    // ** Génération itinéraire retour **
    //
    writeln('Calcul de l''itinéraire retour...');
    retour:=calculerItineraire(europe, criteres.paysArrivee, criteres.paysDepart);
    if retour.erreur then
    begin
        voyage.erreur := true;
        voyage.message := 'Une erreur est survenue lors de la génération de l''itinéraire : ' + retour.message;
        exit(voyage);
    end;

    writeln('Itinéraire retour généré :');
    for i:=0 to length(retour.itineraire)-1 do writeln('- ', retour.itineraire[i].nom);

    setlength(voyage.itineraire,(length(aller.itineraire)+length(retour.itineraire)));
    for i:=0 to length(aller.itineraire)-1 do
        voyage.itineraire[i]:=aller.itineraire[i];
    //il faudrait probablement retirer le premier pays de retour si on ne veut pas qu'il y ait deux fois le pays d'arrivée
    //on peut faire ca en modifiant les indices en dessous et en réduisant la taille de itineraire de 1
    for i:=0 to length(retour.itineraire)-1 do
        voyage.itineraire[length(aller.itineraire)+i]:=retour.itineraire[i];
    //ajouter champ message dans TVoyage et l'afficher plus tard
    if not(verifDuree(voyage.itineraire,criteres)) then
    begin
        voyage.erreur := true;
        voyage.message := 'Il n''est pas possible de trouver un voyage en considérant à la fois les types d''activités choisies et la durée trop faible de votre séjour. Essayez, sans modifier vos préférences d''augmenter la durée du voyage.';
        exit(voyage);
    end;
    voyage.planning := genererActivitePays(voyage.itineraire, criteres);
    calculDistanceTotal(voyage);
    coutTotal(voyage);
    generer:=voyage;
end;
end.