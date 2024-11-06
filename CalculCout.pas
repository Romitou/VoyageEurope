unit calculCout;

interface
uses types, math;

function calculDuneDistance(lat1, lon1, lat2, lon2: Real; i:Integer): Real;
procedure calculDistanceTotal(var voyage: TVoyage);
procedure coutTotal(var voyage: TVoyage);

implementation

function calculDuneDistance(lat1, lon1, lat2, lon2: Real; i: Integer): Real;
const r= 6371; //km
const p= (Pi/180);
var a : Real;
begin 
  a:=(1/2)-((Cos((lat2-lat1)*p))/2)+Cos(lat1*p)*Cos(lat2*p)*((1-Cos((lon2-lon1)*p))/2);
  calculDuneDistance:=2*r*ArcSin(Sqrt(a)); 
end;

procedure calculDistanceTotal(var voyage: TVoyage);
var i : Integer; j, distance : Real;
begin
  distance:= 0;
  for i := 1 to (length(voyage.itineraire)-1) do
  begin
    j:=calculDuneDistance(voyage.itineraire[i].latitude, voyage.itineraire[i].longitude, voyage.itineraire[i+1].latitude, voyage.itineraire[i+1].longitude, i);
    distance:=distance+j;
  end;
  voyage.kmTotal:=distance;
  writeln('La distance total du voyage est de :', voyage.kmTotal);
end;

procedure coutTotal(var voyage: TVoyage);
var i, j : Integer; a, cout : Real;
begin
  cout:=voyage.kmTotal;
  for i := 0 to (length(voyage.planning)-1) do
  begin
    for j := 0 to (length(voyage.planning[i].activite)-1) do
      begin
        a:= voyage.planning[i].activite[j].cout;
        cout:=cout+a;
      end; 
  end; 
  voyage.coutTotal:=cout;
  writeln('Le cout total du voyage est de :', voyage.coutTotal)
end;

end.