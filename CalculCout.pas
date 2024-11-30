unit calculCout;

interface
uses voyageTypes, math, constantes, choixCriteres;

function calculDureeTransport(distance: Real; transport: TTransport): Integer;
function calculCoutTransport(distance: Real; transport: TTransport): Real;
function calculDuneDistance(lat1, lon1, lat2, lon2: Real): Real;
procedure calculDistanceTotal(var voyage: TVoyage);
procedure coutTotal(var voyage: TVoyage);
procedure coutCarbone(var voyage: TVoyage);

implementation

function calculDuneDistance(lat1, lon1, lat2, lon2: Real): Real;
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
  distance := 0;
  for i := 0 to length(voyage.itineraire) - 2 do
  begin
    j:=calculDuneDistance(voyage.itineraire[i].latitude, voyage.itineraire[i].longitude, voyage.itineraire[i+1].latitude, voyage.itineraire[i+1].longitude);
    distance:=distance+j;
  end;
  voyage.kmTotal:=distance;
end;

procedure coutTotal(var voyage: TVoyage);
var i: Integer; cout, coutEtape : Real;
begin
  cout := calculCoutTransport(voyage.kmTotal, voyage.transport);
  for i := 0 to length(voyage.etapes) - 1 do
  begin
    if voyage.etapes[i].estActivite then
      coutEtape := voyage.etapes[i].activite.cout
    else
      coutEtape := voyage.etapes[i].deplacement.cout;
    cout := cout + coutEtape;
  end; 
  voyage.coutTotal:=cout;
end;

function calculCoutTransport(distance: Real; transport: TTransport): Real;
begin
  if transport = Train then
    calculCoutTransport := 3 * power(distance, 0.5)
  else 
    calculCoutTransport := 0.04 * power(distance, 1.5);
end;

function calculDureeTransport(distance: Real; transport: TTransport): Integer;
var vitesse: Integer;
begin
  if transport = Train then
  begin
    if distance < 200 then
      vitesse := 120
    else
      vitesse := 250;
    calculDureeTransport := round((distance / vitesse) * 60)
  end
  else
    calculDureeTransport := round((distance / 800) * 60)
end;

procedure coutCarbone(var voyage: TVoyage);
begin
  if voyage.transport = Train then
    voyage.carbonImpact:=emissionCO2Train*voyage.kmTotal
  else
  begin
    voyage.carbonImpact:=emissionCO2Train*voyage.kmAvion+emissionCO2Train*voyage.kmTrain;
  end;
end;
end.