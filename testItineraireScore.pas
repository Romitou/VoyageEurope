program main;

uses voyageTypes, chargerDonnees, choixCriteres,calculItineraireScore,score;

var europe: TEurope;
criteres: TCriteres;
aller:TItineraireResult;
i,j,nbActParJour:Integer;
coeffAct,coeffClim,intervalleTemp:Real;

begin

    europe:=chargerEurope();
    //demanderCriteres(criteres,europe);
 
    setlength(criteres.categories,3);
    criteres.categories[0]:=Histoire;
    criteres.categories[1]:=Culture;
    criteres.categories[2]:=Art;
    criteres.periode:=Janvier;
    criteres.climat:=10;  
    criteres.duree:=10;
    criteres.paysDepart:=europe[3];
    criteres.paysArrivee:=europe[13];

 {for j:=0 to length(europe)-1 do
        begin
        triActPays(criteres.categories,europe[j]);
        for i:=0 to length(europe[j].ordreAct)-1 do
            writeln(europe[j].activites[europe[j].ordreAct[i]].nom,' : ',scoreActivite(europe[j].activites[europe[j].ordreAct[i]],criteres.categories));
        writeln('');
        writeln('pays suivant');
        writeln('');
        end;}
    {writeln('Calcul des scores...');
    coeffAct:=1;
    coeffClim:=1;
    nbActParJour:=3;
    intervalleTemp:=15;
    for i:=0 to length(europe)-1 do 
        begin
        scorePays(coeffAct,coeffClim,criteres,nbActParJour,intervalleTemp,europe[i]);
        writeln(europe[i].nom,' : ',europe[i].score)
        end;
    //europe[11].score:=0.9;
    //europe[16].score:=0.9;
    //writeln(europe[35].nom);
    

    writeln('Calcul de l''itinéraire aller...');
    aller := calculerItineraire(europe, criteres.paysDepart, criteres.paysArrivee);

    for i:=0 to length(aller.itineraire)-1 do 
        writeln('- ', aller.itineraire[i].nom);}
end.