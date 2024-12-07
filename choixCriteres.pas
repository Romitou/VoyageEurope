{ Interface IHM permettant à l'utilisateur de renseigner ses critères de voyage }
unit choixCriteres;

interface
uses constantes, genererVoyage, sysutils, utils, voyageTypes;

procedure demanderCriteres(var choix: TCriteres; listePays: TEurope);
procedure modifierCriteres(var choix: TCriteres; europe: TEurope; var quitter: Boolean);

implementation

{ Permet au programme de se référer à la base de données, afin d'associer la réponse de l'utilisateur
à un pays si celle-ci correspond au nom d'un pays figurant dans la base de données.
    @param(nomPays Le nom du pays renseigné par l'utilisateur)
    @param(listePays La liste des pays de la base de données)
    @param(pays Le pays associé à la réponse de l'utilisateur)
    @param(trouve Un booléen indiquant si le pays a été trouvé dans la base de données)
}
procedure associerPays(nomPays: String; listePays: TEurope; var pays: TPays; var trouve: Boolean);
var i: Integer;
begin
    trouve := false;
    for i := 1 to (length(listePays)) do
        if CompareText(nomPays, listePays[i].nom) = 0 then // CompareText permet de comparer sans tenir compte de la casse
        begin
            pays := listePays[i];
            trouve := true;
            break;
        end;
end;

{ Sélection de pays de départ et de la destination du voyage
    @param(choix Les critères de recherche du voyage)
    @param(listePays La liste des pays de la base de données)
}
procedure choixPays(var choix: TCriteres; listePays: TEurope);
var depart, arrivee: String;
    trouve: Boolean;
begin
    trouve := false;
    repeat
        writeln('🌍 Dans quel pays commence votre voyage ?');
        readln(depart);
        associerPays(depart, listePays, choix.paysDepart, trouve)
    until (trouve);
    trouve := false;
    repeat
        writeln('🏁 À quelle destination voulez-vous voyager ?');
        readln(arrivee);
        associerPays(arrivee, listePays, choix.paysArrivee, trouve)
    until (trouve) and (arrivee <> depart);
end;

{ Permet à l'utilisateur de sélectionner manuellement ses préférences pour son voyage (sélection personnalisée).
    @param(choix Les critères de recherche du voyage)
}
procedure choixPreferencesIndividuelles(var choix: TCriteres);
var prefUser: array of TPref;
    prefLength, i, n, indexChoix: Integer;
begin
    setlength(prefUser, 0);
    n := 0;
    prefLength := ord(high(TPref)) + 1;

    writeln('🎯 Veuillez choisir vos préférences pour les activités de votre voyage.');
    writeln('Sélectionnez au moins 2 préférences en entrant leurs numéros associés.');
    writeln('Pensez à sélectionner vos préférences par ordre de priorité.');
    for i := 1 to prefLength do
        writeln('➡️  [', i, '] ', TPref(i - 1));
    writeln('👉 Entrez 0 afin de terminer votre saisie.');

    repeat
        repeat
            writeln('🎯 Veuillez saisir un numéro associé à une préférence :');
            indexChoix := demanderEntier();
        until (indexChoix >= 0) and (indexChoix <= prefLength);

        if (indexChoix > 0) then
        begin
            setlength(prefUser, n + 1);
            prefUser[n] := TPref(indexChoix - 1);
            n := n + 1;
        end;
    until (indexChoix = 0) and (n >= 2);

    setlength(choix.categories, n);
    for i := 0 to n - 1 do
        choix.categories[i] := prefUser[i];
end;

{ L'utilisateur renseigne ici la durée de son voyage.
    @param(choix Les critères de recherche du voyage)
    @param(listePays La liste des pays de la base de données)
}
procedure choixDuree(var choix: TCriteres; listePays: TEurope);
var dureeMinimale: Integer;
begin
    dureeMinimale := calculDureeMinimale(choix, listePays);
    if dureeMinimale = -1 then
    begin
        writeln('⚠️  Attention : aucun itinéraire n''a été trouvé pour les critères renseignés.');
        if choix.modeTransport = TrainSeul then
            writeln('> Si vous voyagez en train, essayez de sélectionner un transport en avion.');
        writeln();
    end;
    repeat
        writeln('🛏️ Combien de jours souhaitez-vous voyager (au maximum) ?');
        writeln('👉 La durée minimale de votre voyage est de ', dureeMinimale, ' jours.');
        choix.duree := demanderEntier();
    until (choix.duree >= dureeMinimale);
end;

{ L'utilisateur renseigne ici la température qu'il souhaiterait avoir lors de son voyage.
    @param(choix Les critères de recherche du voyage)
}
procedure choixClimat(var choix: TCriteres);
begin
    writeln('🌡️  Quelle serait votre température ambiante idéale (en °C) ?');
    choix.climat := demanderEntier();
end;

{ En affichant les températures moyennes de chaque mois de l'année dans le pays de destination rensignée précédemment,
cette procédure permet à l'utilisateur d'indiquer le mois de l'année où il souhaite effectuer son voyage. 
    @param(choix Les critères de recherche du voyage)
}
procedure choixPeriode(var choix: TCriteres);
var i, indexChoix: LongInt;
begin
    writeln('🌱 Le climat du pays principal de votre voyage est le suivant :');
    for i := 0 to length(choix.paysArrivee.climat) - 1 do
        writeln('[', i, '] ', TMois(i), ' : ', choix.paysArrivee.climat[TMois(i)], '°C');
    writeln(' ');
    repeat
        writeln('📅 Saisissez le numéro du mois correspondant à votre période de voyage.');
        indexChoix := demanderEntier();
    until (0 <= indexChoix) and (indexChoix < 12);
    choix.periode := TMois(indexChoix);
end;

{ L'utilisateur renseigne ici son budget pour le voyage. 
    @param(choix Les critères de recherche du voyage)
}
procedure choixBudget(var choix: TCriteres);
begin
    writeln('💲 Quel est votre budget pour ce voyage ?');
    choix.budget := demanderEntier();
end;

{ Cette procédure permet à l'utilisateur d'influencer le calcul des scores qui aura lieu plus tard lors de la génération du voyage.
En effet, en choisissant une des propositions affichées ici, il peut alors faire savoir au programme l'importance qu'il accorde
aux activités, au coût, à la température, ou bien à l'aspect écologique de son voyage
    @param(choix Les critères de recherche du voyage)
}
procedure choixExperience(var choix: TCriteres);
var expLength, i, indexChoix: Integer;
begin
    choix.coeffActivite := COEFF_ACT_INITIAL;
    choix.coeffClimat := COEFF_CLIMAT_INITIAL;
    choix.coeffCout := COEFF_COUT_INITIAL;
    choix.intervalleTemperature := INTERVALLE_TEMP_INITIAL;
    choix.modeTransport := TrainEtAvion;

    expLength := ord(high(TExperience)) + 1;

    writeln('');
    writeln('✨ Voici quelques propositions caractéristiques d''un voyage.');
    writeln('');
    for i := 1 to expLength do
        writeln('[', i, '] ', TExperience(i - 1));
    writeln('');
    repeat
        writeln('✨ Veuillez choisir votre proposition préférée.');
        indexChoix := demanderEntier();
    until (0 < indexChoix) and (indexChoix <= expLength);

    case indexChoix of
    1: choix.coeffCout := COEFF_COUT_FINAL;
    2: choix.modeTransport := TrainSeul;
    3: begin
        choix.coeffClimat := COEFF_CLIMAT_FINAL;
        choix.intervalleTemperature := INTERVALLE_TEMP_FINAL;
    end;
    4: choix.coeffActivite := COEFF_ACT_FINAL;
    end;
    writeln('');

end;

{ Définitions des menus caractéristiques du prgramme; un menu étant en quelque sorte un package
contenant des préférences pré-sélectionnées et correspondant chacun à un profil de voyages.
    @return(Le tableau de menus)
}
function chargerMenus(): TMenus;
var menus: TMenus;
begin
    setlength(menus, 5);

    menus[0].nom := 'Menu Nature et Photographie';
    setlength(menus[0].preferences, 3);
    menus[0].preferences := [Photographie, Relaxation, Nature];
    menus[0].description := 'Explorez les merveilles de la nature avec des aventures passionnantes.';

    menus[1].nom := 'Menu Aventure Culturelle';
    setlength(menus[1].preferences, 3);
    menus[1].preferences := [Culture, Histoire, Art];
    menus[1].description := 'Plongez dans l''histoire et le patrimoine culturel unique.';

    menus[2].nom := 'Menu En Famille';
    setlength(menus[2].preferences, 4);
    menus[2].preferences := [Gastronomie, Sport, Authentique, Famille];
    menus[2].description := 'Des activités pour petits et grands à partager en famille.';

    menus[3].nom := 'Menu Vie Nocturne';
    setlength(menus[3].preferences, 3);
    menus[3].preferences := [VieNocturne, FestivalsEtEvenements, Luxe];
    menus[3].description := 'Vivez des soirées inoubliables et profitez d''expériences exclusives';

    menus[4].nom := 'Menu Culture et Relaxation Spirituelle';
    setlength(menus[4].preferences, 3);
    menus[4].preferences := [Culture, ReligieuxEtSpirituel, Relaxation];
    menus[4].description := 'Alliez découvertes culturelles et moments de paix intérieure';

    chargerMenus := menus;
end;

{ Cette procédure permet à l'utilisateur de sélectionner directement un profil de voyages susceptible de correspondre à ses attentes.
Ce dernier aura le choix entre cette procédure et la procédure choixPreferences, étant ainsi libre de personnaliser ses attentes
ou bien de choisir un profil pré-programmé.
    @param(choix Les critères de recherche du voyage)
}
procedure choixMenu(var choix: TCriteres);
var i, j: Integer;
    indexChoix: LongInt;
    menus: TMenus;
begin
    menus := chargerMenus();

    writeln('');
    writeln('📋 Veuillez choisir votre menu pour votre voyage.');
    writeln('');

    {Affichage des menus.}
    for i := 1 to length(menus) do
    begin
        writeln(i, ') ', menus[i - 1].nom);
        writeln('Préférences associées :');

        for j := 0 to length(menus[i - 1].preferences) - 1 do
            writeln('-> ', menus[i - 1].preferences[j]);

        writeln('Desciption : ', menus[i - 1].description);
        writeln('');
    end;

    repeat
        writeln('📋 Saisissez votre choix en indiquant le numéro du menu.');
        indexChoix := demanderEntier();
    until (0 < indexChoix) and (indexChoix < (length(menus) + 1));

    {Affectation des préférences du menu aux critères de l'utilisateur.}
    setlength(choix.categories, length(menus[indexChoix - 1].preferences));
    choix.categories := menus[indexChoix - 1].preferences;

end;

{ L'utilisateur renseigne ici le nombre de personnes participant au voyage.
    @param(choix Les critères de recherche du voyage)
}
procedure choixNbVoyageurs(var choix: TCriteres);
begin
    writeln('👥 Combien de personnes feront parties du voyage ?');
    choix.nbVoyageurs := demanderEntier();
end;

{ L'utilisateur renseigne ici ses préférences pour le voyage, en choisissant entre les menus prédéfinis ou bien en les personnalisant.
    @param(choix Les critères de recherche du voyage)
}
procedure choixPreferences(var choix: TCriteres);
var indexChoix: Integer;
begin
    writeln('📋 [1] Des menus prédéfinis existent afin de générer rapidement un voyage correspondant à certains profils.');
    writeln('✏️  [2] Vous pouvez également choisir vos préférences manuellement.');
    writeln();

    repeat
        writeln('🤔 Saisissez votre choix en indiquant le numéro correspondant.');
        indexChoix := demanderEntier();
    until (indexChoix = 1) or (indexChoix = 2);
    if indexChoix = 1 then
        choixMenu(choix)
    else
        choixPreferencesIndividuelles(choix);
end;

{ Permet à l'utilisateur de modifier ses critères de voyage.
    @param(choix Les critères de recherche du voyage)
    @param(europe La liste des pays de la base de données)
    @param(quitter Un booléen indiquant si l'utilisateur souhaite quitter le programme)
}
procedure modifierCriteres(var choix: TCriteres; europe: TEurope; var quitter: Boolean);
var reponse: String;
    p, n: LongInt;
begin

    //cette boucle permet de demander autant de fois que veut l'utilisateur de modifier ses critères
    repeat

        repeat
            writeln('Voulez-vous modifier l''un / un autre de vos critères ? oui(1) / non(2)');
            readln(reponse);
            TryStrToInt(reponse, p);
        until (TryStrToInt(reponse, p) = True);

        if p = 1 then
        begin
            repeat
                writeln('Lequel voulez-vous modifier ?');
                writeln('');
                writeln('[1] Préférences');
                writeln('[2] Durée');
                writeln('[3] Climat');
                writeln('[4] Période');
                writeln('[5] Pays de départ et/ou d''arrivée');
                writeln('[6] Budget');
                writeln('[7] Expérience');
                writeln('[8] Nombre de voyageurs');
                writeln('[9] Tous');
                writeln('');
                readln(reponse);
                TryStrToInt(reponse, n);
            until (TryStrToInt(reponse, n) = True);

            case n of
            1: choixPreferences(choix);
            2: choixDuree(choix, europe);
            3: choixClimat(choix);
            4: choixPeriode(choix);
            5: choixPays(choix, europe);
            6: choixBudget(choix);
            7: choixExperience(choix);
            8: choixNbVoyageurs(choix);
            9: demanderCriteres(choix, europe);
            end;
        end;

    until p = 2;

    repeat
        writeln('Voulez-vous générer de nouveau le voyage ? oui(1) / non(2)');
        readln(reponse);
        TryStrToInt(reponse, p);
    until (TryStrToInt(reponse, p) = True);

    if p = 1 then
        quitter := False
    else
        quitter := True;

end;


{ Procédure globale regroupant l'ensemble des sous-procédures décrites précédemment.
    @param(choix Les critères de recherche du voyage)
    @param(listePays La liste des pays de la base de données)
}
procedure demanderCriteres(var choix: TCriteres; listePays: TEurope);
begin
    choixPays(choix, listePays);
    choixPreferences(choix);
    choixClimat(choix);
    choixPeriode(choix);
    choixBudget(choix);
    choixExperience(choix);
    choixDuree(choix, listePays);
    choixNbVoyageurs(choix);
end;

end.
