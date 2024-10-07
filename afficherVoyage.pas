unit afficherVoyage;

interface
uses types;
procedure afficherVoyage(voyage:TVoyage);
procedure afficherUneEtape(uneEtape:TEtape);
procedure afficherUneAct(uneAct:TActivite);
procedure afficherInfos(voyage:TVoyage);

implementation


procedure afficherVoyage(voyage:TVoyage);
var jour,i:Integer;
begin
    
    afficherInfos(voyage);
    for jour:=1 to length(voyage.intineraire) do
        begin

        for i:=1 to length(voyage.planning) do
            if (voyage.planning[i].jour=jour) then
                begin

                writeln('Jour',jour,' :');
                if jour=1 then
                    writeln('= Journée sur votre pays de départ :',voyage.intineraire[jour].capitale,'')
                else if jour=length(voyage.intineraire) then
                    writeln('= Dernière journée sur votre pays de départ',voyage.intineraire[jour].capitale,'.')
                else
                    writeln('= Voyage en tain depuis ',voyage.intineraire[i-1].capitale,' jusqu''à ',voyage.intineraire[i].capitale,'.');

                writeln('= Arrivée en ',voyage.intineraire[jour].nom,' (',voyage.intineraire[jour].nom,').');

                afficherUneEtape(voyage.planning[i]);

                end;

        writeln();
        writeln('transition pour l''etape suivante');
        writeln();

        end;
end;

procedure afficherInfos(voyage:TVoyage);
begin
    writeln('Détails du voyage');
    writeln('La durée du séjour est de ',length(voyage.intineraire),' jours.');
    writeln('Le coût total est de ',voyage.coutTotal,'.');
    writeln('Vous aller parcourir une distance de ',voyage.kmTotal, 'en train à travers toute l''Europe, destination ');
    writeln('informations seulement renseignées dans les critères?')
end;


procedure afficherUneEtape(uneEtape:TEtape);
var i:Integer;
begin
    
    for i:=1 to 2 do
        writeln('> Activités :');
        afficherUneAct(uneEtape.activite[i]);
end;


procedure afficherUneAct(uneAct:TActivite);
begin
    write(', ',uneAct.nom,' ');
end;


end.
