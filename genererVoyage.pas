unit genererVoyage;

interface
uses calculCout, calculItineraire, score, voyageTypes;

function generer(criteres: TCriteres; europe: TEurope): TVoyage;

implementation

function generer(criteres: TCriteres; europe: TEurope): TVoyage;
var aller, retour: TItineraireResult;
    voyage: TVoyage;
    i, j: Integer;
begin
    voyage.modeTransport := criteres.modeTransport;
    voyage.erreur := false;
    voyage.message := '';

    writeln('Classement activités...');
    for i := 0 to length(europe) - 1 do
    begin
        for j := 0 to length(europe[i].activites) - 1 do
            scoreActivite(criteres.categories, 0, europe[i].activites[j]);

        triActPays(criteres, europe[i]);

        for j := 0 to length(europe[i].ordreAct) - 1 do
            writeln(europe[i].activites[europe[i].ordreAct[j]].nom, ' : ', europe[i].activites[europe[i].ordreAct[j]].score);

        writeln('scoreAct : ', scoreActivitePays(europe[i], criteres, 3));
        writeln('');
        writeln('pays suivant');
        writeln('');

    end;


    writeln('Calcul des scores des pays...');
    for i := 0 to length(europe) - 1 do
    begin
        //attention, coeff non définitif, utilisés pour test, remettre à 1,1,criteres,2,20,europe[i] pour les critères de base
        scorePays(1, 0, criteres, 2, 20, europe[i]);
        writeln(europe[i].nom, ' : ', europe[i].score);
    end;


    // ** Génération itinéraire aller **

    writeln('Calcul de l''itinéraire aller...');
    aller := calculerItineraire(europe, criteres.paysDepart, criteres.paysArrivee, criteres.modeTransport);
    if aller.erreur then
    begin
        voyage.erreur := true;
        voyage.message := string('Une erreur est survenue lors de la génération de l''itinéraire : ') + aller.message;
        exit(voyage);
    end;

    writeln('Itinéraire aller généré :');
    for i := 0 to length(aller.itineraire) - 1 do writeln('- ', aller.itineraire[i].nom);

    paysVisites(aller.itineraire, europe);

    for i := 0 to length(europe) - 1 do
        writeln(europe[i].nom, ' : ', europe[i].score);


    // ** Génération itinéraire retour **

    writeln('Calcul de l''itinéraire retour...');
    retour := calculerItineraire(europe, criteres.paysArrivee, criteres.paysDepart, criteres.modeTransport);
    if retour.erreur then
    begin
        voyage.erreur := true;
        voyage.message := string('Une erreur est survenue lors de la génération de l''itinéraire : ') + retour.message;
        exit(voyage);
    end;

    writeln('Itinéraire retour généré :');
    for i := 0 to length(retour.itineraire) - 1 do writeln('- ', retour.itineraire[i].nom);

    setlength(voyage.itineraire, (length(aller.itineraire) + length(retour.itineraire)));
    for i := 0 to length(aller.itineraire) - 1 do
        voyage.itineraire[i] := aller.itineraire[i];
    //il faudrait probablement retirer le premier pays de retour si on ne veut pas qu'il y ait deux fois le pays d'arrivée
    //on peut faire ca en modifiant les indices en dessous et en réduisant la taille de itineraire de 1
    for i := 0 to length(retour.itineraire) - 1 do
        voyage.itineraire[length(aller.itineraire) + i] := retour.itineraire[i];
    //ajouter champ message dans TVoyage et l'afficher plus tard
    if length(voyage.itineraire) > criteres.duree then
    begin
        voyage.erreur := true;
        voyage.message := 'Il n''est pas possible de trouver un voyage en considérant à la fois les types d''activités choisies et la durée trop faible de votre séjour. Essayez, sans modifier vos préférences d''augmenter la durée du voyage.';
        exit(voyage);
    end;
    voyage.etapes := genererEtapes(voyage.itineraire, criteres);
    voyage.planning := genererJournees(voyage.etapes);
    calculDistanceTotal(voyage);
    coutTotal(voyage);
    coutCarbone(voyage);
    generer := voyage;
end;
end.
