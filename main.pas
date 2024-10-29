program main;
uses types, chargerDonnees, ChoixCriteres,triDesPays;

var europe,paysValables: Array [1..5] of TPays;
var criteres: TCriteres;
i:Integer;
begin
    //europe := chargerPays();
    //demanderCriteres(criteres, europe);

    //initialisation pour test
    europe[1].nom := 'France';
    europe[1].capitale := 'Paris';
    europe[1].activites[1].nom:='Tour Eiffel';
    europe[1].activites[1].categorie[1]:=lieuUnique;
    europe[1].activites[1].categorie[2]:=monument;
    europe[1].activites[1].cout:=25;
    europe[1].activites[2].nom:='Louvre';
    europe[1].activites[2].categorie[1]:=lieuUnique;
    europe[1].activites[2].categorie[2]:=musee;
    europe[1].activites[2].cout:=17;


    //test pour tridespays
    //paysValables:=triDesPays(criteres;europe);
    //for i:=1 to length(paysValables) do 
        //writeln(paysValables[i].nom)

end.
