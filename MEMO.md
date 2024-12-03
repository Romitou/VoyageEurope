## A FAIRE ?
- Critères à demander :
    - pays départ (OK)
    - pays arrivée (OK)
    - choix des critères (OK)
    - période de l'année, le mois (à adapter)
    - budget (OK)
    - température (manquant)
    - saisie coeffs pour les scores (manquant)
    - nb de voyageurs (manquant)
- Faire un détail + précis du coût (introduire une structure)
- voir pour demander à l'utilisateur s'il souhaite renseigner un profil "type" de voyageur pour pas avoir à lire TOUTES les préférences et que l'on propose des packs tout prêts de préférences. laisser la possibilité à l'utilisateur de modifier s'il le souhaite et de personnaliser les préférences pré-renseignées par exemple
- dans choixCritères, il faut vérifier que l'input de l'utilisateur corresponde bien à une préférence. si non alors afficher une saisie incorrecte
-aussi renforcer choixCritères qui n'accepte pas si on rentre une donnée d'un autre type. Comment faire ? Utiliser une autre variable et vérifier qu'elle est du bon type ? Possible de faire ca ?

## IDÉES
- Ajout choix du budget ? Voir comment on fait, est-ce qu'on propose comme choix : "- cher possible" / "peu importe" seulement ? on pourrait aussi générer 2 voyages avec chacun des critères différents de budget pour proposer les 2
- Ajout des hôtels ? 2/3 hôtels par capitale, 1 pas cher et 1 cher ?
-Ajout de priorité dans les préférences? Ou alors on attribue un coeff décroissant aux préférences au fur et à mesure que l'utilisateur les renseigne. 

## NOTES
- important à mettre dans le rapport : le renommage de types en voyageTypes => conflit avec les types de pascal ce qui empêchait l'import de certaines librairies
- il est important de respecter le camelCase dans le nommage des fichiers et unités afin que tout le monde puisse le compiler sans problème et avoir une convention. si jamais ça compile pas de votre côté il faut supprimer tous les fichiers compilés type .o .ppu
- à réfléchir pour bientôt : voir pour intégrer une librairie d'image afin de générer une sortie plus visuelle de l'itinéraire proposé et des activités (HTML ?)
- problème avec pascal de longueur des strings

-au moment de rentrer les poids des chemins dans calculItineraire, le fait d'arondir peut être une cause de manque de prcision dans certains cas. Parce que dans les faits, on voit souvent des pays avec des scores proches.
-impact de mettre les poids sur une référence de 1000 ? ferait resortir les différences ?
-faire en sorte que passer par plus de pays ait moins d'impact? Car il est possible de contourner naturellement un pays avec un mauvais score pour passer par 2 pays avec de bons scores. Mais passer par trois pays est quasis impossible.
-demander à l'utilisateur de régler, au travers de questions, la valeur des coefficients utilisés, ou au moins quelques uns. Il y a coeffClimat, coeffAct pour la moyenne pondérée des scores des pays, fourchette (température) et coeffDiv (pour la suppression des pays) ou alors dire parmi ces possibilités, laquelle vous importe le plus ? 1-Respect du climat 2-respect des préférences 3-ne pas passer par les mêmes pays
- organisation du code / dépendances circulaires

## FAIT
- Ajout de la possibilité de déplacement en avion