{ Génération du voyage et de la composition des journées }
unit genererVoyage;

interface
uses calculCout, calculItineraire, constantes, score, utils, voyageTypes;

function generer(criteres: TCriteres; europe: TEurope): TVoyage;
function calculDureeMinimale(criteres: TCriteres; europe: TEurope): Integer;

implementation

{ Permet de choisir le mode de transport en fonction du pays de départ et de la destination
    @param(depart Le pays de départ)
    @param(etape Le pays de destination)
    @param(mode Le mode de transport choisi)
    @return(Le mode de transport choisi)
}
function choisirTransport(depart, etape: TPays; mode: TMode): TTransport;
var k: Integer;
begin
    choisirTransport := Train;
    if mode = TrainEtAvion then
    begin
        // Vérification si la destination est compris dans les frontières aériennes du pays de départ
        for k := 0 to length(depart.nomAvions) - 1 do
            if depart.nomAvions[k] = etape.nom then
                exit(Avion);

        // Vérification si le pays de départ est compris dans les frontières aériennes de la destination
        for k := 0 to length(etape.nomAvions) - 1 do
            if etape.nomAvions[k] = depart.nom then
                exit(Avion);
    end;
end;

{ Permet d'ajouter une étape de transport dans le tableau des étapes
    @param(etapes Le tableau des étapes)
    @param(compteur Le compteur d'étapes)
    @param(depart Le pays de départ)
    @param(etape Le pays de destination)
    @param(criteres Les choix de l'utilisateur)
}
procedure ajouterEtapeTransport(var etapes: TEtapes; var compteur: Integer; depart, etape: TPays; criteres: TCriteres);
begin
    setlength(etapes, compteur + 1);
    etapes[compteur].estActivite := False;
    etapes[compteur].deplacement.paysDepart := depart;
    etapes[compteur].deplacement.paysEtape := etape;
    etapes[compteur].deplacement.distance := calculDuneDistance(depart.latitude, depart.longitude, etape.latitude, etape.longitude);

    etapes[compteur].deplacement.transport := choisirTransport(depart, etape, criteres.modeTransport);
    etapes[compteur].deplacement.minutes := calculDureeTransport(etapes[compteur].deplacement.distance, etapes[compteur].deplacement.transport);
end;

{ Permet d'ajouter une étape d'activité dans le tableau des étapes
    @param(etapes Le tableau des étapes)
    @param(compteur Le compteur d'étapes)
    @param(activite L'activité à ajouter)
}
procedure ajouterEtapeActivite(var etapes: TEtapes; var compteur: Integer; activite: TActivite);
begin
    setlength(etapes, compteur + 1);
    etapes[compteur].estActivite := true;
    etapes[compteur].activite := activite;
end;

{ Permet de générer toutes les étapes du voyage, basé sur un calcul de durée totale dans un pays. Puis on attribue les meilleures activités dans le temps disponible
    @param(itineraire Tous les pays traversés)
    @param(criteres Les choix de l'utilisateur)
    @return(Le tableau de toutes les étapes)
}
function genererEtapes(itineraire: TEurope; criteres: TCriteres): TEtapes;
var
    dureeTotale, dureePays, dureeActivites: Integer;
    totalScores: Real;
    compteurEtapes, nbAct, indexPays: Integer;
    etapes: TEtapes;
    activitesUtilisees: array of array of Boolean;
begin
    // Calcul des scores totaux et durée totale en minutes
    dureeTotale := criteres.duree * HEURES_PAR_JOUR * 60;
    totalScores := 0;
    for indexPays := 1 to length(itineraire) - 1 do
        totalScores := totalScores + itineraire[indexPays].score;

    // Initialisation
    compteurEtapes := 0;
    setlength(etapes, 0);
    setlength(activitesUtilisees, length(itineraire));
    for indexPays := 0 to length(itineraire) - 1 do
        setlength(activitesUtilisees[indexPays], length(itineraire[indexPays].activites));

    for indexPays := 1 to length(itineraire) - 1 do
    begin
        // Ce cas arrive lorsque l'on fait "demi-tour" dans un pays
        if itineraire[indexPays - 1].nom = itineraire[indexPays].nom then
            continue;

        // On détermine le temps maximal à passer dans le pays
        dureePays := round((itineraire[indexPays].score / totalScores) * dureeTotale);
        dureeActivites := 0;

        // Ajouter un déplacement
        ajouterEtapeTransport(etapes, compteurEtapes, itineraire[indexPays - 1], itineraire[indexPays], criteres);
        dureeActivites := dureeActivites + etapes[compteurEtapes].deplacement.minutes;
        compteurEtapes := compteurEtapes + 1;

        // Ajouter des activités
        nbAct := 0;
        while (dureeActivites < dureePays - 180) and (nbAct < length(itineraire[indexPays].activites)) do
        begin
            // On s'assure que l'activité n'a pas déjà été utilisée
            if activitesUtilisees[indexPays][nbAct] then
            begin
                nbAct := nbAct + 1;
                continue;
            end;

            ajouterEtapeActivite(etapes, compteurEtapes, itineraire[indexPays].activites[nbAct]);
            dureeActivites := dureeActivites + etapes[compteurEtapes].activite.minutes;

            // On marque l'activité comme utilisée
            activitesUtilisees[indexPays][nbAct] := true;
            compteurEtapes := compteurEtapes + 1;
            nbAct := nbAct + 1;
        end;
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
        // Si la journée est pleine, on passe à la suivante
            journee.jour := nJour + 1;
            setlength(journees, length(journees) + 1);
            journees[length(journees) - 1] := journee;

            nJour := nJour + 1;
            tempsAccumule := dureeEtape;

            setlength(journee.etapes, 1);
            journee.etapes[0] := etapes[i];
        end;
    end;

    // Ajout de la dernière journée si elle n'est pas vide
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
        // Calcul des scores des activités
        for j := 0 to length(europe[i].activites) - 1 do
            scoreActivite(criteres.categories, criteres.coeffCout, europe[i].activites[j]);

        // Tri des activités par score
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
        // Calcul du score du pays
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

    //On divise le score des pays dans lesquels on est déjà passé
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

    // On construit l'itinéraire complet
    setlength(voyage.itineraire, (length(aller.itineraire) + length(retour.itineraire)));
    for i := 0 to length(aller.itineraire) - 1 do
        voyage.itineraire[i] := aller.itineraire[i];

    for i := 0 to length(retour.itineraire) - 1 do
        voyage.itineraire[length(aller.itineraire) + i] := retour.itineraire[i];

    // On génère les étapes et les journées
    voyage.etapes := genererEtapes(voyage.itineraire, criteres);
    voyage.planning := genererJournees(voyage.etapes);

    // Calcul des différents coûts
    calculDistanceTotal(voyage);
    coutTotal(voyage, criteres);
    coutCarbone(voyage, criteres);

    generer := voyage;
end;


{ Permet de calculer la durée minimale du voyage avec les critères renseignés, qui correspond à 1 jour pour 1 pays
    @param(criteres Les choix de l'utilisateur)
    @param(europe Tous les pays)
    @return(La durée minimale, -1 si une erreur est survenue)
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
