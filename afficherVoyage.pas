unit afficherVoyage;

interface
uses types;
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
                    writeln('= Journée sur votre pays de départ :',voyage.itineraire[jour].nom,'')
                else if jour=length(voyage.itineraire)-1 then
                    writeln('= Dernière journée sur votre pays de départ',voyage.itineraire[jour].nom,'.')
                else
                    writeln('= Voyage en tain depuis ',voyage.itineraire[i-1].capitale,' jusqu''à ',voyage.itineraire[i].capitale,'.');
                writeln('= Arrivée en ',voyage.itineraire[jour].nom,' (',voyage.itineraire[jour].capitale,').');

                afficherUneEtape(voyage.planning[i]);

                end;

        writeln();
      
        end;
end;

procedure afficherInfos(voyage:TVoyage;criteres:TCriteres);
begin
    writeln('Détails du voyage');
    writeln();
    writeln('La durée du séjour est de ',length(voyage.itineraire),' jours.');
    writeln();
    writeln('Le coût total est de ',voyage.coutTotal,'.');
    writeln();
    writeln('Vous aller parcourir une distance de ',voyage.kmTotal, 'en train à travers toute l''Europe, destination ',criteres.paysArrivee.nom);
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
