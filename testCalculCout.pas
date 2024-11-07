program testCalculCout;

uses types,chargerDonnees,ChoixCriteres,triDesPays,calculCout;

var criteres: TCriteres;
voyage:TVoyage;
europe:TEurope;

begin
    setlength(europe,3);
    europe[0].nom:='France';
    europe[0].capitale:='Paris';
    europe[0].latitude:=46.0;
    europe[0].longitude:=2.0;

    setlength(europe[0].activites,3);
    europe[0].activites[0].nom:='Tour Eiffel';

    setlength(europe[0].activites[0].categories,3);
    europe[0].activites[0].categories[0]:=Histoire;
    europe[0].activites[0].categories[1]:=Histoire;
    europe[0].activites[0].categories[2]:=Histoire;

    europe[0].activites[1].nom:='Louvre';
    setlength(europe[0].activites[1].categories,3);
    europe[0].activites[1].categories[0]:=Culture;
    europe[0].activites[1].categories[1]:=Histoire;
    europe[0].activites[1].categories[2]:=JourneeComplete;

    europe[0].activites[2].nom:='Arc de Trimphe';
    setlength(europe[0].activites[2].categories,3);
    europe[0].activites[2].categories[0]:=Culture;
    europe[0].activites[2].categories[1]:=EnFamille;
    europe[0].activites[2].categories[2]:=Histoire;


    europe[0].climat[Janvier]:=15;
    europe[0].climat[Fevrier]:=6;
    europe[0].climat[Mars]:=8;
    europe[0].climat[Avril]:=9;
    europe[0].climat[Mai]:=12;
    europe[0].climat[Juin]:=15;
    europe[0].climat[Juillet]:=17;
    europe[0].climat[Aout]:=18;
    europe[0].climat[Septembre]:=13;
    europe[0].climat[Octobre]:=10;
    europe[0].climat[Novembre]:=8;
    europe[0].climat[Decembre]:=5;


    //Allemagne
    europe[1].nom := 'Allemagne';
    europe[1].capitale := 'Berlin';
    europe[1].latitude:=51.0;
    europe[1].longitude:=9.0;

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
    europe[1].activites[2].categories[1] := EnFamille;
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
    europe[1].climat[Octobre] := 10;
    europe[1].climat[Novembre] := 5;
    europe[1].climat[Decembre] := 2;


    //Espagne   
    europe[2].nom := 'Espagne';
    europe[2].capitale := 'Madrid';
    europe[2].latitude:=40.0;
    europe[2].longitude:=-4.0;

    setlength(europe[2].activites, 3);

    europe[2].activites[0].nom := 'Sagrada Familia';
    setlength(europe[2].activites[0].categories, 3);
    europe[2].activites[0].categories[0] := Culture;
    europe[2].activites[0].categories[1] := Histoire;
    europe[2].activites[0].categories[2] := ReligieuxEtSpirituel;

    europe[2].activites[1].nom := 'Alhambra';
    setlength(europe[2].activites[1].categories, 3);
    europe[2].activites[1].categories[0] := Histoire;
    europe[2].activites[1].categories[1] := Culture;
    europe[2].activites[1].categories[2] := Photographie;

    europe[2].activites[2].nom := 'Plage de Barceloneta';
    setlength(europe[2].activites[2].categories, 3);
    europe[2].activites[2].categories[0] := AventureAquatique;
    europe[2].activites[2].categories[1] := Relaxation;
    europe[2].activites[2].categories[2] := EnFamille;

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
    setlength(criteres.categorie,2);
    criteres.categorie[0]:=Histoire;
    criteres.categorie[1]:=Culture;
    criteres.periode:=Octobre;
    criteres.climat:=10;  
    criteres.duree:=1;
    criteres.paysArrivee:=europe[0];
    criteres.paysDepart:=europe[1];

    //voyage
    setlength(voyage.itineraire,3);
    setlength(voyage.planning,3);

    voyage.itineraire[0]:=europe[0];
    voyage.planning[0].jour:=1;
    setlength(voyage.planning[0].activite,2);
    voyage.planning[0].activite[0].nom:='Act1';
    voyage.planning[0].activite[0].cout:=10;
    voyage.planning[0].activite[1].nom:='Act2';
    voyage.planning[0].activite[1].cout:=20;

    voyage.itineraire[1]:=europe[1];
    voyage.planning[1].jour:=2;
    setlength(voyage.planning[1].activite,2);
    voyage.planning[1].activite[0].nom:='Act3';
    voyage.planning[1].activite[0].cout:=30;
    voyage.planning[1].activite[1].nom:='Act4';
    voyage.planning[1].activite[1].cout:=40;

    voyage.itineraire[2]:=europe[2];
    voyage.planning[2].jour:=3;
    setlength(voyage.planning[2].activite,2);
    voyage.planning[2].activite[0].nom:='Act5';
    voyage.planning[2].activite[0].cout:=50;
    voyage.planning[2].activite[1].nom:='Act6';
    voyage.planning[2].activite[1].cout:=60;

    calculDistanceTotal(voyage);
    coutTotal(voyage)
end.
