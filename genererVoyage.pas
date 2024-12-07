unit genererVoyage;

interface
uses calculCout, calculItineraire, score, voyageTypes, constantes, utils;

function generer(criteres: TCriteres; europe: TEurope): TVoyage;
function calculDureeMinimale(criteres: TCriteres; europe: TEurope): Integer;

implementation


{ Permet de générer toutes les étapes du voyage, basé sur un calcul de durée totale dans un pays. Puis on attribue les meilleures activités dans le temps disponible
    @param(itineraire Tous les pays traversés)
    @param(criteres Les choix de l'utilisateur)
    @return(Le tableau de toutes les étapes)
}
function genererEtapes(itineraire: TEurope; criteres: TCriteres): TEtapes;
var
    dureePays, dureeTotale, dureeActivites: Integer;
    totalScores: Real;
    i, j, k, nbAct, n: Integer;
    etapes: TEtapes;
    activitesUtilisees: array of array of Boolean;
    indexPays: Integer;
begin
    dureeTotale := criteres.duree * HEURES_PAR_JOUR * 60;

    totalScores := 0;
    for i := 1 to length(itineraire) - 1 do
        totalScores := totalScores + itineraire[i].score;

    n := 0;
    setlength(etapes, 0);
    setlength(activitesUtilisees, length(itineraire));
    for i := 0 to length(itineraire) - 1 do
        setlength(activitesUtilisees[i], length(itineraire[i].activites));

    for j := 1 to length(itineraire) - 1 do
    begin
        indexPays := trouverIndexPays(itineraire[j].nom, itineraire);
        // L'idée ici serait de calculer le temps total pouvant être alloué aux transports et aux activités en fonction de la durée du voyage des critères
        // Notons dureeTotale cette durée. Afin d'augmenter la quantité d'activités "préférées" (= meilleur score), il faudrait attribuer une durée dans
        // chaque pays proportionnelle au score. CàD : dureePays = (scorePays/totalScores) * dureeTotale
        dureePays := round((itineraire[j].score / totalScores) * dureeTotale);

        dureeActivites := 0;
        nbAct := 0;
        // Si on souhaite éviter les doublons (si besoin dans un cas futur)
        if ((itineraire[j - 1].nom = itineraire[j].nom)) then
            continue;

        setlength(etapes, n + 1);
        etapes[n].estActivite := false;
        etapes[n].deplacement.paysDepart := itineraire[j - 1];
        etapes[n].deplacement.paysEtape := itineraire[j];
        etapes[n].deplacement.distance := calculDuneDistance(itineraire[j - 1].latitude, itineraire[j - 1].longitude, itineraire[j].latitude, itineraire[j].longitude);

        etapes[n].deplacement.transport := Train;
        if criteres.modeTransport = TrainEtAvion then
        begin
            for k := 0 to length(etapes[n].deplacement.paysDepart.nomAvions) - 1 do
                if etapes[n].deplacement.paysDepart.nomAvions[k] = etapes[n].deplacement.paysEtape.nom then
                begin
                    etapes[n].deplacement.transport := Avion;
                    break;
                end;
            if etapes[n].deplacement.transport = Train then
                for k := 0 to length(etapes[n].deplacement.paysEtape.nomAvions) - 1 do
                    if etapes[n].deplacement.paysEtape.nomAvions[k] = etapes[n].deplacement.paysDepart.nom then
                    begin
                        etapes[n].deplacement.transport := Avion;
                        break;
                    end;
        end;

        etapes[n].deplacement.minutes := calculDureeTransport(etapes[n].deplacement.distance, etapes[n].deplacement.transport);
        dureeActivites := dureeActivites + etapes[n].deplacement.minutes;
        n := n + 1;

        //on ne choisit pas des activités déjà séléctionnées dans un pays où on serait déjà passé
        repeat
            while (nbAct < length(itineraire[j].activites)) and (activitesUtilisees[indexPays][itineraire[j].ordreAct[nbAct]]) do
                nbAct := nbAct + 1;

            if nbAct >= length(itineraire[j].activites) then
                break;

            setlength(etapes, n + 1);
            etapes[n].estActivite := true;
            etapes[n].activite := itineraire[j].activites[itineraire[j].ordreAct[nbAct]];

            activitesUtilisees[indexPays][itineraire[j].ordreAct[nbAct]] := true;

            dureeActivites := dureeActivites + etapes[n].activite.minutes;
            n := n + 1;
            nbAct := nbAct + 1;
        until (dureeActivites >= (dureePays - 180));
    end;

    genererEtapes := etapes;
end;

{ Permet de générer les journées à partir des étapes, utiliées pour afficher le voyage
    @param(etapes Le tableau de toutes les étapes du voyage)
    @return(Le tableau de toutes les journées du voyage)
}
function genererJournees(etapes: TEtapes): TJournees;
var
    i, nJour, tempsAccumule, dureeEtape: Integer;
    journee: TJournee;
    journees: TJournees;
begin
    nJour := 0;
    tempsAccumule := 0;
    setlength(journees, 0);

    setlength(journee.etapes, 0);

    for i := 0 to length(etapes) - 1 do
    begin
        if etapes[i].estActivite then
            dureeEtape := etapes[i].activite.minutes
        else
            dureeEtape := etapes[i].deplacement.minutes;

        //Détermination des journées en fonction de la durée des étapes (déplacement et activités)
        if tempsAccumule + dureeEtape <= HEURES_PAR_JOUR * 60 then
        begin
            setlength(journee.etapes, length(journee.etapes) + 1);
            journee.etapes[length(journee.etapes) - 1] := etapes[i];
            tempsAccumule := tempsAccumule + dureeEtape;
        end
        else begin
            journee.jour := nJour + 1;
            setlength(journees, length(journees) + 1);
            journees[length(journees) - 1] := journee;

            nJour := nJour + 1;
            tempsAccumule := dureeEtape;

            setlength(journee.etapes, 1);
            journee.etapes[0] := etapes[i];
        end;
    end;

    if length(journee.etapes) > 0 then
    begin
        journee.jour := nJour + 1;
        setlength(journees, length(journees) + 1);
        journees[length(journees) - 1] := journee;
    end;

    genererJournees := journees;
end;

{ Permet de remplir tous les champs de voyage, prêt à être affiché 
    @param(critères Les choix de l'utilisateur)
    @param(europe Tous les pays)
    @return(Le voyage complet)
}
function generer(criteres: TCriteres; europe: TEurope): TVoyage;
var aller, retour: TItineraireResult;
    voyage: TVoyage;
    i, j: Integer;
begin
    voyage.modeTransport := criteres.modeTransport;
    voyage.erreur := false;
    voyage.message := '';

    if MODE_DEBUG then
        writeln('Classement activités...');
    for i := 0 to length(europe) - 1 do
    begin
        for j := 0 to length(europe[i].activites) - 1 do
            scoreActivite(criteres.categories, criteres.coeffCout, europe[i].activites[j]);

        triActPays(europe[i]);


        if MODE_DEBUG then
        begin
            for j := 0 to length(europe[i].ordreAct) - 1 do
                writeln(europe[i].activites[europe[i].ordreAct[j]].nom, ' : ', europe[i].activites[europe[i].ordreAct[j]].score);

            writeln('scoreAct : ', scoreActivitePays(europe[i], criteres));
            writeln('');
            writeln('pays suivant');
            writeln('');

        end;
    end;


    if MODE_DEBUG then
        writeln('Calcul des scores des pays...');
    for i := 0 to length(europe) - 1 do
    begin
        scorePays(criteres, europe[i]);

        if MODE_DEBUG then
            writeln(europe[i].nom, ' : ', europe[i].score);
    end;


    // ** Génération itinéraire aller **

    if MODE_DEBUG then
        writeln('Calcul de l''itinéraire aller...');
    aller := calculerItineraire(europe, criteres.paysDepart, criteres.paysArrivee, criteres.modeTransport);
    if aller.erreur then
    begin
        voyage.erreur := true;
        voyage.message := string('Une erreur est survenue lors de la génération de l''itinéraire : ') + aller.message;
        exit(voyage);
    end;

    if MODE_DEBUG then
    begin
        writeln('Itinéraire aller généré :');
        for i := 0 to length(aller.itineraire) - 1 do writeln('- ', aller.itineraire[i].nom);
    end;

    //On divise le score des pays dans lesquel on est déjà passé
    paysVisites(aller.itineraire, europe);

    if MODE_DEBUG then
        for i := 0 to length(europe) - 1 do
            writeln(europe[i].nom, ' : ', europe[i].score);


    // ** Génération itinéraire retour **

    if MODE_DEBUG then
        writeln('Calcul de l''itinéraire retour...');
    retour := calculerItineraire(europe, criteres.paysArrivee, criteres.paysDepart, criteres.modeTransport);
    if retour.erreur then
    begin
        voyage.erreur := true;
        voyage.message := string('Une erreur est survenue lors de la génération de l''itinéraire : ') + retour.message;
        exit(voyage);
    end;

    if MODE_DEBUG then
    begin
        writeln('Itinéraire retour généré :');
        for i := 0 to length(retour.itineraire) - 1 do writeln('- ', retour.itineraire[i].nom);
    end;

    setlength(voyage.itineraire, (length(aller.itineraire) + length(retour.itineraire)));
    for i := 0 to length(aller.itineraire) - 1 do
        voyage.itineraire[i] := aller.itineraire[i];
   
    for i := 0 to length(retour.itineraire) - 1 do
        voyage.itineraire[length(aller.itineraire) + i] := retour.itineraire[i];

    voyage.etapes := genererEtapes(voyage.itineraire, criteres);
    voyage.planning := genererJournees(voyage.etapes);

    calculDistanceTotal(voyage);

    coutTotal(voyage,criteres);

    coutCarbone(voyage,criteres);

    generer := voyage;
end;


{ Permet de calculer la durée minimale du voyage avec les critères renseignés, qui correspond à 1 jour pour 1 pays
    @param(criteres Les choix de l'utilisateur)
    @param(europe Tous les pays)
    @return(La durée minimale)
}
function calculDureeMinimale(criteres: TCriteres; europe: TEurope): Integer;
var aller, retour: TItineraireResult;
    i, j: Integer;
begin
    for i := 0 to length(europe) - 1 do
    begin
        for j := 0 to length(europe[i].activites) - 1 do
            scoreActivite(criteres.categories, criteres.coeffCout, europe[i].activites[j]);
        triActPays(europe[i]);
    end;

    for i := 0 to length(europe) - 1 do
        scorePays(criteres, europe[i]);

    aller := calculerItineraire(europe, criteres.paysDepart, criteres.paysArrivee, criteres.modeTransport);
    if aller.erreur then
    begin
        calculDureeMinimale := -1;
        exit(calculDureeMinimale);
    end;

    paysVisites(aller.itineraire, europe);

    retour := calculerItineraire(europe, criteres.paysArrivee, criteres.paysDepart, criteres.modeTransport);
    if retour.erreur then
    begin
        calculDureeMinimale := -1;
        exit(calculDureeMinimale);
    end;

    calculDureeMinimale := length(aller.itineraire) + length(retour.itineraire);
end;

end.
