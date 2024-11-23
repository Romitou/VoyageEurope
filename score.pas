unit score;

interface
uses voyageTypes, calculCout;

function scoreActivite(activite:TActivite;pref:Array of TPref):Real;
procedure triActPays(pref:Array of TPref;var pays:TPays);
function scoreClimat(climat:Real;periode:TMois;pays:Tpays;fourchette:Real):Real;
function scoreActivitePays(pays:TPays;pref:Array of TPref; nbActParJour:Integer):Real;
procedure scorePays (coeffAct:Real;coeffClim:Real;criteres:TCriteres;nbActParJour:Integer;intervalleTemp:Real; var pays:TPays);
function poidsChemin(pays1:TPays;pays2:TPays):Real;
procedure paysVisites(coeff:Real; inputPays:TEurope;var europe: TEurope);
function genererEtapes(itineraire: TEurope; criteres: TCriteres; nbActParJour:Integer): TEtapes;
function genererJournees(etapes: TEtapes): TJournees;

implementation

function scoreActivite(activite:TActivite;pref:Array of TPref):Real;
var i,j,nbPrefVerifiee:Integer;
trouve:Boolean;
begin
    nbPrefVerifiee:=0;
    for i:=0 to length(pref)-1 do
        begin
        trouve:=False;
        for j:=0 to length(activite.categories)-1 do
            if (pref[i]=activite.categories[j]) and not(trouve) then
                begin
                nbPrefVerifiee:=nbPrefVerifiee+1;
                trouve:=True;
                end;
        end;

    scoreActivite:=nbPrefVerifiee/length(pref);
end;

{On utilise une fonction parabolique de la forme f(x)=a(x-xo)²+c
avec c=1 et a<0 car le score diminue plus il s'éloigne de xo.
xo correspond à la température souhaitée soit climat ici.
x correspond au climat du pays, donc pays.climat[periode] ici.
a=-4/F² avec F la fourchette (la distance entre les deux racines) des valeurs qu'on veut regarder
on trouve ca en calculant les racines du polynome}

function scoreClimat(climat:Real;periode:TMois;pays:Tpays;fourchette:Real):Real;
var a:Real;
begin
    a:=-4/(fourchette*fourchette);
    scoreClimat:=a*(pays.climat[periode]-climat)*(pays.climat[periode]-climat)+1;
    //cas où la température du pays sort de la fourchette, donc quand la fonction renvoit
    //une valeur négative
    if scoreClimat<0 then
        scoreClimat:=0;
end;

procedure triActPays(pref:Array of TPref;var pays:TPays);
var
tabIndice: Array of Integer;
indiceMax:Integer;
scoreMax: Real;
i,j,k:Integer;
begin
    //initialisation du tableau pour stocker les indices des meilleures activités
    setlength(tabIndice,length(pays.activites));
    setlength(pays.ordreAct,length(pays.activites));

    for i:=0 to length(pays.activites)-1 do
            tabIndice[i]:=i;

    //on attibue à la i ème case l'indice de l'activité avec le meilleur score du tableau
    for i:=0 to length(pays.activites)-1 do
    begin

        //pas de scores négatifs donc -1 est la plus petite valeur
        scoreMax:=-1;
        //cas où on ne trouve pas de score supérieur : il ne se passe rien
        indiceMax:=i;

        //on cherche l'indice du meilleur score du tableau après les ièmes cases déjà triées
        for j:=i to length(pays.activites)-1 do
        begin
            if scoreActivite(pays.activites[tabIndice[j]],pref)>scoreMax then
            begin
                scoreMax:=scoreActivite(pays.activites[tabIndice[j]],pref);
                indiceMax:=j;
            end;

        end;

        //on remplace l'indce max par le ième
        k := tabIndice[i];
        tabIndice[i] := tabIndice[indiceMax];
        tabIndice[indiceMax] := k;


    end;

    pays.ordreAct:=tabIndice;

end;


function scoreActivitePays(pays:TPays;pref:Array of TPref; nbActParJour:Integer):Real;
var
somme:Real;
i:Integer;
begin
    somme:=0;
    for i:=0 to nbActParJour-1 do
        begin
        somme:=somme + scoreActivite(pays.activites[pays.ordreAct[i]],pref);
        end;
    scoreActivitePays:=somme/nbActParJour;
end;

