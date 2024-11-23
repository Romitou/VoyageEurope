unit afficherVoyage;

interface
uses voyageTypes;

procedure afficher(voyage:TVoyage;criteres:TCriteres);
procedure afficherInfos(voyage:TVoyage;criteres:TCriteres);

implementation

// procedure debug(etapes: TEtapes);
// var i,j:Integer;
// begin
//   for i := 0 to length(etapes) - 1 do
//   begin
//     writeln('Jour ', etapes[i].jour, ' :');
//     for j := 0 to length(etapes[i].activite) - 1 do
//     begin
//       writeln(' - ', etapes[i].activite[j].nom);
//     end;
//   end;
// end;

procedure afficher(voyage: TVoyage; criteres: TCriteres);
var
    i, j: Integer;
    etape: TEtape;
begin
    if voyage.erreur then
    begin
        writeln('⚠️ Une erreur est survenue lors de la génération du voyage :');
        writeln(voyage.message);
        exit;
    end;

    afficherInfos(voyage, criteres);
    writeln;
    writeln('===== PLANNING DU VOYAGE =====');
    writeln;

    for i := 0 to length(voyage.planning) - 1 do
    begin
        writeln('🗓️  Jour ', i + 1);
        for j := 0 to length(voyage.planning[i].etapes) - 1 do
        begin
            etape := voyage.planning[i].etapes[j];

            if etape.estActivite then
            begin
                writeln('> Activités : ', etape.activite.nom, ' (', etape.activite.minutes, ' min)');       
            end
            else
            begin
                writeln('   🚆 Voyage depuis ', etape.deplacement.paysDepart.capitale, ' jusqu’à ', etape.deplacement.paysEtape.capitale, '.');
                writeln('   📍 Arrivée à ', etape.deplacement.paysEtape.nom,  ' (', etape.deplacement.paysEtape.capitale, ') - ', etape.deplacement.minutes, ' minutes');
                if etape.deplacement.paysEtape.nom = criteres.paysArrivee.nom then
                    writeln('   🌟 Journée dans le pays de destination : ', etape.deplacement.paysEtape.nom, '.');
            end;
        end;

        if i < length(voyage.planning) - 1 then
            writeln('----------------------------------------')
        else
            writeln('🏁 Fin de votre voyage !');
    end;

    writeln();
end;

procedure afficherInfos(voyage:TVoyage;criteres:TCriteres);
begin
    writeln('Détails du voyage :');
    writeln('> Durée du séjour : ', length(voyage.planning)-1, ' jours');
    writeln('> Coût total : ', voyage.coutTotal:5:0, ' euros');
    writeln('> Distance de ',voyage.kmTotal:5:1, ' km en train à travers l''Europe, depuis ',criteres.paysDepart.nom,' destination ',criteres.paysArrivee.nom);
    writeln();
    if (voyage.coutTotal>criteres.budget) then
        writeln('ATTENTION : Le coût du voyage proposé ci-dessous est supérieur de ', voyage.coutTotal-criteres.budget:5:0, ' euros au coût maximal que vous avez renseigné.');
end;

end.
