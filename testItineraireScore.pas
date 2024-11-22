program main;

uses voyageTypes, chargerDonnees, choixCriteres,calculItineraire,score;

var europe: TEurope;
criteres: TCriteres;
aller,retour:TItineraireResult;
i,nbActParJour:Integer;
coeffAct,coeffClim,intervalleTemp,coeffDiv:Real;

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
    criteres.paysDepart:=europe[16];
    criteres.paysArrivee:=europe[14];
    writeln(europe[1].nom);


    writeln('Calcul des scores...');
    coeffAct:=1;
    coeffClim:=1;
    nbActParJour:=3;
    intervalleTemp:=15;
    coeffDiv:=2;
    for i:=0 to length(europe)-1 do 
        begin
        scorePays(coeffAct,coeffClim,criteres,nbActParJour,intervalleTemp,europe[i]);
        writeln(europe[i].nom,' : ',europe[i].score)
        end;
    //europe[0].score:=1;
    //europe[3].score:=1;
    //europe[35].score:=1;
    //europe[16].score:=0.9;
    //writeln(europe[35].nom);
    

    writeln('Calcul de l''itinéraire aller...');
    aller := calculerItineraire(europe, criteres.paysDepart, criteres.paysArrivee);

    for i:=0 to length(aller.itineraire)-1 do 
        writeln('- ', aller.itineraire[i].nom);

    writeln('Réduction des scores des pays traversés...');
    
    {for i := 0 to length(aller.itineraire) - 1 do
        begin
        aller.itineraire[i].score:=aller.itineraire[i].score/coeffDiv;
        writeln(aller.itineraire[i].nom);
        writeln(aller.itineraire[i].score);
        end;

    writeln(aller.itineraire[1].nom);
    writeln(aller.itineraire[1].score);

    writeln(europe[0].nom);
    writeln(europe[0].score);}

    paysVisites(coeffDiv,aller.itineraire,europe);

    for i:=0 to length(europe)-1 do 
        writeln(europe[i].nom,' : ',europe[i].score);


    writeln('Calcul de l''itinéraire retour...');
    retour := calculerItineraire(europe, criteres.paysArrivee, criteres.paysDepart);

    for i:=0 to length(retour.itineraire)-1 do 
        writeln('- ', retour.itineraire[i].nom);

end.