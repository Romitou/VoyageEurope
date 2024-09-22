unit choixCriteres;

interface
uses types;

procedure choixPays(var pays1, pays2: TPays);
procedure choixPreferences(var prefUser: Array of TPref);

implementation

procedure choixPays(var pays1, pays2: TPays);
begin 
    writeln('Dans quel pays commence votre voyage ?');
    readln(pays1);
    pays1 := TCriteres.paysDepart;
    writeln('Quel pays souhaitez-vous absolument traverser durant votre voyage ?');
    readln(pays2);
    pays2 := TCriteres.paysArrivee;
end;

procedure choixPreferences(var prefUser: Array of TPref);
var i, j: Integer;
begin
  writeln('Veuillez choisir vos préférences pour les activités de votre voyage. (selectionner au moins 2 préférences en écrivant leur numéro associé)');
  for i := 1 to Length(TPref) do 
    writeln(i: TPref(i));
end;

end.