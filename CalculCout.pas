unit calculCout;

interface
uses types;

procedure calculDistance(var voyage: TVoyage);
procedure coutTotal(var voyage: TVoyage);

implementation

procedure calculDistance(var voyage: TVoyage);
var i : Integer; j, distance : Real;
begin
  distance:= 0;
  for i := 1 to (length(voyage.itineraire)-1) do
  begin
    j:=sqrt(sqr((voyage.itineraire[i+1].latitude)-(voyage.itineraire[i].latitude))+sqr((voyage.itineraire[i+1].longitude)-(voyage.itineraire[i].longitude)));
    distance:=distance+j;
  end;
  voyage.kmTotal:=distance;
end;

procedure coutTotal(var voyage: TVoyage);
var i, j : Integer; a, cout : Real;
begin
  cout:=voyage.kmTotal;
  for i := 1 to length(voyage.planning) do
  begin
    for j := 1 to length(voyage.planning[i].activite) do
      begin
        a:= voyage.planning[i].activite[j].cout;
        cout:=cout+a;
      end; 
  end; 
  voyage.coutTotal:=cout
end;

end.