unit score;

interface
uses voyageTypes;

function scoreActivite(activite:TActivite;pref:Array of TPref):Real;
function scoreClimat(climat:Real;unPays:Tpays;periode:TMois):Real;
function scoreActivitePays(pays:TPays;pref:Array of TPref;nbActParJour:Integer):Real;

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

function scoreClimat(climat:Real;unPays:Tpays;periode:TMois):Real;
begin
    if unPays.climat[periode]>=climat then
        scoreClimat:=1
    else
        scoreClimat:=1-Abs(climat-unPays.climat[periode])/climat;
end;

function scoreActivitePays(pays: TPays; pref: Array of TPref; nbActParJour: Integer): Real;
var i,j,k,minIndex: Integer;
score: Array of Real;
tabIndice: Array of Integer;
trouve: Boolean;
somme, scoreMin: Real;
begin
    //initialisation du tableau pour stocker les meilleurs scores (pas de score négatif, donc 0 est la plus petite valeur)
    setlength(score,nbActParJour);
    for i:=0 to nbActParJour-1 do
        score[i]:=0;

    //initialisation du tableau pour stocker les indices des meilleures activités (-1 pour dire qu'il n'y a pas encore d'indice)
    setlength(tabIndice,nbActParJour);
    for i:=0 to nbActParJour-1 do
        tabIndice[i]:=-1;

    if length(pays.activites) > nbActParJour then
    begin  
        for j:=0 to length(pays.activites)-1 do
        begin
            //recherche de la position du plus petit score dans le tableau score, qui sera remplacée par un meilleur score
            scoreMin:=score[0];
            minIndex:=0;
            for i:=1 to nbActParJour-1 do
            begin
                if score[i] < scoreMin then
                begin
                    scoreMin:=score[i];
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
                    score[minIndex]:=scoreActivite(pays.activites[j], pref);
                    tabIndice[minIndex]:=j;
                end;
            end;
        end;
    end
    else
        //cas où il y a moins d'activités que nbActParJour
        for i := 0 to length(pays.activites) - 1 do
            score[i] := scoreActivite(pays.activites[i], pref);


    //calcul de la moyenne des meilleurs scores
    somme := 0;
    for i := 0 to nbActParJour - 1 do
        somme := somme + score[i];

    scoreActivitePays := somme / nbActParJour;
end;



end.