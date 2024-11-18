unit afficherVoyage;

interface
uses voyageTypes;

procedure afficher(voyage:TVoyage;criteres:TCriteres);
procedure afficherUneEtape(uneEtape:TEtape);
procedure afficherUneAct(uneAct:TActivite);
procedure afficherInfos(voyage:TVoyage;criteres:TCriteres);

implementation


procedure afficher(voyage:TVoyage;criteres:TCriteres);
var i:Integer;
begin
      afficherInfos(voyage,criteres);

      for i:=0 to length(voyage.planning)-2 do
      begin
        writeln('Jour ',i+1,' :');
        if (voyage.planning[i].paysEtape.nom=criteres.paysArrivee.nom) and (voyage.planning[i+1].paysEtape.nom=criteres.paysArrivee.nom)  then
          begin
            writeln('= Journée sur votre pays de destination : ',voyage.planning[i].paysEtape.nom,' (',voyage.planning[i].paysEtape.capitale,').');
            afficherUneEtape(voyage.planning[i])
          end
        else if i=length(voyage.planning)-2 then
          begin
            writeln('= Voyage en train depuis ',voyage.planning[i].paysEtape.capitale,' jusqu''à ',voyage.planning[i+1].paysEtape.capitale,'.');
            writeln('= Arrivée en ',voyage.planning[i+1].paysEtape.nom,' (',voyage.planning[i+1].paysEtape.capitale,').');
            writeln('Fin de votre voyage !')
          end
        else 
          begin 
            writeln('= Voyage en train depuis ',voyage.planning[i].paysEtape.capitale,' jusqu''à ',voyage.planning[i+1].paysEtape.capitale,'.');
            writeln('= Arrivée en ',voyage.planning[i+1].paysEtape.nom,' (',voyage.planning[i+1].paysEtape.capitale,').');
            afficherUneEtape(voyage.planning[i+1]);
          end;     
      end;
      writeln();       
end;

procedure afficherInfos(voyage:TVoyage;criteres:TCriteres);
begin
    writeln('Détails du voyage :');
    writeln();
    writeln('La durée du séjour est de ',length(voyage.itineraire)-1,' jours.');
    writeln();
    writeln('Le coût total est de ',voyage.coutTotal:5:0,' euros.');
    writeln();
    writeln('Vous aller parcourir une distance de ',voyage.kmTotal:5:1, 'km en train à travers l''Europe, depuis ',criteres.paysDepart.nom,' destination ',criteres.paysArrivee.nom, '.');
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
