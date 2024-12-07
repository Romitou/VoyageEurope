{ Unité contenant les constantes du programme }
unit constantes;

interface

const
    // Si vrai, des messages de debug seront affichés dans la console
    MODE_DEBUG = false;

    // Coefficient maximum pour la pondération des préférences
    COEFF_PREF_MAX = 1.5;
    // Coefficient minimum pour la pondération des préférences
    COEFF_PREF_MIN = 1;
    // Utilisé dans la parabole de calcul du score en fonction du coût
    COUT_MAX = 50;
    // Nombre d'activités par jour
    NB_ACT_PAR_JOUR = 3;

    // Coefficient de division du score des pays visités
    DIVISION_SCORE = 2;

    // Nombre d'heures par jour dédiées aux activités
    HEURES_PAR_JOUR = 10;

    // Coefficient initial pour les préférences
    COEFF_ACT_INITIAL = 1;
    // Coefficient initial pour le climat
    COEFF_CLIMAT_INITIAL = 1;
    // Intervalle de température initial
    INTERVALLE_TEMP_INITIAL = 20;
    // Coefficient initial pour le coût
    COEFF_COUT_INITIAL = 0;

    // Coefficient final pour les préférences
    COEFF_ACT_FINAL = 2;
    // Coefficient final pour le climat
    COEFF_CLIMAT_FINAL = 2;
    // Intervalle de température final
    INTERVALLE_TEMP_FINAL = 15;
    // Coefficient final pour le coût
    COEFF_COUT_FINAL = 1;

    // Emission de CO2 par km en train 
    EMISSION_CO2_TRAIN = 0.003;
    // Emission de CO2 par km en avion
    EMISSION_CO2_AVION = 0.152;

    // Coût d'une nuit d'hôtel dans un hôtel normal
    HOTEL_NORMAL = 70;
    // Coût d'une nuit d'hôtel dans un hôtel économique
    HOTEL_BUDGET = 30;
implementation
end.
