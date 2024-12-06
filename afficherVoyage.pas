unit afficherVoyage;

interface
uses constantes, genererVoyage, voyageTypes;

procedure afficher(voyage: TVoyage; criteres: TCriteres; europe: TEurope);
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

{Cette procédure permet d'afficher dans le terminal les informations relatives au voyage proposé par le programme 
(durée du séjour, coût total et distance total parcourue). En cas de dépassement du coût maximal rentré par l'utilisateur 
en début de programme, la procédure envoie un message d'alerte signalant la différence avec le budget rensigné.}
procedure afficherInfos(voyage: TVoyage; criteres: TCriteres);
begin
    writeln();
    writeln('------------ 📝 Détails du voyage ------------');
    writeln('🗺️  ', criteres.paysDepart.nom, ' - ', criteres.paysArrivee.nom);
    writeln();
    writeln('🕒 Durée du séjour : ', length(voyage.planning), ' jours');
    writeln('📍 Distance de ', voyage.kmTotal:0:1, ' km  (', voyage.kmTrain:0:1, ' km en train, ', voyage.kmAvion:0:1, ' km en avion)');
    writeln('🌱 Coût carbone : ', voyage.carbonImpact:0:0, 'kg de CO2');
    write('💰 Coût total : ', voyage.coutTotal:0:0, ' euros');
    if (voyage.coutTotal > criteres.budget) then
        writeln(' (⚠️   + ', (voyage.coutTotal - criteres.budget):0:0, ' euros)');
    writeln();
end;

procedure afficherComparaison(voyage: TVoyage; voyageBis: TVoyage);
var premierTrajet, secondTrajet, signeTrain, signeAvion, signeCarbone, signeCout: String;
begin
    if voyage.modeTransport = TrainSeul then
    begin
        premierTrajet := 'Train uniquement : ';
        secondTrajet := 'Train et avion :   ';
    end else
    begin
        premierTrajet := 'Train et avion :   ';
        secondTrajet := 'Train uniquement : ';
    end;
    writeln('---- 📊 Comparaison des modes de transport ----');
    writeln();
    writeln(premierTrajet, '🚆  ', voyage.kmTrain:6:1, ' km     ✈️   ', voyage.kmAvion:6:1, ' km     🌱  ', voyage.carbonImpact:5:1, ' kg CO2     💰  ', voyage.coutTotal:7:1, ' euros');
    writeln(secondTrajet, '🚆  ', voyageBis.kmTrain:6:1, ' km     ✈️   ', voyageBis.kmAvion:6:1, ' km     🌱  ', voyageBis.carbonImpact:5:1, ' kg CO2     💰  ', voyageBis.coutTotal:7:1, ' euros');
   
    if voyage.kmTrain > voyageBis.kmTrain then signeTrain := '+' else signeTrain := '-';
    if voyage.kmAvion > voyageBis.kmAvion then signeAvion := '+' else signeAvion := '-';
    if voyage.carbonImpact > voyageBis.carbonImpact then signeCarbone := '+' else signeCarbone := '-';
    if voyage.coutTotal > voyageBis.coutTotal then signeCout := '+' else signeCout := '-';

    writeln('                     (', signeTrain, abs(voyage.kmTrain - voyageBis.kmTrain):5:1, ' km)      (', signeAvion, abs(voyage.kmAvion - voyageBis.kmAvion):5:1, ' km)      (', signeCarbone, abs(voyage.carbonImpact - voyageBis.carbonImpact):5:1, ' kg CO2)      (', signeCout, abs(voyage.coutTotal - voyageBis.coutTotal):7:1, ' euros)');
    writeln();
    if voyage.modeTransport = TrainEtAvion then
        writeln('🌱 Attention : en optant pour un voyage en train uniquement, vous pourriez rejeter ', (voyage.carbonImpact - voyageBis.carbonImpact):0:1, ' kg de CO2 de moins qu''en prenant l''avion.')
    else
        writeln('🌱 En optant pour ce voyage en train uniquement, vous rejeterez ', (voyageBis.carbonImpact - voyage.carbonImpact):0:1, ' kg de CO2 de moins qu''en prenant l''avion ! 👍');
end;

{ Cette procédure permet d'afficher le coût carbone du voyage dans le terminal. }
procedure afficherImpactCarbone(voyage: TVoyage; criteres: TCriteres; europe: TEurope);
var dureeMinimale: Integer;
    criteresBis: TCriteres;
    voyageTrain: TVoyage;
    voyageAvion: TVoyage;
    signeTrain, signeAvion, signeCarbone: String;
begin
    criteresBis := criteres;
    if voyage.modeTransport = TrainSeul then
    begin
        voyageTrain := voyage;
        criteresBis.modeTransport := TrainEtAvion;
        voyageAvion := generer(criteresBis, europe);
        afficherComparaison(voyageTrain, voyageAvion);
    end
    else begin
        voyageAvion := voyage;
        criteresBis.modeTransport := TrainSeul;

        // Dans le cas du train, on doit calculer la durée minimale du trajet,
        // car un voyage en train est plus long qu'un voyage en avion
        dureeMinimale := calculDureeMinimale(criteresBis, europe);
        criteresBis.duree := dureeMinimale;

        voyageTrain := generer(criteresBis, europe);
        afficherComparaison(voyageAvion, voyageTrain);

        // writeln('A noter que votre voyage fait exclusivement en train rejeterait ', (voyage.carbonImpact - voyageBis.carbonImpact):4:0, ' kg de CO2 en moins par rapport à votre voyage.');
        // writeln('Un autre voyage de ', length(voyageBis.planning) - length(voyage.planning), ' jours supplémentaires vous permettrait de réduire de la sorte le coût carbone de votre voyage');
    end;


        // if voyage.carbonImpact < voyageBis.carbonImpact then
        // begin
        //     writeln('🚆 Votre voyage actuel rejette ', (voyageBis.carbonImpact - voyage.carbonImpact):4:0, ' kg de CO2 en moins par rapport à votre voyage en train et avion.');
        //     writeln('🌟 Opter pour un voyage en train seul vous permettrait de réduire de la sorte le coût carbone de votre voyage.');
        // end
        // else begin
        //     writeln('🚆 Votre voyage actuel rejette ', (voyage.carbonImpact - voyageBis.carbonImpact):4:0, ' kg de CO2 en moins par rapport à votre voyage en train seul.');
        //     writeln('🌟 Opter pour un voyage en train et avion vous permettrait de réduire de la sorte le coût carbone de votre voyage.');
        // end;
end;

procedure afficher(voyage: TVoyage; criteres: TCriteres; europe: TEurope);
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
                writeln('> 🚩 ', etape.activite.nom, ' (', etape.activite.minutes, ' min - ', etape.activite.cout:0:0, ' euros)')
            else begin
                transportEmoji := '🚆';
                if etape.deplacement.transport = Avion then
                    transportEmoji := '✈️ ';
                writeln('> ', transportEmoji, ' Voyage depuis ', etape.deplacement.paysDepart.capitale, ' jusqu’à ', etape.deplacement.paysEtape.capitale, '.');
                writeln('  📍 Arrivée à ', etape.deplacement.paysEtape.nom, ' (', etape.deplacement.paysEtape.capitale, ') - ', etape.deplacement.minutes, ' minutes');
                if etape.deplacement.paysEtape.nom = criteres.paysArrivee.nom then
                    writeln('  🌟 Journée dans le pays de destination : ', etape.deplacement.paysEtape.nom, '.');
            end;
        end;

        if i < length(voyage.planning) - 1 then
            writeln('----------------------------------------')
        else
            writeln('🏁 Fin de votre voyage !');
    end;

    afficherInfos(voyage, criteres);
    afficherImpactCarbone(voyage, criteres, europe);

    writeln();
end;


end.
