program main;

uses afficherVoyage, chargerDonnees, choixCriteres, constantes, score, voyageTypes;

var europe, paysVal, itineraire: TEurope;
    criteres: TCriteres;
    voyage: TVoyage;
    i: Integer;
    fourchette: Real;
    nbAct: Integer;
    numeroPays: Integer;

begin
    //France
    setlength(europe, 3);
    europe[0].nom := 'France';
    europe[0].capitale := 'Paris';

    setlength(europe[0].activites, 3);
    europe[0].activites[0].nom := 'Tour Eiffel';

    setlength(europe[0].activites[0].categories, 3);
    europe[0].activites[0].categories[0] := Aventure;
    europe[0].activites[0].categories[1] := Culture;
    europe[0].activites[0].categories[2] := Hiver;

    europe[0].activites[1].nom := 'Louvre';
    setlength(europe[0].activites[1].categories, 3);
    europe[0].activites[1].categories[0] := Histoire;
    europe[0].activites[1].categories[1] := Aventure;
    europe[0].activites[1].categories[2] := JourneeComplete;

    europe[0].activites[2].nom := 'Arc de Trimphe';
    setlength(europe[0].activites[2].categories, 3);
    europe[0].activites[2].categories[0] := Culture;
    europe[0].activites[2].categories[1] := Histoire;
    europe[0].activites[2].categories[2] := Aventure;


    europe[0].climat[Janvier] := 15;
    europe[0].climat[Fevrier] := 6;
    europe[0].climat[Mars] := 8;
    europe[0].climat[Avril] := 9;
    europe[0].climat[Mai] := 12;
    europe[0].climat[Juin] := 15;
    europe[0].climat[Juillet] := 17;
    europe[0].climat[Aout] := 20;
    europe[0].climat[Septembre] := 13;
    europe[0].climat[Octobre] := 20;
    europe[0].climat[Novembre] := 8;
    europe[0].climat[Decembre] := 5;


    //Allemagne
    europe[1].nom := 'Allemagne';
    europe[1].capitale := 'Berlin';

    setlength(europe[1].activites, 3);

    europe[1].activites[0].nom := 'Brandenburger Tor';
    setlength(europe[1].activites[0].categories, 3);
    europe[1].activites[0].categories[0] := Histoire;
    europe[1].activites[0].categories[1] := Culture;
    europe[1].activites[0].categories[2] := Photographie;

    europe[1].activites[1].nom := 'Musee de Pergame';
    setlength(europe[1].activites[1].categories, 3);
    europe[1].activites[1].categories[0] := Culture;
    europe[1].activites[1].categories[1] := Histoire;
    europe[1].activites[1].categories[2] := Immersif;

    europe[1].activites[2].nom := 'Forêt-Noire';
    setlength(europe[1].activites[2].categories, 3);
    europe[1].activites[2].categories[0] := Nature;
    europe[1].activites[2].categories[1] := Culture;
    europe[1].activites[2].categories[2] := RoadTrip;

    europe[1].climat[Janvier] := 1;
    europe[1].climat[Fevrier] := 2;
    europe[1].climat[Mars] := 5;
    europe[1].climat[Avril] := 9;
    europe[1].climat[Mai] := 13;
    europe[1].climat[Juin] := 17;
    europe[1].climat[Juillet] := 19;
    europe[1].climat[Aout] := 18;
    europe[1].climat[Septembre] := 14;
    europe[1].climat[Octobre] := 17;
    europe[1].climat[Novembre] := 5;
    europe[1].climat[Decembre] := 2;


    //Espagne   
    europe[2].nom := 'Espagne';
    europe[2].capitale := 'Madrid';

    setlength(europe[2].activites, 3);

    europe[2].activites[0].nom := 'Sagrada Familia';
    setlength(europe[2].activites[0].categories, 3);
    europe[2].activites[0].categories[0] := Culture;
    europe[2].activites[0].categories[1] := Histoire;
    europe[2].activites[0].categories[2] := Histoire;

    europe[2].activites[1].nom := 'Alhambra';
    setlength(europe[2].activites[1].categories, 3);
    europe[2].activites[1].categories[0] := Histoire;
    europe[2].activites[1].categories[1] := Culture;
    europe[2].activites[1].categories[2] := Aventure;

    europe[2].activites[2].nom := 'Plage de Barceloneta';
    setlength(europe[2].activites[2].categories, 3);
    europe[2].activites[2].categories[0] := AventureAquatique;
    europe[2].activites[2].categories[1] := Relaxation;
    europe[2].activites[2].categories[2] := Culture;

    europe[2].climat[Janvier] := 10;
    europe[2].climat[Fevrier] := 11;
    europe[2].climat[Mars] := 13;
    europe[2].climat[Avril] := 15;
    europe[2].climat[Mai] := 18;
    europe[2].climat[Juin] := 22;
    europe[2].climat[Juillet] := 25;
    europe[2].climat[Aout] := 26;
    europe[2].climat[Septembre] := 23;
    europe[2].climat[Octobre] := 18;
    europe[2].climat[Novembre] := 13;
    europe[2].climat[Decembre] := 10;

    //Critères
    setlength(criteres.categories, 3);
    criteres.categories[0] := Histoire;
    criteres.categories[1] := Culture;
    criteres.categories[2] := Aventure;
    criteres.periode := Octobre;
    criteres.climat := 10;
    criteres.duree := 1;


