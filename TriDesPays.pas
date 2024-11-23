unit triDesPays;

interface
uses voyageTypes, calculItineraire;

// TODO: est-ce que tout est utilisé / exporté ?
// Retirer les fonctions inutilisées à la fin

//tri des pays
function filtrerPays(criteres: TCriteres; europe: TEurope): TEurope;
function matchActivite(pays:Tpays;pref:Array of TPref):Boolean;
function matchClimat(climat:Real;unPays:Tpays;periode:TMois):Boolean;
function matchPreference(uneAct:TActivite;pref:Array of TPref):Boolean;
//generer voyage
function genererActivitePays(itineraire: TEurope; criteres: TCriteres): TEtapes;
function verifDuree(itineraire:TEurope;criteres:TCriteres):Boolean;
function suppressionPaysVisite(inputPays: TEurope; itineraire: TEurope; transport: TTransport): TEurope;

implementation

function matchPreference(uneAct: TActivite; pref: Array of TPref): Boolean;
var i,j:Integer;
begin
    matchPreference := false;
    for i:=0 to length(pref)-1 do
        for j:=0 to length(uneAct.categories)-1 do
            if pref[i] = uneAct.categories[j] then
            begin
                matchPreference := true;
                exit(matchPreference);
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
        //if (matchClimat(criteres.climat,europe[i],criteres.periode)) and (matchActivite(europe[i],criteres.categorie)) then
        if (matchActivite(europe[i],criteres.categories)) then
            begin
                setlength(paysVal,length(paysVal)+1);
                paysVal[j]:=europe[i];
                j:=j+1;
            end;
            
        end;
    filtrerPays:=paysVal;
end; 

function genererActivitePays(itineraire: TEurope; criteres: TCriteres): TEtapes;
var
    j, jour, nbAct, i: Integer;
    etapes: TEtapes;
begin
    jour := 0;
    setlength(etapes, 0);

    for j := 1 to length(itineraire) - 1 do
    begin
        // Si on souhaite éviter les doublons (si besoin dans un cas futur)
        // if (j < length(itineraire) - 1) and (itineraire[j].nom = itineraire[j + 1].nom) then
        //     continue;

        setlength(etapes, length(etapes) + 1);
        etapes[jour].jour := jour;

        etapes[jour].paysDepart := itineraire[j - 1];
        etapes[jour].paysEtape := itineraire[j];

        setlength(etapes[jour].activite, 2);

        nbAct := 0;
        for i := 0 to length(itineraire[j].activites) - 1 do
        begin
            if matchPreference(itineraire[j].activites[i], criteres.categories) and (nbAct < 2) then
            begin
                etapes[jour].activite[nbAct] := itineraire[j].activites[i];
                nbAct := nbAct + 1;
            end;
        end;

        jour := jour + 1;
    end;

    genererActivitePays := etapes;
end;

// On doit prendre en compte que certains pays ne peuvent pas être supprimés malgré le fait
// qu'ils sont inclus dans l'itinéraire aller. En effet, on doit s'assurer que l'algorithme
// de Dijkstra continue à fonctionner et trouver une solution à la suppression de chaque
// pays. Exemple : trajet France - Portugal => l'Espagne ne doit pas être supprimé !
function suppressionPaysVisite(inputPays: TEurope; itineraire: TEurope; transport: TTransport): TEurope;
var
    i, j, k: Integer;
    paysValides, tmpValides: TEurope;
begin
    paysValides := inputPays;

    for i := 0 to length(inputPays) - 1 do
    begin
        for j := 1 to length(itineraire) - 2 do
        begin
            if paysValides[i].nom = itineraire[j].nom then
            begin
                setlength(tmpValides, 0);
                for k := 0 to length(paysValides) - 1 do
                begin
                    if paysValides[k].nom <> paysValides[i].nom then
                    begin
                        setlength(tmpValides, length(tmpValides) + 1);
                        tmpValides[length(tmpValides) - 1] := paysValides[k];
                    end;
                end;
                
                if not calculerItineraire(tmpValides, itineraire[0], itineraire[length(itineraire) - 1], transport).erreur then
                begin
                    paysValides := tmpValides;
                end;

                Break;
            end;
        end;
    end;

    suppressionPaysVisite := paysValides;
end;

function verifDuree(itineraire:TEurope;criteres:TCriteres):Boolean;
begin
    verifDuree:=length(itineraire)<=((criteres.duree)*1.2);
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