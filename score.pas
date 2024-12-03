unit score;

interface
uses calculCout, constantes, utils, voyageTypes;

procedure scoreActivite(pref: array of TPref; coeffCout: Real; var activite: TActivite);
procedure triActPays(var pays: TPays);
function scoreActivitePays(pays: TPays; criteres: TCriteres; nbActParJour: Integer): Real;
procedure scorePays(coeffAct: Real; coeffClim: Real; criteres: TCriteres; nbActParJour: Integer; intervalleTemp: Real; var pays: TPays);
function poidsChemin(pays1: TPays; pays2: TPays): Real;
procedure paysVisites(inputPays: TEurope; var europe: TEurope);

function genererEtapes(itineraire: TEurope; criteres: TCriteres): TEtapes;
function genererJournees(etapes: TEtapes): TJournees;

implementation


{ Permet de calculer le score d'une activité en pourcentage, basé sur le respect des préférences et éventuellement du coût de l'activité
    @param(pref Le tableau des préférences choisies)
    @param(coeffCout Le coefficient qui permet de calculer la moyenne pondérée entre le scorePref et le scoreCout)
    @param(europe Le tableau de pays dans lequel chercher)
}
procedure scoreActivite(pref: array of TPref; coeffCout: Real; var activite: TActivite);
var i, j: Integer;
    scorePref, scoreCout, pasCoeff, somme, sommeCoeff: Real;
    trouve: Boolean;
begin

    somme := 0;
    sommeCoeff := 0;

    {Le scorePref est calculé sur le principe du nombre de critères respectés pondérés divisés par le nombre de critères pondéré.
    En effet on donne plus d'importance aux premiers critères, en lui donnant un poids plus élevé.
    pasCoeff permet de calculer le poids de chaque critère}
    pasCoeff := (COEFF_PREF_MAX - COEFF_PREF_MIN) / (length(pref) - 1);

    for i := 0 to length(pref) - 1 do
    begin
        trouve := False;
        for j := 0 to length(activite.categories) - 1 do
            if (pref[i] = activite.categories[j]) and not (trouve) then
            begin
                somme := somme + COEFF_PREF_MAX - pasCoeff * (i);
                trouve := True;
            end;
        sommeCoeff := sommeCoeff + COEFF_PREF_MAX - pasCoeff * (i);
    end;

    scorePref := somme / sommeCoeff;


    {Permet de calcuer scoreCout, dans le cas où l'utilisateur a sélectionné l'option budget
    Comme pour le score du climat, on utilise une parabole,f(cout)=1-(cout/100)² 
    donc le score est nul pour les activités dont le coût est supérieur à COUT_MAX}
    scoreCout := 1 - (activite.cout / COUT_MAX) * (activite.cout / COUT_MAX);
    if scoreCout < 0 then
        scoreCout := 0;

    //moyenne pondérée pour le score total de l'activité (coeff fixe de 1 pour scorePref)
    activite.score := (scorePref + coeffCout * scoreCout) / (1 + coeffCout);

end;


{ Permet de calculer le score lié au climat, en pourcentage, basé sur une fonction parabolique de la forme f(x)=a(x-xo)²+c (voir explication dans le rapport)
    @param(climat La température choisie)
    @param(periode La période choisie)
    @param(pays Le pays concerné)
    @param(intervalleTemp Fourchette de températures considérées)
    @return(Le score en pourcentage)
}
function scoreClimat(climat: Real; periode: TMois; pays: Tpays; intervalleTemp: Real): Real;
var a: Real;
begin
    a := -4 / (intervalleTemp * intervalleTemp);
    scoreClimat := a * (pays.climat[periode] - climat) * (pays.climat[periode] - climat) + 1;
    //cas où la température du pays sort de l'intervalle, donc quand la fonction renvoit
    //une valeur négative
    if scoreClimat < 0 then
        scoreClimat := 0;
end;

