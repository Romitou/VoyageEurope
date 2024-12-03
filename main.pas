{ Programme principal du projet }
program main;

uses afficherVoyage, chargerDonnees, choixCriteres, genererVoyage, voyageTypes;

var europe: TEurope;
    criteres: TCriteres;
    voyage: TVoyage;
    quitter: Boolean;

begin
    // Initialisation des donnée, chargement initial des pays et activités (chargerDonnees)
    europe := chargerEurope();

    // Choix des critères de voyage par l'utilisateur (choixCriteres)
    demanderCriteres(criteres, europe);

    repeat
        // Génération du voyage en fonction des critères (genererVoyage)
        voyage := generer(criteres, europe);

        // Affichage du voyage généré (afficherVoyage)
        afficher(voyage, criteres);

        // Demande à l'utilisateur s'il souhaite modifier les critères (choixCriteres)
        // Si l'utilisateur ne souhaite pas modifier les critères, on sort de la boucle (=> quitter = true)
        modifierCriteres(criteres, europe, quitter);
    until quitter;
end.
