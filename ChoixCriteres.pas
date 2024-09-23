unit choixCriteres;

interface
uses types;

procedure choixPays(var depart, arrivee: String; Choix: TCriteres);
procedure choixPreferences(var prefUser: Array of TPref; Choix : TCriteres);
procedure choixDuree(var temps: Integer; Choix: TCriteres);

implementation

procedure choixPays(var depart, arrivee: String; Choix: TCriteres);
begin 
    writeln('Dans quel pays commence votre voyage ?');
    readln(depart);
    Choix.paysDepart.nom:=depart;
    writeln('Quel pays souhaitez-vous absolument traverser durant votre voyage ?');
    readln(arrivee);
    Choix.paysArrivee.nom:=arrivee;
end;

procedure choixPreferences(var prefUser: Array of TPref; Choix : TCriteres);
var i, j, n, p: Integer;
begin
  j:=0;
  n:=1;
  writeln('Veuillez choisir vos préférences pour les activités de votre voyage. (selectionner au moins 2 préférences en écrivant leur numéro associé)');
  for i := 1 to (ord(high(TPref))) do
    write(i, TPref(i-1));
  writeln('Tapez : 0 , quand vous aurez terminé votre saisie');
  while ((n<3) or (j<>0)) and (n<(ord(high(TPref)))) do
  begin
    repeat
      writeln('Veuillez saisir un chiffre associé à une préférénce');
      readln(j);
    until ((j>=0) and (j<6));
    if j>0 then
    begin
      prefUser[n]:=TPref(j);
      n:=n+1; 
    end;
  end;
  for p:=1 to n-1 do 
    Choix.categorie[p]:=prefUser[p];
end;

procedure choixDuree(var temps: Integer; Choix: TCriteres);
begin
  writeln('Quelle durée souhaitez-vous pour votre voyage ?');
  readln(temps);
  Choix.duree:=temps;
end;
end.