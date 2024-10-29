unit triDesPays;

interface
uses types;
function triDesPays(criteres:TCriteres; lesPays:TEurope):TEurope;
function matchActivite(pays:Tpays;pref:Array of TPref):Boolean;
function matchClimat(climat:Real;unPays:Tpays;periode:TMois):Boolean;
function matchPreference(uneAct:TActivite;pref:Array of TPref):Boolean;

implementation

function matchPreference(uneAct:TActivite;pref:Array of TPref):Boolean;
var i,j:Integer; trouve:Boolean;
begin
    matchPreference:=True;
    for i:=1 to length(pref) do
        begin
        trouve:=False;
        for j:=1 to length(uneAct.categories) do
            if (pref[i]=uneAct.categories[j]) and matchPreference then
                trouve:=True;
        matchPreference:=trouve;
        end;
end;

function matchClimat(climat:Real;unPays:Tpays;periode:TMois):Boolean;
begin
    matchClimat:=false;
    if unPays.climat[periode]>climat then
        matchClimat:=True;
end;

function matchActivite(pays:Tpays;pref:Array of TPref):Boolean;
var i,nombreActValide:Integer;
begin
    matchActivite:=False;
    nombreActValide:=0;
    for i:=1 to length(pays.activites) do 
            if matchPreference(pays.activites[i],pref) then
                nombreActValide:=nombreActValide+1;
    if nombreActValide>1 then
        matchActivite:=True;
        
end;

function triDesPays(criteres:TCriteres; lesPays:TEurope):TEurope;
var i,j:integer; paysVal:TEurope;
begin
    setlength(paysVal,1);

    j:=1;
    for i:=1 to length(lesPays) do
        begin

        if (matchClimat(criteres.climat,lesPays[i],criteres.periode)) and (matchActivite(lesPays[i],criteres.categorie)) then
            begin
            setlength(paysVal,length(paysVal)+1);
            paysVal[j]:=lesPays[i];
            j:=j+1;
            end;
            
        end;
    triDesPays:=paysVal;
end; 


end.