{ Permet de remplir le champ ordreAct dans un pays, qui stocke les indices des activités du pays dans l'ordre du meilleur score au moins bon
    @param(pays Le pays concerné)
}
procedure triActPays(var pays: TPays);
var
    tabIndice: array of Integer;
    indiceMax: Integer;
    scoreMax: Real;
    i, j, k: Integer;
begin
    //initialisation du tableau pour stocker les indices des meilleures activités
    setlength(tabIndice, length(pays.activites));
    setlength(pays.ordreAct, length(pays.activites));

    for i := 0 to length(pays.activites) - 1 do
        tabIndice[i] := i;

    //on attibue à la i ème case l'indice de l'activité avec le meilleur score du tableau
    for i := 0 to length(pays.activites) - 1 do
    begin

        //pas de scores négatifs donc -1 est la plus petite valeur
        scoreMax := -1;
        //cas où on ne trouve pas de score supérieur : il ne se passe rien
        indiceMax := i;

        //on cherche l'indice du meilleur score du tableau après les ièmes cases déjà triées
        for j := i to length(pays.activites) - 1 do
            if pays.activites[tabIndice[j]].score > scoreMax then
            begin
                scoreMax := pays.activites[tabIndice[j]].score;
                indiceMax := j;
            end;

        //on remplace l'indce max par le ième
        k := tabIndice[i];
        tabIndice[i] := tabIndice[indiceMax];
        tabIndice[indiceMax] := k;

    end;

    pays.ordreAct := tabIndice;

end;

