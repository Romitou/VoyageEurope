unit choixCriteres;

interface
uses types;

procedure choixPays(var pays1, pays2: TPays);
procedure choixPreferences(var prefUser: Array of TPref);

implementation

procedure choixPays(var pays1, pays2: TPays);
var depart , arrivee : String;
begin 
    writeln('Dans quel pays commence votre voyage ?');
    readln(depart);
    pays1:=depart;
    TCriteres.paysDepart:=pays1;
    writeln('Quel pays souhaitez-vous absolument traverser durant votre voyage ?');
    readln(arrivee);
    pays2:=arrivee;
    TCriteres.paysArrivee:=pays2;
end;

procedure choixPreferences(var prefUser: Array of TPref);
var i, j, n, p: Integer;
begin
  j:=0;
  n:=1;
  writeln('Veuillez choisir vos préférences pour les activités de votre voyage. (selectionner au moins 2 préférences en écrivant leur numéro associé)');
  for i := 1 to length(TPref) do 
    writeln(i: TPref(i));
  writeln('Tapez : 0 , quand vous aurez terminé votre saisie');
  while (n<3 or j<>0) and n<length(TPref) do
  begin
    repeat
      writeln('Veuillez saisir un chiffre associé à une préférénce');
      readln(j);
    until (j>=0 and j<6);
    if j>0 then
    begin
      prefUser[n]:=TPref(j);
      n:=n+1; 
    end;
  end;
  for p:=1 to n-1 do 
    categorie[p]:=prefUser[p];
end;
end.