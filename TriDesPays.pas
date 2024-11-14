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
function suppressionPaysVisite(inputPays: TEurope; itineraire: TEurope): TEurope;

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
                exit;
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
var jour,i,nbAct,nbActParJour: Integer;
var etapes: TEtapes;
begin
    nbActParJour := 2;
    setlength(etapes, length(itineraire));
    
    for jour := 0 to length(itineraire) - 1 do 
    begin
        nbAct := 0;
        etapes[jour].jour:=jour;
        setlength(etapes[jour].activite,nbActParJour);

        for i:=0 to length(itineraire[jour].activites)-1 do 
            if matchPreference(itineraire[jour].activites[i],criteres.categories) and (nbAct<2) then
                begin
                    etapes[jour].activite[nbAct]:= itineraire[jour].activites[i];
                    nbAct:=nbAct+1;
                end;
    end;

    genererActivitePays := etapes;
end;

// On doit prendre en compte que certains pays ne peuvent pas être supprimés malgré le fait
// qu'ils sont inclus dans l'itinéraire aller. En effet, on doit s'assurer que l'algorithme
// de Dijkstra continue à fonctionner et trouver une solution à la suppression de chaque
// pays. Exemple : trajet France - Portugal => l'Espagne ne doit pas être supprimé !
function suppressionPaysVisite(inputPays: TEurope; itineraire: TEurope): TEurope;
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
                
                if not calculerItineraire(tmpValides, itineraire[0], itineraire[length(itineraire) - 1]).erreur then
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
    verifDuree:=length(itineraire)<=criteres.duree;
end;

end.