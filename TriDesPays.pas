unit triDesPays;

interface
uses types,CalculCout;
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
begin
    nbActParJour:=2;

    setlength(genererActivitePays.planning,length(itineraire));
    genererActivitePays.itineraire:=itineraire;

    //Normalement bon mais erreur à l'exécution, probablement un problème dans calcul cout
    //calculDistanceTotal(genererActivitePays);
    //coutTotal(genererActivitePays);
    
    for jour:=0 to length(itineraire)-1 do 
        begin
            nbAct:=0;
            genererActivitePays.planning[jour].jour:=jour;
            setlength(genererActivitePays.planning[jour].activite,nbActParJour);

            for i:=0 to length(itineraire[jour].activites)-1 do 
                if matchPreference(itineraire[jour].activites[i],criteres.categorie) and (nbAct<2) then
                    begin
                        genererActivitePays.planning[jour].activite[nbAct]:= itineraire[jour].activites[i];
                        nbAct:=nbAct+1;
                    end;
        end;
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
begin
    nbPrefVerifiee:=0;
    for i:=0 to length(pref)-1 do
        for j:=0 to length(activite.categories)-1 do
            if (pref[i]=activite.categories[j])  then
                nbPrefVerifiee:=nbPrefVerifiee+1;
    scoreActivite:=nbPrefVerifiee/length(pref);
end;

function scoreClimat(climat:Real;unPays:Tpays;periode:TMois):Real;
begin
    if unPays.climat[periode]>=climat then
        scoreClimat:=1
    else
        scoreClimat:=1-Abs(climat-unPays.climat[periode])/climat;
end;

function scoreActivitePays(pays:TPays;pref:Array of TPref;nbActParJour:Integer):Real;
var i,j:Integer;
score:Array of Real;
begin
    setlength(score,nbActParJour);
    if length(pays.activites)>nbActParJour then
        begin    
            for j:=0 to nbActParJour-1 do

                for i:=0 to length(pays.activites)-1 do
                //repeter nbactjour fois uhe recherche de max parmi tous les scores de toutes les activités, et en vérifiant à chaque fois que ca n'est pas une activité déjà choisie
        end
    else    

end;

end.