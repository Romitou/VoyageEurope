unit afficherVoyage;

interface
uses constantes, voyageTypes;

procedure afficher(voyage: TVoyage; criteres: TCriteres);
procedure afficherInfos(voyage: TVoyage; criteres: TCriteres);

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
{Procédure permettant l'affichage de l'intégralité du voyage, avec pour chaque journée le trajet effectué et sa durée, 
la ville d'arrivée, puis une liste d'activités suggérées à l'utilisateur relativement à ses attentes avec le prix et 
la durée de chaque activité. La procédure affiche également un message d'alerte en cas d'erreur.}
var
    transportEmoji: String;
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
                writeln('> Activités : ', etape.activite.nom, ' (', etape.activite.minutes, ' min - ', etape.activite.cout:0:0, ' euros)')
            else begin
                transportEmoji := '🚆';
                if etape.deplacement.transport = Avion then
                    transportEmoji := '✈️ ';
                writeln('   ', transportEmoji, ' Voyage depuis ', etape.deplacement.paysDepart.capitale, ' jusqu’à ', etape.deplacement.paysEtape.capitale, '.');
                writeln('   📍 Arrivée à ', etape.deplacement.paysEtape.nom, ' (', etape.deplacement.paysEtape.capitale, ') - ', etape.deplacement.minutes, ' minutes');
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

procedure afficherInfos(voyage: TVoyage; criteres: TCriteres);
{Cette procédure permet d'afficher dans le terminal les informations relatives au voyage proposé par le programme 
(durée du séjour, coût total et distance total parcourue). En cas de dépassement du coût maximal rentré par l'utilisateur 
en début de programme, la procédure envoie un message d'alerte signalant la différence avec le budget rensigné.}
begin
    writeln('Détails du voyage :');
    writeln('> Durée du séjour : ', length(voyage.planning) - 1, ' jours');
    writeln('> Coût total : ', voyage.coutTotal:0:0, ' euros');
    writeln('> Distance de ', voyage.kmTotal:0:1, ' km en ', voyage.modeTransport, ' à travers l''Europe, depuis ', criteres.paysDepart.nom, ' destination ', criteres.paysArrivee.nom);
    writeln();
    if (voyage.coutTotal > criteres.budget) then
        writeln('ATTENTION : Le coût du voyage proposé ci-dessous est supérieur de ', (voyage.coutTotal - criteres.budget):5:0, ' euros au coût maximal que vous avez renseigné.');
    writeln('> Coût carbone : ', voyage.carbonImpact:4:0, 'kg de CO2 rejété dans l''atmosphère durant votre voyage');
    writeln();
    if voyage.modeTransport = TrainEtAvion then
        writeln('')
    else
        writeln('A noter que votre voyage fait exclusivement en train rejeterait ', (voyage.carbonImpact - voyage.kmTotal * emissionCO2Train):4:0, ' kg de CO2 en moins par rapport à votre voyage.');
end;

end.
