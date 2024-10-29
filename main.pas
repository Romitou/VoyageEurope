program main;
uses types, chargerDonnees, ChoixCriteres,triDesPays;

var europe,paysValables: Array [1..2] of TPays;
var criteres: TCriteres;
i:Integer;
begin
    //europe := chargerPays();
    //demanderCriteres(criteres, europe);
    writeln('riotiogr');
    //initialisation pour test
    europe[1].nom := 'France';
    writeln('2');
    europe[1].capitale:= 'Paris';
    writeln('2.1');
    europe[1].activites[1].nom:='Tour Eiffel';
    writeln('2.2');
    europe[1].activites[1].categorie[1]:=lieuUnique;
    writeln('2.5');
    europe[1].activites[1].categorie[2]:=monument;
    europe[1].activites[1].cout:=25;
    europe[1].activites[2].nom:='Louvre';
    europe[1].activites[2].categorie[1]:=lieuUnique;
    europe[1].activites[2].categorie[2]:=musee;
    europe[1].activites[2].cout:=17;
    writeln('3');
    europe[2].nom := 'Espagne';
    europe[2].capitale := 'Madrid';
    europe[2].activites[1].nom:='Act1';
    europe[2].activites[1].categorie[1]:=lieuUnique;
    europe[2].activites[1].categorie[2]:=monument;
    europe[2].activites[1].categorie[3]:=divers;
    europe[2].activites[1].cout:=25;
    europe[2].activites[2].nom:='Act2';
    europe[2].activites[2].categorie[1]:=sport;
    europe[2].activites[2].cout:=17;
   
    //initialisation d'une partie des critères
    criteres.periode:=janvier;
    criteres.climat:=15;
    criteres.categorie[1]:=monument;
    criteres.categorie[2]:=lieuUnique;
    //test pour tridespays
    //paysValables:=triDesPays(criteres;europe);
    //for i:=1 to length(paysValables) do 
        //writeln(paysValables[i].nom)
    writeln(matchClimat(criteres.climat,europe[1],criteres.periode));

end.
