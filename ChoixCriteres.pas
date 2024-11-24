unit choixCriteres;

interface
uses voyageTypes, sysutils;

procedure choixPays(var choix: TCriteres; listePays: TEurope);
procedure choixPreferences(var choix: TCriteres);
procedure choixDuree(var choix: TCriteres);
procedure associerPays(nomPays: String; listePays: TEurope; var pays: TPays; var trouve: Boolean);
procedure choixPeriode(var choix: TCriteres);
procedure choixBudget(var choix: TCriteres);
procedure choixExperience(var choix: TCriteres);
procedure demanderCriteres(var choix: TCriteres; listePays: TEurope);


implementation

procedure choixPays(var choix: TCriteres; listePays: TEurope);
// Sélection de pays de départ et de la destination du voyage  
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
// Permet au programme de se référer à la base de données, afin d'associer la réponse de l'utilisateur à un pays si celle-ci est correte
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
var
  prefUser: array of TPref;
  prefLength, i, j, n: Integer;
begin
  setlength(prefUser, 0);
  n := 0;
  prefLength := ord(high(TPref)) + 1;

  writeln('Veuillez choisir vos préférences pour les activités de votre voyage.');
  writeln('Sélectionnez au moins 2 préférences en entrant leurs numéros associés.');
  for i := 1 to prefLength do
    writeln('[', i, '] ', TPref(i - 1));
  writeln('Tapez 0 quand vous aurez terminé votre saisie.');

  repeat
    repeat
      writeln('Veuillez saisir un chiffre associé à une préférence :');
      readln(j);
    until (j >= 0) and (j <= prefLength);

    if (j > 0) then
    begin
      setlength(prefUser, n + 1);
      prefUser[n] := TPref(j - 1);
      n := n + 1;
    end;
  until (j = 0) and (n >= 2);

  setlength(choix.categories, n);
  for i := 0 to n - 1 do
    choix.categories[i] := prefUser[i];
end;

procedure choixDuree(var choix: TCriteres);
var temps: Integer;
begin
  writeln('Quelle durée souhaitez-vous pour votre voyage ?');
  readln(temps);
  choix.duree:=temps;
end;

procedure choixPeriode(var choix: TCriteres);
var indexChoix: Integer;
var i: Integer;
begin
  indexChoix := 0;
  writeln('Le climat du pays principal de votre voyage est le suivant :');
  for i:=0 to length(choix.paysArrivee.climat) - 1 do
    writeln('[', i, '] ', TMois(i), ' : ', choix.paysArrivee.climat[TMois(i)], '°C');
  writeln(' ');
  repeat
    writeln('Au vu de ces températures, durant quel mois de l''année souhaitez-vous effectuer votre voyage ? (Vueillez entrer le numéro du mois)');
    readln(indexChoix);
  until ((indexChoix >= 0) and (indexChoix <= 11));
  choix.periode:=TMois(indexChoix);
end;

procedure choixBudget(var choix: TCriteres);
var coutLimite: Integer;
begin
  writeln('Quel est le coût maximal que souhatez fixer pour votre voyage ?');
  readln(coutLimite);
  choix.budget:=coutLimite;
end;



procedure choixExperience(var choix: TCriteres);
var
  expLength, i, reponse: Integer;
begin
  choix.coeffActivite:=1;
  choix.coeffClimat:=1;
  choix.coeffCout:=0;
  choix.intervalleTemperature:=20;
  choix.transport:=TrainAvion;

  expLength := ord(high(TExperience)) + 1;

  writeln('');
  writeln('Veuillez choisir vos préférences pour votre voyage.');
  writeln('');

  for i := 1 to expLength do
    writeln('[', i, '] ', TExperience(i - 1));
  readln(reponse);

  case  reponse of 
    1 : choix.coeffCout:=2;
    2 : choix.transport:=Train;
    3 : begin
        choix.coeffClimat:=2;
        choix.intervalleTemperature:=15;
        end;
    4 : choix.coeffActivite:=2;
  end;
  writeln('');


end;



procedure demanderCriteres(var choix: TCriteres; listePays: TEurope);
begin
  choixPays(choix, listePays);
  choixPreferences(choix);
  choixDuree(choix);
  choixPeriode(choix);
  choixBudget(choix);
  choixExperience(choix);

end;

end.