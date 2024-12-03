{ Calcul d'itinéraire entre deux pays en utilisant l'algorithme de Dijkstra (voir l'unité dijkstra) }
unit calculItineraire;

interface
uses dijkstra, score, sysutils, utils, voyageTypes;

function convertirEuropeAdjacence(europe: TEurope; modeTransport: TMode): TAdjacenceListe;
function calculerItineraire(paysValables: TEurope; paysDepart, paysArrivee: TPays; modeTransport: TMode): TItineraireResult;

implementation

{ Permet de calculer un itinéraire entre deux pays avec l'algorithme de Dijkstra
    @param(paysValables La liste des pays possibles pour le trajet)
    @param(paysDepart Le pays de départ)
    @param(paysArrivee Le pays de destination)
    @param(modeTransport Le mode de transport sélectionné)
    @return(Le résultat de la génération du voyage incluant l'itinéraire)
}
function calculerItineraire(paysValables: TEurope; paysDepart, paysArrivee: TPays; modeTransport: TMode): TItineraireResult;
var adjacence: TAdjacenceListe;
    chemin: TNoeudList;
    distance: TDistance;
    i: Integer;
    noeudDepart, noeudFin: Integer;
    cheminPays: TEurope;
    resultat: TItineraireResult;
begin
    setlength(resultat.itineraire, 0);

    // On initialise le résultat comme comportant une erreur
    // On annulera cet état à la fin du programme
    resultat.erreur := true;

    // On convertit la liste des pays valables en une liste d'adjacence de Dijkstra
    // Vérification que l'adjacence comporte au moins 2 noeuds
    adjacence := convertirEuropeAdjacence(paysValables, modeTransport);
    if length(adjacence) <= 2 then
    begin
        resultat.message := 'Pas assez d''adjacences n''ont été générées.';
        exit(resultat);
    end;

    // Dijkstra fonctionnant avec des noeuds représentés par des entiers, on attribue à chaque pays un entier caractéristique
    // Cet entier correspond à l'index du pays dans la liste des pays valables en entrée
    noeudDepart := trouverIndexPays(paysDepart.nom, paysValables);
    if noeudDepart = -1 then
    begin
        resultat.message := string('Impossible de trouver le pays de départ "') + paysDepart.nom + string('".');
        exit(resultat);
    end;

    // On réalise la même méthode pour le noeud de fin
    noeudFin := trouverIndexPays(paysArrivee.nom, paysValables);
    if noeudFin = -1 then
    begin
        resultat.message := string('Impossible de trouver le pays d''arrivée "') + paysArrivee.nom + string('".');
        exit(resultat);
    end;

    // Utilisation de la procédure shortestPath provenant de Dijkstra avec les différents paramètres déterminés :
    // adjacence, noeudFin et noeudDepart
    // La procédure modifiera les valeurs de chemin et distance que nous utiliserons par la suite
    shortestPath(adjacence, noeudFin, noeudDepart, chemin, distance);

    // Dijkstra peut renvoyer une distance négative en cas de chemin impossible
    if distance <= 0 then
    begin
        resultat.message := 'Dijkstra a renvoyé une distance invalide.';
        exit(resultat);
    end;

    // Dijkstra peut indiquer que la distance est infinie (aucun chemin possible) ou un chemin vide
    if (distance = INFINITY) or (length(chemin) = 0) then
    begin
        resultat.message := string('Aucun chemin n''a été trouvé entre "') + paysDepart.nom + string('" et "') + paysArrivee.nom + string('".');
        exit(resultat);
    end;

    // On a un chemin composé des identifiants entiers de chaque pays. On les convertit en pays "réels" via leur index 
    setlength(cheminPays, length(chemin));
    for i := 0 to length(chemin) - 1 do
        cheminPays[i] := paysValables[chemin[i]];

    // On a trouvé un chemin valide, on peut donc renvoyer le résultat sans erreur et avec l'itinéraire
    resultat.erreur := false;
    resultat.itineraire := cheminPays;

    calculerItineraire := resultat;
end;

{ Permet de convertir une liste de pays en une liste d'adjacence pour l'algorithme de Dijkstra.
  Deux modes de transport sont possibles : Train seul ou Train et Avion. Dans le second cas, les pays
  reliés par un vol direct sont également reliés directement.
    @param(europe La liste des pays à convertir)
    @param(modeTransport Le mode de transport sélectionné)
    @return(La liste d'adjacence générée)
}
function convertirEuropeAdjacence(europe: TEurope; modeTransport: TMode): TAdjacenceListe;
var
    listeAdjacence: TAdjacenceListe;
    paysVoisins: TStringArray;
    i, j, n, voisinIndex: Integer;
begin
    // On initialise la liste d'adjacence avec la taille de la liste des pays
    setlength(listeAdjacence, length(europe));

    for i := 0 to length(europe) - 1 do
    begin
        setlength(listeAdjacence[i], 0);

        // Dans les deux cas (Train seul ou Train et Avion), on ajoute les pays voisins par train
        paysVoisins := europe[i].nomFrontieres;

        // En cas de Train et Avion, on ajoute également les pays voisins par avion
        if modeTransport = TrainEtAvion then
            for j := 0 to length(europe[i].nomAvions) - 1 do
            begin
                for n := 0 to length(europe[i].nomFrontieres) - 1 do
                    if europe[i].nomAvions[j] = europe[i].nomFrontieres[n] then
                        continue;
                setlength(paysVoisins, length(paysVoisins) + 1);
                paysVoisins[length(paysVoisins) - 1] := europe[i].nomAvions[j];
            end;

        // On ajoute les voisins à la liste d'adjacence
        // Pour rappel, on identifie les voisins par leur index dans la liste des pays en entrée
        for j := 0 to length(paysVoisins) - 1 do
        begin
            // Récupération de l'index du voisin
            voisinIndex := trouverIndexPays(paysVoisins[j], europe);
            if voisinIndex <> -1 then
            begin
                n := length(listeAdjacence[i]);
                SetLength(listeAdjacence[i], n + 1);
                listeAdjacence[i][n].voisin := voisinIndex;

                // Le poids du chemin est détaillé dans l'unité score.pas. Cette valeur étant comprise entre 0 et 1, on la convertit en distance
                // On utilise une distance de 100 - score pour obtenir une distance plus grande pour les scores plus faibles
                listeAdjacence[i][n].distance := 100 - round(100 * poidsChemin(europe[i], europe[voisinIndex]));
            end;
        end;
    end;
    convertirEuropeAdjacence := listeAdjacence;
end;

end.
