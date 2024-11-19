program testCalculItineraire;

uses chargerDonnees, voyageTypes, calculItineraire, sysutils, utils;

type TTestCase = record
    input: String;
    expected: String;
    output: String; 
end;

type ArrayTestCase = array of TTestCase;

type PTPays = ^TPays;

function afficherItineraire(result: TItineraireResult): String;
var i: Integer;
begin
    if result.erreur then
    begin
        afficherItineraire := ('Erreur : ' + result.message);
    end
    else
    begin
        afficherItineraire := ('');
        for i := 0 to High(result.itineraire) do
        begin
            afficherItineraire := afficherItineraire + (result.itineraire[i].nom);
            if i < High(result.itineraire) then
                afficherItineraire := afficherItineraire + (' -> ');
        end;
    end;
end;

function creerTestCase(input, output: String): TTestCase;
begin
    creerTestCase.input := input;
    creerTestCase.output := output;
end;

function trouverPays(nom: String; listePays: TEurope): PTPays;
var i: Integer;
begin
    trouverPays := nil;
    for i := 0 to high(listePays) do
        if listePays[i].nom = nom then
        begin
            trouverPays := @listePays[i];
            exit(trouverPays);
        end;
end;

var
    i: Integer;
    europe: TEurope;
    splitText: TStringArray;
    testCases: ArrayTestCase;
    output: String;
    pointeurPays: PTPays;
    paysDepart, paysArrivee: TPays;
    resultat: TItineraireResult;

begin
    setlength(testCases, 20);
    testCases[0] := creerTestCase('France -> Allemagne', 'France -> Allemagne');
    testCases[1] := creerTestCase('Belgique -> Italie', 'Belgique -> Allemagne -> Autriche -> Italie');
    testCases[2] := creerTestCase('Espagne -> Suisse', 'Espagne -> France -> Suisse');
    testCases[3] := creerTestCase('Portugal -> Pologne', 'Portugal -> Espagne -> France -> Allemagne -> Pologne');
    testCases[4] := creerTestCase('Italie -> Autriche', 'Italie -> Autriche');
    testCases[5] := creerTestCase('Norvège -> Suède', 'Norvège -> Suède');
    testCases[6] := creerTestCase('Pays-Bas -> Danemark', 'Pays-Bas -> Allemagne -> Danemark');
    testCases[7] := creerTestCase('Grèce -> Hongrie', 'Grèce -> Bulgarie -> Roumanie -> Hongrie');
    testCases[8] := creerTestCase('Allemagne -> Espagne', 'Allemagne -> France -> Espagne');
    testCases[9] := creerTestCase('Suisse -> Autriche', 'Suisse -> Autriche');
    testCases[10] := creerTestCase('Irlande -> Royaume-Uni', 'Irlande -> Royaume-Uni');
    testCases[11] := creerTestCase('Hongrie -> Russie', 'Hongrie -> Ukraine -> Russie');
    testCases[12] := creerTestCase('Autriche -> Bulgarie', 'Autriche -> Hongrie -> Roumanie -> Bulgarie');
    testCases[13] := creerTestCase('Espagne -> Italie', 'Espagne -> France -> Italie');
    testCases[14] := creerTestCase('France -> Portugal', 'France -> Espagne -> Portugal');
    testCases[15] := creerTestCase('Finlande -> Estonie', 'Finlande -> Estonie');
    testCases[16] := creerTestCase('Russie -> Norvège', 'Russie -> Finlande -> Norvège');
    testCases[17] := creerTestCase('Suède -> Lettonie', 'Suède -> Estonie -> Lettonie');
    testCases[18] := creerTestCase('Grèce -> Espagne', 'Aucun chemin trouvé');
    testCases[19] := creerTestCase('Danemark -> Portugal', 'Danemark -> Allemagne -> France -> Espagne -> Portugal');
    //
    testCases[20] := creerTestCase('Royaume-Uni -> France', 'ERREUR');

    europe := chargerEurope();

    for i := 0 to high(testCases) do
    begin
        writeln('Exécution du test : ', testCases[i].input);
        splitText := splitString(testCases[i].input, ' -> ');

        pointeurPays := trouverPays(splitText[0], europe);
        if (pointeurPays = nil) then
        begin
            writeln('❌ Impossible de trouver le pays : ', splitText[0]);
            continue;
        end;
        paysDepart := pointeurPays^;
        
        pointeurPays := trouverPays(splitText[1], europe);
        if pointeurPays = nil then
        begin
            writeln('❌ Impossible de trouver le pays : ', splitText[0]);
            continue;
        end;
        paysArrivee := pointeurPays^;

        resultat := calculerItineraire(europe, paysDepart, paysArrivee);
        output := afficherItineraire(resultat);
        writeln('  Sortie attendue : ', testCases[i].output);
        writeln('   Sortie du test : ', output);
        if output = testCases[i].output then writeln('✅ Test validé') else writeln('❌ Test non réussi');
        writeln();
    end;

    // // Cas de test 1 : Itinéraire de la France à l'Allemagne
    // Writeln('Cas de test 1 : France -> Allemagne');


    
    // resultat := calculerItineraire(europe, paysDepart, paysArrivee);
    // afficherItineraire(resultat);

    // // Cas de test 2 : Itinéraire de la Belgique à l'Italie (chemin indirect)
    // Writeln('Cas de test 2 : Belgique -> Italie');
    // paysDepart := europe[1]; // Belgique
    // paysArrivee.nom := 'Italie'; // Italie (non défini dans initialisation, pour test d'absence)
    // resultat := calculerItineraire(europe, paysDepart, paysArrivee);
    // afficherItineraire(resultat);

    // // Cas de test 3 : Itinéraire de l'Espagne à la Suisse (chemin avec plusieurs étapes)
    // Writeln('Cas de test 3 : Espagne -> Suisse');
    // paysDepart := europe[4]; // Espagne
    // paysArrivee := europe[3]; // Suisse
    // resultat := calculerItineraire(europe, paysDepart, paysArrivee);
    // afficherItineraire(resultat);

    // // Cas de test 4 : Itinéraire où aucun chemin n'est possible
    // Writeln('Cas de test 4 : Espagne -> Italie (non connectée)');
    // paysDepart := europe[4]; // Espagne
    // paysArrivee.nom := 'Italie'; // Italie (non connectée)
    // resultat := calculerItineraire(europe, paysDepart, paysArrivee);
    // afficherItineraire(resultat);

    // Writeln('Tests terminés.');
end.