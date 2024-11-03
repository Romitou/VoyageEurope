unit calculItineraire;

interface
uses types, sysutils;
function Dijkstra(startPays: String; endPays: String; listePays: TEurope): TDijkstraResult;


implementation

function trouverIndexPays(nom: String; listePays: TEurope): Integer;
var i: Integer;
begin
  for i := 0 to length(listePays) - 1 do
    if listePays[i].nom = nom then
    begin
      trouverIndexPays := i;
      Exit;
    end;
  trouverIndexPays := -1;
end;

function Dijkstra(startPays: String; endPays: String; listePays: TEurope): TDijkstraResult;
var
  i, j, k, u, minDist, currentIndex: Integer;
  voisins: TStringArray;
  distances: Array of Integer;
  visited: Array of Boolean;
begin
  SetLength(distances, Length(listePays));
  SetLength(visited, Length(listePays));
  
  for i := 0 to Length(listePays) - 1 do
  begin
    distances[i] := 1000;
    visited[i] := false;
  end;

  currentIndex := trouverIndexPays(startPays, listePays);
  if currentIndex = -1 then
  begin
    Dijkstra.error := true;
    Dijkstra.message := 'Le pays de départ est introuvable.';
    Exit(Dijkstra);
  end;

  distances[currentIndex] := 0;

  for i := 0 to Length(listePays) - 1 do
  begin
    minDist := 1000;
    u := -1;

    for j := 0 to Length(listePays) - 1 do
    begin
      if (not visited[j]) and (distances[j] < minDist) then
      begin
        minDist := distances[j];
        u := j;
      end;
    end;

    if u = -1 then
      Break;

    visited[u] := true;

    voisins := listePays[u].nomFrontieres;
    for k := 0 to Length(voisins) - 1 do
    begin
      currentIndex := trouverIndexPays(voisins[k], listePays);
      if (currentIndex <> -1) and (not visited[currentIndex]) then
      begin
        if distances[u] + 1 < distances[currentIndex] then
          distances[currentIndex] := distances[u] + 1;
      end;
    end;
  end;

  currentIndex := trouverIndexPays(endPays, listePays);
  if currentIndex = -1 then
  begin
    Dijkstra.error := true;
    Dijkstra.message := 'Le pays de destination est introuvable.';
    Exit(Dijkstra);
  end;

  if distances[currentIndex] = 1000 then
  begin
    Dijkstra.error := true;
    Dijkstra.message := 'Aucun chemin possible.';
  end
  else
  begin
    Dijkstra.error := false;
    Dijkstra.startPays := startPays;
    Dijkstra.endPays := endPays;
    Dijkstra.distance := distances[currentIndex];
  end;
end;

end.