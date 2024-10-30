program main;
uses types, chargerDonnees, ChoixCriteres,triDesPays;

var europe:Array [1..2] of TPays;
var criteres: TCriteres;
begin
   
    //europe := chargerPays();
    //demanderCriteres(criteres, europe);
 
    //initialisation pour test
    setlength(europe[1].activites,3);
    setlength(europe[2].activites,2);
    setlength(europe[1].activites[1].categories,2);
    setlength(europe[1].activites[2].categories,2);
    setlength(europe[1].activites[3].categories,2);
    setlength(europe[2].activites[1].categories,3);
    setlength(europe[2].activites[2].categories,1);
    setlength(criteres.categorie,3);

    //Initialisation pour Paris
    europe[1].nom := 'France';
    europe[1].capitale:= 'Paris';
    europe[1].activites[1].nom:='Tour Eiffel';
    europe[1].activites[1].categories[1]:=lieuUnique;
    europe[1].activites[1].categories[2]:=monument;
    europe[1].activites[1].cout:=25;
    europe[1].activites[2].nom:='Louvre';
    europe[1].activites[2].categories[1]:=lieuUnique;
    europe[1].activites[2].categories[2]:=musee;
    europe[1].activites[2].cout:=17;
    europe[1].activites[3].nom:='Arc de Triomphe';
    europe[1].activites[3].categories[1]:=lieuUnique;
    europe[1].activites[3].categories[2]:=monument;
    europe[1].activites[1].cout:=25;

    europe[1].Climat[Janvier] := 5;
    europe[1].Climat[Fevrier] := 6;
    europe[1].Climat[Mars] := 10;
    europe[1].Climat[Avril] := 15;
    europe[1].Climat[Mai] := 20;
    europe[1].Climat[Juin] := 25;
    europe[1].Climat[Juillet] := 30;
    europe[1].Climat[Aout] := 28;
    europe[1].Climat[Septembre] := 22;
    europe[1].Climat[Octobre] := 15;
    europe[1].Climat[Novembre] := 10;
    europe[1].Climat[Decembre] := 6;

    // Initialisation pour Madrid
    europe[2].nom := 'Espagne';
    europe[2].capitale := 'Madrid';
    europe[2].activites[1].nom:='Act1';
    europe[2].activites[1].categories[1]:=lieuUnique;
    europe[2].activites[1].categories[2]:=monument;
    europe[2].activites[1].categories[3]:=divers;
    europe[2].activites[1].cout:=25;
    europe[2].activites[2].nom:='Act2';
    europe[2].activites[2].categories[1]:=sport;
    europe[2].activites[2].cout:=17;
    europe[2].Climat[Janvier] := 7;
    europe[2].Climat[Fevrier] := 9;
    europe[2].Climat[Mars] := 12;
    europe[2].Climat[Avril] := 18;
    europe[2].Climat[Mai] := 22;
    europe[2].Climat[Juin] := 30;
    europe[2].Climat[Juillet] := 35;
    europe[2].Climat[Aout] := 34;
    europe[2].Climat[Septembre] := 27;
    europe[2].Climat[Octobre] := 19;
    europe[2].Climat[Novembre] := 12;
    europe[2].Climat[Decembre] := 8;

    //initialisation d'une partie des critères
    criteres.periode:=Decembre;
    criteres.climat:=6;
    criteres.categorie[1]:=monument;
    criteres.categorie[2]:=lieuUnique;


    //writeln('matchclimat : ',matchClimat(criteres.climat,europe[1],criteres.periode));
    //writeln('matchpref : ',matchPreference(europe[2].activites[1],criteres.categorie));
    //writeln('matchact',matchActivite(europe[1],criteres.categorie));
    //writeln('tri des pays : pays valables :');


end.
