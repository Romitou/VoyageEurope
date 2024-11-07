unit triDesPays;

interface
uses types;
//tri des pays
function filtrerPays(criteres: TCriteres; europe: TEurope): TEurope;
function matchActivite(pays:Tpays;pref:Array of TPref):Boolean;
function matchClimat(climat:Real;unPays:Tpays;periode:TMois):Boolean;
function matchPreference(uneAct:TActivite;pref:Array of TPref):Boolean;
//generer voyage
function genererActivitePays(itineraire:TEurope;criteres:TCriteres):Tvoyage;
function verifDuree(itineraire:TEurope;criteres:TCriteres):Boolean;
function suppressionPaysVisite(paysValables:TEurope;itineraire:TEurope):TEurope;
//scores
function scoreActivite(activite:TActivite;pref:Array of TPref):Real;
function scoreClimat(climat:Real;unPays:Tpays;periode:TMois):Real;
function scoreActivitePays(pays:TPays;pref:Array of TPref;nbActParJour:Integer):Real;

implementation

function matchPreference(uneAct:TActivite;pref:Array of TPref):Boolean;
var i,j:Integer; trouve:Boolean;
begin
    matchPreference:=True;
    for i:=0 to length(pref)-1 do
        begin
        trouve:=False;
        for j:=0 to length(uneAct.categories)-1 do
            if (pref[i]=uneAct.categories[j]) and matchPreference then
                trouve:=True;
        matchPreference:=trouve;
        end;
end;

function matchClimat(climat:Real;unPays:Tpays;periode:TMois):Boolean;
begin
    matchClimat:=false;
    if unPays.climat[periode]>=climat then
        matchClimat:=True;
end;

function matchActivite(pays:Tpays;pref:Array of TPref):Boolean;
var i,nombreActValide:Integer;
begin
    matchActivite:=False;
    nombreActValide:=0;
    for i:=0 to length(pays.activites)-1 do 
            if matchPreference(pays.activites[i],pref) then
                nombreActValide:=nombreActValide+1;
    if nombreActValide>1 then
        matchActivite:=True;
        
end;


function filtrerPays(criteres:TCriteres; europe:TEurope):TEurope;
var i,j:integer; paysVal:TEurope;
begin
    setlength(paysVal,0);
    j:=0;
    for i:=0 to length(europe)-1 do
        begin
        if (matchClimat(criteres.climat,europe[i],criteres.periode)) and (matchActivite(europe[i],criteres.categorie)) then
            begin
                setlength(paysVal,length(paysVal)+1);
                paysVal[j]:=europe[i];
                j:=j+1;
            end;
            
        end;
    filtrerPays:=paysVal;
end; 

function genererActivitePays(itineraire:TEurope;criteres:TCriteres):Tvoyage;
var jour,i,nbAct,nbActParJour: Integer;
var voyage: TVoyage;
begin
    nbActParJour:=2;

    setlength(voyage.planning,length(itineraire));
    voyage.itineraire:=itineraire;
    
    for jour:=0 to length(itineraire)-1 do 
        begin
            nbAct:=0;
            voyage.planning[jour].jour:=jour;
            setlength(voyage.planning[jour].activite,nbActParJour);

            for i:=0 to length(itineraire[jour].activites)-1 do 
                if matchPreference(itineraire[jour].activites[i],criteres.categorie) and (nbAct<2) then
                    begin
                        voyage.planning[jour].activite[nbAct]:= itineraire[jour].activites[i];
                        nbAct:=nbAct+1;
                    end;
        end;

    genererActivitePays := voyage;
end;

function suppressionPaysVisite(paysValables:TEurope;itineraire:TEurope):TEurope;
var i,j,k:Integer;
tab:TEurope;
trouve:Boolean;
begin
    k:=0;
    setlength(tab,1);

    for i:=0 to length(paysValables)-1 do
        begin
        trouve:=False;
        for j:=0 to length(itineraire)-1 do
            //not(j=length(itineraire)-1) and not(j=0) and
            if  (paysValables[i].nom=itineraire[j].nom) then
                trouve:=True;

        if not(trouve) then
            begin
            tab[k]:=paysValables[i];
            k:=k+1;
            setlength(tab,k); 
            end;

        end;
    suppressionPaysVisite:=tab;
end;

function verifDuree(itineraire:TEurope;criteres:TCriteres):Boolean;
begin
    verifDuree:=length(itineraire)>=criteres.duree;
end;

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