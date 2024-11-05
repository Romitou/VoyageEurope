unit choixCriteres;

interface
uses types, sysutils;

procedure choixPays(var choix: TCriteres; listePays: TEurope);
procedure choixPreferences(var choix: TCriteres);
procedure choixDuree(var choix: TCriteres);
procedure associerPays(nomPays: String; listePays: TEurope; var pays: TPays; var trouve: Boolean);
procedure choixPeriode(var choix: TCriteres);
procedure demanderCriteres(var choix: TCriteres; listePays: TEurope);


implementation

procedure choixPays(var choix: TCriteres; listePays: TEurope);
var depart, arrivee: String; 
var trouve: Boolean;
begin 
  trouve:=false;
  repeat
    writeln('Dans quel pays commence votre voyage ?');
    readln(depart);
    associerPays(depart, listePays, choix.paysDepart, trouve)
  until (trouve);
  trouve:=false;
  repeat
    writeln('Quel pays souhaitez-vous absolument traverser durant votre voyage ?');
    readln(arrivee);
    associerPays(arrivee, listePays, choix.paysArrivee, trouve)
  until (trouve); 
end;

procedure associerPays(nomPays: String; listePays: TEurope; var pays: TPays; var trouve: Boolean);
var i: Integer;
begin
    trouve := false;
    for i :=1 to (length(listePays)) do
    begin
      if CompareText(nomPays, listePays[i].nom) = 0 then
      begin
        pays := listePays[i];
        trouve := true;
        break;
      end;
    end;
end;

procedure choixPreferences(var choix: TCriteres);
var prefUser: Array of TPref;
var prefLength: Integer;
var i, j, n, p: Integer;
begin
  setlength(prefUser, 0);
  j:=0;
  n:=1;
  prefLength := ord(high(TPref));
  writeln(prefLength); 

  writeln('Veuillez choisir vos préférences pour les activités de votre voyage.');
  writeln('Sélectionner au moins 2 préférences en écrivant leurs numéros associés.');
  for i := 1 to prefLength do
    writeln('[', i, '] ', TPref(i-1));
  writeln('Tapez 0 quand vous aurez terminé votre saisie.');

  while ((n<3) or (j<>0)) and (n<3) do
  begin
    repeat
      writeln('Veuillez saisir un chiffre associé à une préférence.');
      readln(j);
    until ((j>=0) and (j<=prefLength));
    if j>0 then
    begin
      setlength(prefUser, n);
      prefUser[n]:=TPref(j);
      n:=n+1; 
    end;
  end;
  setlength(choix.categorie, n);
  for p:=1 to n-1 do 
    choix.categorie[p]:=prefUser[p];
end;

procedure choixDuree(var choix: TCriteres);
var temps: Integer;
begin
  writeln('Quelle durée souhaitez-vous pour votre voyage ?');
  readln(temps);
  choix.duree:=temps;
end;

procedure choixPeriode(var choix: TCriteres);
// var mois: TMois;
// var i: Integer;
begin
  // writeln('Le climat du pays principal de votre voyage est le suivant :');
  // for i:=1 to length(choix.paysArrivee.climat) do
  //   writeln(TMois(i), ' : ', choix.paysArrivee.climat[TMois(i)], '°C');
  // writeln(' ');
  // writeln('Au vu de ces températures, durant quel mois de l''année souhaitez-vous effectuer votre voyage ?');
  // readln(mois);
  // choix.periode:=mois;
end;

procedure demanderCriteres(var choix: TCriteres; listePays: TEurope);
begin
  choixPays(choix, listePays);
  choixPreferences(choix);
  choixDuree(choix);
  // choixPeriode(choix);
end;

end.