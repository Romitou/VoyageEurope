{$H+}

{ Fonctions utilitaires utilisées par plusieurs autres unités }
unit utils;

interface
uses sysutils, voyageTypes;

{ Permet de trouver l'index d'un pays dans un tableau de pays
    @param(nom Le nom du pays à chercher)
    @param(europe Le tableau de pays dans lequel chercher)
    @return(L'index du pays dans le tableau, ou -1 si le pays n'a pas été trouvé)
}
function trouverIndexPays(nom: String; europe: TEurope): Integer;

{ Permet de séparer une ligne CSV en un tableau de chaînes de caractères. Exemple : splitLigneCsv('France,Paris,"FR,DE,IT"', ',') renvoie ['France', 'Paris', 'FR,DE,IT']
    @param(ligne La ligne CSV à séparer)
    @param(delimiteur Le délimiteur utilisé pour séparer les valeurs)
    @return(Un tableau de chaînes de caractères)
}
function splitLigneCsv(ligne: string; delimiteur: char): TStringArray;

{ Permet de demander un entier à l'utilisateur, et de répéter la demande tant que l'utilisateur n'entre pas un entier
    @return(L'entier entré par l'utilisateur)
}
function demanderEntier(): Integer;

implementation


function splitLigneCsv(ligne: string; delimiteur: char): TStringArray;
var
  i: integer;
  valeur: string;
  interieurGuillemets: boolean;
  resultat: TStringArray;
begin
  valeur := '';
  interieurGuillemets := false;
  setlength(resultat, 0);

  for i := 1 to length(ligne) - 1 do
  begin
    if ligne[i] = '"' then
      interieurGuillemets := not interieurGuillemets
    else if (ligne[i] = delimiteur) and not interieurGuillemets then
    begin
      setlength(resultat, length(resultat) + 1);
      resultat[high(resultat)] := trim(valeur);
      valeur := '';
    end
    else
      valeur := valeur + ligne[i];
  end;
  setlength(resultat, length(resultat) + 1);
  resultat[high(resultat)] := trim(valeur);

  splitLigneCsv := resultat;
end;

function trouverIndexPays(nom: String; europe: TEurope): Integer;
var
    i: Integer;
begin
    for i := 0 to high(europe) do
        if europe[i].nom = nom then
            Exit(i);
    Exit(-1);
end;

function demanderEntier(): Integer;
var
    input: string;
    value: LongInt;
    success: Boolean;
begin
    repeat
        readln(input);
        success := TryStrToInt(input, value);
        if not success then
            writeln('Veuillez entrer un nombre entier.');
    until success;
    demanderEntier := value;
end;

end.