{ Permet de calculer le score lié aux activités du pays, en pourcentage, basé sur la moyenne des scores des nbActParJour meilleures activités 
    @param(pays Le pays concerné)
    @param(criteres Les choix de l'utilisateur)
    @param(nbActParJour Nombre d'activités considérées pour le calcul)
    @return(Le score en pourcentage)
}
function scoreActivitePays(pays: TPays; criteres: TCriteres; nbActParJour: Integer): Real;
var
    somme: Real;
    i: Integer;
begin
    somme := 0;
    for i := 0 to nbActParJour - 1 do
        somme := somme + pays.activites[pays.ordreAct[i]].score;
    scoreActivitePays := somme / nbActParJour;
end;

{ Permet de calculer le nouveau score des pays traversés à l'aller, en les divisant par DIVISION_SCORE 
    @param(inputPays Les pays traversés pendant le trajet aller)
    @param(europe Tous les pays)
}
procedure paysVisites(inputPays: TEurope; var europe: TEurope);
var
    i, j: Integer;
begin

    for i := 0 to length(inputPays) - 1 do
        for j := 0 to length(europe) - 1 do
            if inputPays[i].nom = europe[j].nom then
                europe[j].score := europe[j].score / DIVISION_SCORE;
end;

{ Permet de calculer le score d'un pays, en pourcentage, basé sur la moyenne pondérée entre le score des activités du pays et le score du climat 
    @param(coeffAct Le pays concerné)
    @param(coeffClim Les choix de l'utilisateur)
    @param(criteres Les choix de l'utilisateur)
    @param(nbActParJour Nombre d'activités considérées pour le calcul)
    @param(intervalleTemp Fourchette de températures considérées))
    @param(pays Le pays concerné)
}
procedure scorePays(coeffAct: Real; coeffClim: Real; criteres: TCriteres; nbActParJour: Integer; intervalleTemp: Real; var pays: TPays);
begin
    pays.score := (scoreActivitePays(pays, criteres, nbActParJour) * coeffAct + scoreClimat(criteres.climat, criteres.periode, pays, intervalleTemp) * coeffClim) / (coeffAct + coeffClim);
end;


{ Permet de calculer le poids du chemin entre deux pays, en pourcentage, basé sur la moyenne des scores des deux pays 
    @param(pays1 Permier pays)
    @param(pays2 Deuxième pays)
    @return(Le score en pourcentage)
}
function poidsChemin(pays1: TPays; pays2: TPays): Real;
var poids: Real;
begin
    poids := (pays1.score + pays2.score) / 2;
    poidsChemin := poids;
    //idee de fonction:2xy/(x+y)
    //poids:=(pays1.score*pays2.score*2)/(pays1.score+pays2.score);
    //poidsChemin:=poids;

end;

// L'idée ici serait de calculer le temps total pouvant être alloué aux transports et aux activités en fonction de la durée du voyage des critères
// Notons dureeTotale cette durée. Afin d'augmenter la quantité d'activités "préférées" (= meilleur score), il faudrait attribuer une durée dans
// chaque pays proportionnelle au score. CàD : dureePays = (scorePays/totalScores) * dureeTotale
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
            for k := 0 to length(etapes[n].deplacement.paysDepart.nomAvions) - 1 do
                if etapes[n].deplacement.paysDepart.nomAvions[k] = etapes[n].deplacement.paysEtape.nom then
                begin
                    etapes[n].deplacement.transport := Avion;
                    break;
                end;

        etapes[n].deplacement.minutes := calculDureeTransport(etapes[n].deplacement.distance, etapes[n].deplacement.transport);
        dureeActivites := dureeActivites + etapes[n].deplacement.minutes;
        n := n + 1;

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

        if tempsAccumule + dureeEtape <= 10 * 60 then // 10h
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


end.

{function scoreClimat(climat:Real;periode:TMois;unPays:Tpays):Real;
var scoreClim:Real;
begin
    if unPays.climat[periode]>=climat then
        scoreClim:=1
    else
        //écart relatif pour le calcul du score dans le cas où le climat ne corrspond pas
        scoreClim:=1-Abs(climat-unPays.climat[periode])/climat;

    scoreClimat:=scoreClim;
end;}

{function scoreActivitePays(pays:TPays; pref:Array of TPref; nbActParJour:Integer):Real;
var
tabScore: Array of Real;
tabIndice: Array of Integer;
trouve: Boolean;
somme, scoreMin: Real;
i,j,k,indiceMin:Integer;
begin
    //initialisation du tableau pour stocker les meilleurs scores (pas de score négatif, donc 0 est la plus petite valeur)
    setlength(tabScore,nbActParJour);
    for i:=0 to nbActParJour-1 do
        tabScore[i]:=0;

    //initialisation du tableau pour stocker les indices des meilleures activités (-1 pour dire qu'il n'y a pas encore d'indice)
    setlength(tabIndice,nbActParJour);
    for i:=0 to nbActParJour-1 do
        tabIndice[i]:=-1;

    if length(pays.activites) > nbActParJour then
    begin
        for j:=0 to length(pays.activites)-1 do
        begin
            //recherche de la position du plus petit score dans le tableau score, qui sera remplacée par un meilleur score
            scoreMin:=tabScore[0];
            indiceMin:=0;
            //on commence à i=0 pour éviter une boucle inutile (l'indice min est intialisé à 0)
            for i:=1 to nbActParJour-1 do
            begin
                if tabScore[i] < scoreMin then
                begin
                    scoreMin:=tabScore[i];
                    indiceMin:=i;
                end;
            end;

            //vérification si l'activité étudiée a un score plus élevé que le plus petit score du tableau et qu'elle n'a pas déjà été sélectionnée
            if scoreActivite(pays.activites[j], pref) > scoreMin then
            begin
                trouve:=False;
                for k:=0 to nbActParJour - 1 do
                    if tabIndice[k] = j then
                        trouve:=True;
                if not(trouve) then
                begin
                    tabScore[indiceMin]:=scoreActivite(pays.activites[j], pref);
                    tabIndice[indiceMin]:=j;
                end;
            end;
        end;
    end
    else
        //cas où il y a moins d'activités que nbActParJour, c'est moyen et pas utile en pratique donc probablement à enlever
        for i := 0 to length(pays.activites) - 1 do
            tabScore[i] := scoreActivite(pays.activites[i], pref);


    //calcul de la moyenne des meilleurs scores
    somme := 0;
    for i := 0 to nbActParJour - 1 do
        somme := somme + tabScore[i];

    scoreActivitePays:=somme/nbActParJour;
end;}