{ Programme de test de la fonction calculerItineraire }
program testItineraire;

uses calculItineraire, chargerDonnees, strutils, sysutils, utils, voyageTypes;

// Structure de test
type TTestCase = record
        input: String; // Entrée
        expected: String; // Sortie attendue
        output: String; // Sortie du programme
        modeTransport: TMode; // Mode de transport
    end;

// Tableau de tests
type ArrayTestCase = array of TTestCase;

// Affichage de l'itinéraire
function afficherItineraire(result: TItineraireResult): String;
var i: Integer;
begin
    if result.erreur then
        afficherItineraire := ('Erreur : ' + result.message)
    else begin
        afficherItineraire := ('');
        for i := 0 to length(result.itineraire) - 1 do
        begin
            afficherItineraire := afficherItineraire + (result.itineraire[i].nom);
            if i < length(result.itineraire) - 1 then
                afficherItineraire := afficherItineraire + (' -> ');
        end;
    end;
end;

// Création d'un test
function creerTestCase(input, output: String; modeTransport: TMode): TTestCase;
begin
    creerTestCase.input := input;
    creerTestCase.output := output;
    creerTestCase.modeTransport := modeTransport;
end;

// Recherche d'un pays dans la liste
function trouverPays(nom: String; listePays: TEurope; var trouve: Boolean): TPays;
var i: Integer;
begin
    for i := 0 to length(listePays) - 1 do
        if listePays[i].nom = nom then
        begin
            trouverPays := listePays[i];
            trouve := true;
            break;
        end;
end;

var
    i: Integer;
    europe: TEurope;
    splitText: TStringArray;
    testCases: ArrayTestCase;
    output: String;
    trouve: Boolean;
    paysDepart, paysArrivee: TPays;
    resultat: TItineraireResult;
    isFailed: Boolean;
begin
    setlength(testCases, 21);
    testCases[0] := creerTestCase('France -> Allemagne', 'France -> Allemagne', TrainSeul);
    testCases[1] := creerTestCase('Belgique -> Italie', 'Belgique -> France -> Italie', TrainSeul);
    testCases[2] := creerTestCase('Espagne -> Suisse', 'Espagne -> France -> Suisse', TrainSeul);
    testCases[3] := creerTestCase('Portugal -> Pologne', 'Portugal -> Espagne -> France -> Allemagne -> Pologne', TrainSeul);
    testCases[4] := creerTestCase('Italie -> Autriche', 'Italie -> Autriche', TrainSeul);
    testCases[5] := creerTestCase('Norvège -> Suède', 'Norvège -> Suède', TrainSeul);
    testCases[6] := creerTestCase('Pays-Bas -> Danemark', 'Pays-Bas -> Allemagne -> Danemark', TrainSeul);
    testCases[7] := creerTestCase('Grèce -> Hongrie', 'Grèce -> Bulgarie -> Roumanie -> Hongrie', TrainSeul);
    testCases[8] := creerTestCase('Allemagne -> Espagne', 'Allemagne -> France -> Espagne', TrainSeul);
    testCases[9] := creerTestCase('Suisse -> Autriche', 'Suisse -> Autriche', TrainSeul);
    testCases[10] := creerTestCase('Irlande -> Royaume-Uni', 'Irlande -> Royaume-Uni', TrainSeul);
    testCases[11] := creerTestCase('Hongrie -> Russie', 'Hongrie -> Ukraine -> Russie', TrainSeul);
    testCases[12] := creerTestCase('Autriche -> Bulgarie', 'Autriche -> Hongrie -> Roumanie -> Bulgarie', TrainSeul);
    testCases[13] := creerTestCase('Espagne -> Italie', 'Espagne -> France -> Italie', TrainSeul);
    testCases[14] := creerTestCase('France -> Portugal', 'France -> Espagne -> Portugal', TrainSeul);
    testCases[15] := creerTestCase('Finlande -> Estonie', 'Finlande -> Russie -> Estonie', TrainSeul);
    testCases[16] := creerTestCase('Russie -> Norvège', 'Russie -> Norvège', TrainSeul);
    testCases[17] := creerTestCase('Suède -> Lettonie', 'Suède -> Finlande -> Russie -> Lettonie', TrainSeul);
    testCases[18] := creerTestCase('Grèce -> Espagne', 'Grèce -> Monténégro -> Croatie -> Slovénie -> Italie -> France -> Espagne', TrainSeul);
    testCases[19] := creerTestCase('Danemark -> Portugal', 'Danemark -> Allemagne -> France -> Espagne -> Portugal', TrainSeul);
    testCases[20] := creerTestCase('Royaume-Uni -> France', 'Royaume-Uni -> France', TrainSeul);

    // Chargement des données
    europe := chargerEurope();

    // On dit que tous les tests ont réussi
    isFailed := false;

    for i := 0 to length(testCases) - 1 do
    begin
        writeln('Exécution du test : ', testCases[i].input);
        splitText := splitString(testCases[i].input, ' -> ');

        paysDepart := trouverPays(splitText[0], europe, trouve);
        if not trouve then
        begin
            writeln('❌ Impossible de trouver le pays : ', splitText[0]);
            isFailed := true;
            continue;
        end;

        paysArrivee := trouverPays(splitText[1], europe, trouve);
        if not trouve then
        begin
            writeln('❌ Impossible de trouver le pays : ', splitText[0]);
            isFailed := true;
            continue;
        end;

        // Calcul de l'itinéraire
        resultat := calculerItineraire(europe, paysDepart, paysArrivee, testCases[i].modeTransport);
        output := afficherItineraire(resultat);

        writeln('  Sortie attendue : ', testCases[i].output);
        writeln('   Sortie du test : ', output);

        // Comparaison des résultats
        if output = testCases[i].output then
            writeln('✅ Test validé')
        else begin
            isFailed := true;
            writeln('❌ Test non réussi');
        end;
        writeln();
    end;

    if isFailed then
        writeln('❌ Tests non réussis')
    else
        writeln('✅ Tous les tests ont été réussis');
end.
