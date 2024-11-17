unit afficherVoyage;

interface
uses voyageTypes;

procedure afficher(voyage:TVoyage;criteres:TCriteres);
procedure afficherUneEtape(uneEtape:TEtape);
procedure afficherUneAct(uneAct:TActivite);
procedure afficherInfos(voyage:TVoyage;criteres:TCriteres);

implementation


procedure afficher(voyage:TVoyage;criteres:TCriteres);
var jour,i:Integer;
begin
    
    afficherInfos(voyage,criteres);

    for jour:=0 to length(voyage.itineraire)-1 do
        begin
        for i:=0 to length(voyage.planning)-1 do
            if (voyage.planning[i].jour=jour+1) then
                begin

                writeln('Jour ',jour+1,' :');

                if jour=0 then
                  begin
                     writeln('= Journée sur votre pays de départ :',voyage.itineraire[jour].nom,'');  
                     writeln('= Arrivée en ',voyage.itineraire[jour].nom,' (',voyage.itineraire[jour].capitale,').');
                  end
                else if jour=length(voyage.itineraire)-1 then
                    writeln('= Dernière journée sur votre pays de départ',voyage.itineraire[jour].nom,'.')
                else
                  begin
                    writeln('= Voyage en train depuis ',voyage.itineraire[i-2].capitale,' jusqu''à ',voyage.itineraire[i-1].capitale,'.');
                    writeln('= Arrivée en ',voyage.itineraire[jour].nom,' (',voyage.itineraire[jour].capitale,').');
                  end;
             
                afficherUneEtape(voyage.planning[i-1]);

                end;

        writeln();
      
        end;
end;

procedure afficherInfos(voyage:TVoyage;criteres:TCriteres);
begin
    writeln('Détails du voyage :');
    writeln();
    writeln('La durée du séjour est de ',length(voyage.itineraire)-1,' jours.');
    writeln();
    writeln('Le coût total est de ',voyage.coutTotal:5:0,' euros.');
    writeln();
    writeln('Vous aller parcourir une distance de ',voyage.kmTotal:5:1, 'km en train à travers l''Europe, destination ',criteres.paysArrivee.nom);
    writeln();
end;


procedure afficherUneEtape(uneEtape:TEtape);
var i:Integer;
begin
 
    for i:=0 to 1 do
        begin
        write('> Activités :');         
        afficherUneAct(uneEtape.activite[i]);
        writeln();
        end;

end;


procedure afficherUneAct(uneAct:TActivite);
begin
    write(' ',uneAct.nom);
end;


end.
