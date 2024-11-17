unit score;

interface
uses voyageTypes;

function scoreActivite(activite:TActivite;pref:Array of TPref):Real;
procedure scoreClimat(climat:Real;unPays:Tpays;periode:TMois;coeff:Real);
procedure scoreActivitePays(var pays:TPays;pref:Array of TPref;nbActParJour:Integer);
procedure paysVisites(inputPays: TEurope;coeff:Real);
function poidsChemin(pays1:TPays;pays2:TPays):Real;

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

{à appeler apres avoir calculé le score des pays en fonction des activités (scoreActivitePays)
pour pouvoir ensuite faire une
moyenne pondérée avec le coeff pour le score du climat et 1 pour le score du pays}
procedure scoreClimat(climat:Real;unPays:Tpays;periode:TMois;coeff:Real);
var scoreClim:Real;
begin
    if unPays.climat[periode]>=climat then
        scoreClim:=1
    else
        scoreClim:=1-Abs(climat-unPays.climat[periode])/climat;
    unPays.score:=(unPays.score+scoreClim*coeff)/(1+coeff);
end;

procedure scoreActivitePays(var pays:TPays; pref:Array of TPref; nbActParJour:Integer);
var
tabScore: Array of Real;
tabIndice: Array of Integer;
trouve: Boolean;
somme, scoreMin: Real;
i,j,k,minIndex:Integer;
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
            minIndex:=0;
            for i:=1 to nbActParJour-1 do
            begin
                if tabScore[i] < scoreMin then
                begin
                    scoreMin:=tabScore[i];
                    minIndex:=i;
                end;
            end;

            //vérification si l'activité étudiée a un score plus élevé que le plus petit score dans score et qu'elle n'a pas déjà été sélectionnée
            if scoreActivite(pays.activites[j], pref) > scoreMin then
            begin
                trouve:=False;
                for k:=0 to nbActParJour - 1 do
                    if tabIndice[k] = j then
                        trouve:=True;
                if not(trouve) then
                begin
                    tabScore[minIndex]:=scoreActivite(pays.activites[j], pref);
                    tabIndice[minIndex]:=j;
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

    pays.score:=somme/nbActParJour;
    writeln('test',pays.score);
end;

procedure paysVisites(inputPays: TEurope;coeff:Real);
var
    i: Integer;
begin
    {ces indices de i sont valables dans le cas où on met en entrée l'itinéraire de l'allé 
    (pas de modif des scores des pays de départ et d'arrivée)
    (même si en soit c'est pas important comme l'algo cherche à aller dans ces pays 
    donc le score du dernier chemin n'est pas important)
    a voir si ca change qqchose pour la fonction math pour déterminer le poids des chemin}
    for i := 1 to length(inputPays) - 2 do
        inputPays[i].score:=inputPays[i].score/coeff;
end;

{à appeler logiquement après avoir calculé les scores des pays (donc scoreActPays puis scoreClimat )
pour l'instant, on prend la moyenne comme fonction, mais quand on changera de fonction math, poidsChemin aura plus d'intérêt}
function poidsChemin(pays1:TPays;pays2:TPays):Real;
var poids:Real;
begin
    poids:=(pays1.score+pays2.score)/2;
    poidsChemin:=poids;
end;


end.