procedure paysVisites(coeff:Real; inputPays:TEurope;var europe: TEurope);
var
    i,j: Integer;
begin

    for i := 0 to length(inputPays) - 1 do
        for j:=0 to length(europe)-1 do
            if inputPays[i].nom=europe[j].nom then
                europe[j].score:=europe[j].score/coeff;
end;

procedure scorePays (coeffAct:Real;coeffClim:Real;criteres:TCriteres;nbActParJour:Integer;intervalleTemp:Real; var pays:TPays);
begin
    pays.score:=(scoreActivitePays(pays,criteres.categories,nbActParJour)*coeffAct+scoreClimat(criteres.climat,criteres.periode,pays,intervalleTemp)*coeffClim)/(coeffAct+coeffClim);
end;


{pour l'instant, on prend la moyenne comme fonction, mais quand on changera de fonction math, poidsChemin aura plus d'intérêt}
function poidsChemin(pays1:TPays;pays2:TPays):Real;
var poids:Real;
begin
    poids:=(pays1.score+pays2.score)/2;
    poidsChemin:=poids;
    //idee de fonction:2xy/(x+y)
    //poids:=(pays1.score*pays2.score*2)/(pays1.score+pays2.score);
    //poidsChemin:=poids;

end;

// L'idée ici serait de calculer le temps total pouvant être alloué aux transports et aux activités en fonction de la durée du voyage des critères
// Notons dureeTotale cette durée. Afin d'augmenter la quantité d'activités "préférées" (= meilleur score), il faudrait attribuer une durée dans
// chaque pays proportionnelle au score. CàD : dureePays = (scorePays/totalScores) * dureeTotale
function genererEtapes(itineraire: TEurope; criteres: TCriteres; nbActParJour:Integer): TEtapes;
var
    dureePays, dureeTotale, dureeActivites: Integer;
    totalScores: Real;
    i, j, nbAct, n: Integer;
    etapes: TEtapes;
begin
    dureeTotale := criteres.duree * 6 * 60; // à modifier

    totalScores := 0;
    for i := 1 to length(itineraire) - 1 do
        totalScores := totalScores + itineraire[i].score;

    n := 0;
    setlength(etapes, 0);

    for j := 1 to length(itineraire) - 1 do
    begin
        dureePays := round((itineraire[i].score / totalScores) * dureeTotale);
        writeln('durée pays : ', dureePays);

        dureeActivites := 0;
        nbAct := 0;
        // Si on souhaite éviter les doublons (si besoin dans un cas futur)
        if not ((itineraire[j - 1].nom = itineraire[j].nom)) then
        begin
            setlength(etapes, n + 1);
            etapes[n].estActivite := false;
            etapes[n].deplacement.paysDepart := itineraire[j - 1];
            etapes[n].deplacement.paysEtape := itineraire[j];
            etapes[n].deplacement.distance := calculDuneDistance(itineraire[j - 1].latitude, itineraire[j - 1].longitude, itineraire[j].latitude, itineraire[j].longitude);
            etapes[n].deplacement.minutes := calculDureeTransport(etapes[n].deplacement.distance, criteres.transport);
            dureeActivites := dureeActivites + etapes[n].deplacement.minutes;
            n := n + 1;
        end;

        repeat
            setlength(etapes, n + 1);
            etapes[n].estActivite := true;
            etapes[n].activite := itineraire[j].activites[itineraire[j].ordreAct[nbAct]];
            dureeActivites := dureeActivites + etapes[n].activite.minutes;
            n := n + 1;
            nbAct := nbAct + 1;
        until (dureeActivites >= (dureePays - 300)); // TODO: revoir le -300 QUID ? prendre l'activité avec max temps ? jsp

        {for i := 0 to length(itineraire[j].activites) - 1 do
        begin
            if matchPreference(itineraire[j].activites[i], criteres.categories) and (nbAct < 2) then
            begin
                etapes[jour].activite[nbAct] := itineraire[j].activites[i];
                nbAct := nbAct + 1;
            end;
        end;}
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

        if tempsAccumule + dureeEtape <= 300 then
        begin
            setlength(journee.etapes, length(journee.etapes) + 1);
            journee.etapes[length(journee.etapes) - 1] := etapes[i];
            tempsAccumule := tempsAccumule + dureeEtape;
        end
        else
        begin
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
