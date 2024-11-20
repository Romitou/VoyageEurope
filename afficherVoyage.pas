unit afficherVoyage;

interface
uses voyageTypes;

procedure afficher(voyage:TVoyage;criteres:TCriteres);
procedure afficherUneEtape(uneEtape:TEtape);
procedure afficherUneAct(uneAct:TActivite);
procedure afficherInfos(voyage:TVoyage;criteres:TCriteres);

implementation

// procedure debug(etapes: TEtapes);
// var i,j:Integer;
// begin
//   for i := 0 to length(etapes) - 1 do
//   begin
//     writeln('Jour ', etapes[i].jour, ' :');
//     for j := 0 to length(etapes[i].activite) - 1 do
//     begin
//       writeln(' - ', etapes[i].activite[j].nom);
//     end;
//   end;
// end;

procedure afficher(voyage: TVoyage; criteres: TCriteres);
var
    i: Integer;
begin
    if voyage.erreur then
    begin
        writeln('⚠️ Une erreur est survenue lors de la génération du voyage :');
        writeln(voyage.message);
        exit;
    end;

    afficherInfos(voyage, criteres);
    writeln;
    writeln('===== PLANNING DU VOYAGE =====');
    writeln;

    for i := 0 to length(voyage.planning) - 1 do
    begin
        writeln('🗓️  Jour ', i + 1);
        if voyage.planning[i].paysDepart.nom <> voyage.planning[i].paysEtape.nom then
            writeln('   🚆 Voyage depuis ', voyage.planning[i].paysDepart.capitale, ' jusqu’à ', voyage.planning[i].paysEtape.capitale, '.');
        writeln('   📍 Arrivée à ', voyage.planning[i].paysEtape.nom,  ' (', voyage.planning[i].paysEtape.capitale, ').');

        if voyage.planning[i].paysEtape.nom = criteres.paysArrivee.nom then
            writeln('   🌟 Journée dans le pays de destination : ', voyage.planning[i].paysEtape.nom, '.');

        afficherUneEtape(voyage.planning[i]);

        if i < length(voyage.planning) - 1 then
            writeln('----------------------------------------')
        else
            writeln('🏁 Fin de votre voyage !');
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