{writeln('matchpref',matchPreference(europe[2].activites[2],criteres.categorie));
writeln('matchact',matchActivite(europe[2],criteres.categorie));
writeln('matchclimat',matchClimat(criteres.climat,europe[2],criteres.periode));

writeln('pays filtres');
for i:=0 to length(filtrerPays(criteres,europe))-1 do
    writeln(filtrerPays(criteres,europe)[i].nom);

paysVal:=filtrerPays(criteres,europe);
setlength(itineraire,2);
itineraire[0]:=europe[0];
itineraire[1]:=europe[1];
voyage:=genererActivitePays(itineraire,criteres);

writeln('itineraire voyage');
for i:=0 to length(voyage.itineraire)-1 do
    begin
        writeln(voyage.itineraire[i].nom);
    end;

writeln('planning');
for i:=0 to length(voyage.planning)-1 do
    begin
        writeln(voyage.planning[i].activite[0].nom);
        writeln(voyage.planning[i].activite[1].nom);
    end;

writeln('verifDuree',verifDuree(itineraire,criteres));

writeln('filtre pays');
writeln(length(suppressionPaysVisite(paysVal,itineraire)));
for i:=0 to length(suppressionPaysVisite(paysVal,itineraire))-1 do
    begin
        writeln(suppressionPaysVisite(paysVal,itineraire)[i].nom);
    end;

writeln(scoreClimat(criteres.climat,europe[0],criteres.periode));
writeln(scoreActivitePays(europe[0],criteres.categorie,2));}


    fourchette := 20;
    nbAct := 3;
    numeroPays := 2;

    for i := 0 to 2 do
    begin
        scoreActivite(criteres.categories, 0, europe[numeroPays].activites[i]);
        writeln(europe[numeroPays].activites[i].score);
    end;


{writeln((europe[numeroPays].activites[0],criteres.categories,0));
writeln(scoreActivite(europe[numeroPays].activites[1],criteres.categories,0));
writeln(scoreActivite(europe[numeroPays].activites[2],criteres.categories,0));

writeln('climat',scoreClimat(criteres.climat,criteres.periode,europe[numeroPays],fourchette));
writeln('act',scoreActivitePays(europe[numeroPays],criteres.categories,nbAct));
scorePays(1,1,criteres,nbAct,fourchette,europe[numeroPays]);
writeln('score total',europe[numeroPays].score);}

end.
