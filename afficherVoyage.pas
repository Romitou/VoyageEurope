unit afficherVoyage;

interface
uses types;
procedure afficherVoyage(voyage:TVoyage);
procedure afficherUneEtape(uneEtape:TEtape);
procedure afficherUneAct(uneAct:TActivite);
procedure afficherInfos(voyage:TVoyage);

implementation


procedure afficherVoyage(voyage:TVoyage);
var jour,i,k:Integer;
begin
    
    afficherInfos(voyage);
    for jour:=1 to length(voyage.intineraire) do
        begin

        writeln('jour',jour,' :');
//affiche toutes les etapes d'un jour
        
        for i:=1 to length(voyage.planning) do
            if (voyage.planning[i].jour=jour) then
                afficherUneEtape(voyage.planning[i]);

        writeln('transition');

        end;
end;

procedure afficherInfos(voyage:TVoyage);
begin
    writeln('Détails du voyage');
    writeln('La durée du séjour est de ',length(voyage.intineraire),' jours.');
    writeln('Le coût total est de ',voyage.coutTotal,'.');
    writeln('Vous aller parcourir une distance de ',voyage.kmTotal, 'en train à travers toute l''Europe, destination ');
end;


procedure afficherUneEtape(uneEtape:TEtape);
begin
    writeln('')
end;


procedure afficherUneAct(uneAct:TActivite);
begin

end;




end.