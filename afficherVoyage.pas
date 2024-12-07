{ Affichage des informations relatives au voyage généré par le programme }
unit afficherVoyage;

interface
uses constantes, genererVoyage, voyageTypes;

procedure afficher(voyage: TVoyage; criteres: TCriteres; europe: TEurope);
procedure afficherInfos(voyage: TVoyage; criteres: TCriteres);

implementation

{ Cette procédure permet d'afficher dans le terminal les informations relatives au voyage proposé par le programme 
(durée du séjour, coût total et distance total parcourue). En cas de dépassement du coût maximal rentré par l'utilisateur 
en début de programme, la procédure envoie un message d'alerte signalant la différence avec le budget rensigné.
    @param(voyage Voyage généré par le programme)
    @param(criteres Critères de recherche du voyage)
}
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

{ Une fois le voyage alternatif généré, cette procédure permet d'afficher dans le terminal les différences entre les deux voyages
    @param(voyage Voyage généré par le programme)
    @param(voyageBis Voyage alternatif à comparer)
}
procedure afficherComparaison(voyage: TVoyage; voyageBis: TVoyage);
var premierTrajet, secondTrajet, signeTrain, signeAvion, signeCarbone, signeCout: String;
begin
    if voyage.modeTransport = TrainSeul then
    begin
        premierTrajet := 'Train uniquement : ';
        secondTrajet := 'Train et avion :   ';
    end
    else begin
        premierTrajet := 'Train et avion :   ';
        secondTrajet := 'Train uniquement : ';
    end;
    writeln('---- 📊 Comparaison des modes de transport ----');
    writeln();
    writeln(premierTrajet, '🚆  ', voyage.kmTrain:6:1, ' km     ✈️   ', voyage.kmAvion:6:1, ' km     🌱  ', voyage.carbonImpact:6:1, ' kg CO2     💰  ', voyage.coutTotal:7:1, ' euros');
    writeln(secondTrajet, '🚆  ', voyageBis.kmTrain:6:1, ' km     ✈️   ', voyageBis.kmAvion:6:1, ' km     🌱  ', voyageBis.carbonImpact:6:1, ' kg CO2     💰  ', voyageBis.coutTotal:7:1, ' euros');
   
    if voyage.kmTrain > voyageBis.kmTrain then signeTrain := '+' else signeTrain := '-';
    if voyage.kmAvion > voyageBis.kmAvion then signeAvion := '+' else signeAvion := '-';
    if voyage.carbonImpact > voyageBis.carbonImpact then signeCarbone := '+' else signeCarbone := '-';
    if voyage.coutTotal > voyageBis.coutTotal then signeCout := '+' else signeCout := '-';

    writeln('                     (', signeTrain, abs(voyage.kmTrain - voyageBis.kmTrain):6:1, ' km)      (', signeAvion, abs(voyage.kmAvion - voyageBis.kmAvion):6:1, ' km)      (', signeCarbone, abs(voyage.carbonImpact - voyageBis.carbonImpact):6:1, ' kg CO2)      (', signeCout, abs(voyage.coutTotal - voyageBis.coutTotal):7:1, ' euros)');
    writeln();

    // Affichage de recommandations en fonction des différences entre les deux voyages
    if voyage.modeTransport = TrainEtAvion then
        writeln('🌱 Attention : en optant pour un voyage en train uniquement, vous pourriez rejeter ', (voyage.carbonImpact - voyageBis.carbonImpact):0:1, ' kg de CO2 de moins qu''en prenant l''avion.')
    else
        writeln('🌱 En optant pour ce voyage en train uniquement, vous rejeterez ', (voyageBis.carbonImpact - voyage.carbonImpact):0:1, ' kg de CO2 de moins qu''en prenant l''avion ! 👍');
end;

{ Cette procédure permet d'afficher dans le terminal une comparaison entre deux voyages, l'un en train et l'autre en avion.
    @param(voyage Voyage généré par le programme)
    @param(criteres Critères de recherche du voyage)
    @param(europe Liste des pays européens)
}
procedure afficherVoyageAlternatif(voyage: TVoyage; criteres: TCriteres; europe: TEurope);
var dureeMinimale: Integer;
    criteresBis: TCriteres;
    voyageTrain: TVoyage;
    voyageAvion: TVoyage;
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
    end;
end;

{ Procédure permettant l'affichage de l'intégralité du voyage, avec pour chaque journée le trajet effectué et sa durée, 
la ville d'arrivée, puis une liste d'activités suggérées à l'utilisateur relativement à ses attentes avec le prix et 
la durée de chaque activité. La procédure affiche également un message d'alerte en cas d'erreur.
    @param(voyage Voyage généré par le programme)
    @param(criteres Critères de recherche du voyage)
    @param(europe Liste des pays européens)
}
procedure afficher(voyage: TVoyage; criteres: TCriteres; europe: TEurope);
var
    transportEmoji: String;
    i, j: Integer;
    etape: TEtape;
begin
    // Il est possible que la génération du voyage ait échoué
    if voyage.erreur then
    begin
        writeln('⚠️  Une erreur est survenue lors de la génération du voyage :');
        writeln(voyage.message);
        exit;
    end;

    writeln;
    writeln('===== PLANNING DU VOYAGE =====');
    writeln;

    // On affiche le planning du voyage jour par jour
    for i := 0 to length(voyage.planning) - 1 do
    begin
        writeln('🗓️  Jour ', i + 1);
        // On affiche les étapes de la journée
        for j := 0 to length(voyage.planning[i].etapes) - 1 do
        begin
            etape := voyage.planning[i].etapes[j];

            // On affiche l'activité ou le déplacement
            if etape.estActivite then
                writeln('> 🚩 ', etape.activite.nom, ' (', etape.activite.minutes, ' min - ', etape.activite.cout:0:0, ' euros)')
            else begin
                transportEmoji := '🚆';
                if etape.deplacement.transport = Avion then
                    transportEmoji := '✈️ ';
                writeln('> ', transportEmoji, ' Voyage depuis ', etape.deplacement.paysDepart.capitale, ' jusqu’à ', etape.deplacement.paysEtape.capitale, '.');
                writeln('  📍 Arrivée à ', etape.deplacement.paysEtape.nom, ' (', etape.deplacement.paysEtape.capitale, ') - ', etape.deplacement.minutes, ' minutes');
                // On précise si la journée est passée dans le pays de destination
                if etape.deplacement.paysEtape.nom = criteres.paysArrivee.nom then
                    writeln('  🌟 Journée dans le pays de destination : ', etape.deplacement.paysEtape.nom, '.');
            end;
        end;

        if i < length(voyage.planning) - 1 then
            writeln('----------------------------------------')
        else
            writeln('🏁 Fin de votre voyage !');
    end;

    // Affichage des informations relatives au voyage
    afficherInfos(voyage, criteres);
    afficherVoyageAlternatif(voyage, criteres, europe);

    writeln();
end;


end.
