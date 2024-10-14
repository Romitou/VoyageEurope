unit triDesPays;

interface
uses types;
function paysValables(criteres:TCriteres; pays:Array of TPays):TEurope;
function matchActivite(pays:Tpays;pref:Array of TPref):Boolean;
function matchClimat(climat:Real;unPays:Tpays;periode:TMois):Boolean;
function matchPreference(uneAct:TActivite;pref:Array of TPref):Boolean;

implementation

function matchPreference(uneAct:TActivite;pref:Array of TPref):Boolean;
var i:Integer;
begin
    
end;

function matchClimat(climat:Integer;unPays:Tpays;periode:TMois):Boolean;
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

function paysValables(criteres:TCriteres; pays:Array of TPays):TEurope;
var i,j:integer; paysVal:TEurope;
begin
    setlength(paysVal,1);

    j:=1;
    for i:=1 to length(pays) do
        begin

        if (matchClimat(criteres.climat,pays[i],criteres.periode)) and (matchActivite(pays[i],criteres.categorie)) then
            begin
            setlength(paysVal,length(paysVal)+1);
            TEurope[j]:=pays[i];
            j:=j+1;
            end;
            
        end;
    paysValables:=paysVal;
end; 


end.
