unit score;

interface
uses voyageTypes;

function scoreActivite(activite:TActivite;pref:Array of TPref):Real;
function scoreClimat(climat:Real;periode:TMois;pays:Tpays;fourchette:Real):Real;
function scoreActivitePays(pays:TPays; pref:Array of TPref; nbActParJour:Integer):Real;
procedure scorePays (coeffAct:Real;coeffClim:Real;criteres:TCriteres;nbActParJour:Integer;intervalleTemp:Real; var pays:TPays);
procedure paysVisites(coeff:Real; inputPays:TEurope;var europe: TEurope);
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


function scoreActivitePays(pays:TPays; pref:Array of TPref; nbActParJour:Integer):Real;
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