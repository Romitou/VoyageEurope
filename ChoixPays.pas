ChoixPays

procedure choixPays(var pays1, pays2: TPays);
begin 
    WriteLn('Dans quel pays commence votre voyage ?');
    ReadLn(pays1);
    pays1:= TCriteres.paysDepart;
    WriteLn('Quel pays souhaitez-vous absolument traverser durant votre voyage ?');
    ReadLn(pays2);
    pays2:= TCriteres.paysArrivee;
end;
    
