program testChargerDonnees;

uses chargerDonnees, choixCriteres, voyageTypes;

var europe: TEurope;
    pays: TPays;
    i: Integer;

begin
    europe := chargerPays();
    for i := 0 to length(europe) - 1 do
        writeln(europe[i].nom);

    pays.nom := 'France';
    pays.capitale := 'Paris';
    setlength(pays.nomFrontieres, 2);
    pays.nomFrontieres[0] := 'test1';
    pays.nomFrontieres[1] := 'test2';

    setlength(europe, length(europe) + 1);
    europe[length(europe) - 1] := pays;

    sauvegarderPays(europe);
end.
