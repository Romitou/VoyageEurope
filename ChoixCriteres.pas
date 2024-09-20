UNIT SelectionCriteres;

interface

procedure choixPays(var pays1, pays2: TPays);
procedure choixPreferences(var prefUser : Array [1..MAXPREF] of TPref);

end;

implementation

procedure choixPays(var pays1, pays2: TPays);
begin 
    WriteLn('Dans quel pays commence votre voyage ?');
    ReadLn(pays1);
    pays1:= TCriteres.paysDepart;
    WriteLn('Quel pays souhaitez-vous absolument traverser durant votre voyage ?');
    ReadLn(pays2);
    pays2:= TCriteres.paysArrivee;
end;
procedure choixPreferences(var prefUser : Array [1..MAXPREF] of TPref);
var i, j : Integer;
begin
  WriteLn('Veuillez choisir vos préférences pour les activités de votre voyage. (selectionner au moins 2 préférences en écrivant leur numéro associé)');
  for i := 1 to Length(TPref) do 
  WriteLn(i: TPref(i)),
end;