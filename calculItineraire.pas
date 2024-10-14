unit calculItineraire;

interface
uses types;


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

function Dijkstra(startPays: String; endPays: String; listePays: TEurope): TDijstraResult;
var
  i, j, k, u, minDist, currentIndex: Integer;
  voisins: Array of String;
  distances: Array of Integer;
  visited: Array of Boolean;
begin
    setlength(distances, length(listePays));
    setlength(visited, length(listePays));
    for i := 0 to length(listePays) - 1 do
    begin
        distances[i] := 1000;
        visited[i] := false;
    end;

    currentIndex := trouverIndexPays(startPays, listePays);
    if currentIndex = -1 then
    begin
        writeln('Le pays de départ est introuvable.');
    end;

    Distances[currentIndex + 1] := 0;

    for i := 0 to length(listePays) - 1 do
    begin
        minDist := 1000;
        u := -1;
        for j := 1 to length(listePays) - 1 do
        begin
            if (not visited[j]) and (distances[j] < minDist) then
            begin
                minDist := distances[j];
                u := j;
            end;

            if u = -1 then
               break;

            visited[u] := true;

            voisins := listePays[u].nomFrontieres;
            for k := 0 to length(voisins) - 1 do
            begin
                currentIndex := trouverIndexPays(voisins[k], listePays);
                if (currentIndex <> -1) and (not Visited[currentIndex + 1]) then
                begin
                    if Distances[u] + 1 < Distances[currentIndex + 1] then
                        Distances[currentIndex + 1] := Distances[u] + 1;
                end;
            end;
        end;
    end;

    currentIndex := trouverIndexPays(endPays, listePays);
    if currentIndex = -1 then
    begin
        writeln('Le pays de destination est introuvable.');
        Exit;
    end;

    if Distances[currentIndex + 1] = 1000 then
        writeln('Il n''y a pas de chemin vers ', endPays)
    else
        writeln('Le chemin le plus court vers ', endPays, ' est de ', Distances[currentIndex + 1], ' frontière(s).');
end;

end.