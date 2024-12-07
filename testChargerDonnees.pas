{ Programme de test de l'unité chargerDonnees }
program testChargerDonnees;

uses chargerDonnees, choixCriteres, voyageTypes;

var europe: TEurope;
    i, j: Integer;

begin
    // Charger les données
    europe := chargerEurope();

    // Afficher les données
    writeln(length(europe), ' pays ont été chargés : ');
    for i := 0 to length(europe) - 1 do
    begin
        writeln(europe[i].nom, ' (', length(europe[i].activites), ' activités) :');
        for j := 0 to length(europe[i].activites) - 1 do
            writeln('- ', europe[i].activites[j].nom);
    end;
    writeln();

    // On vérifie qu'il n'existe pas d'incohérences dans les données dans le terminal
end.
