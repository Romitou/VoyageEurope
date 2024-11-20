## A FAIRE ?
- Ajout de la possibilité de déplacement en avion
- Faire un détail + précis du coût (introduire une structure)
- voir pour demander à l'utilisateur s'il souhaite renseigner un profil "type" de voyageur pour pas avoir à lire TOUTES les préférences et que l'on propose des packs tout prêts de préférences. laisser la possibilité à l'utilisateur de modifier s'il le souhaite et de personnaliser les préférences pré-renseignées par exemple
- dans choixCritères, il faut vérifier que l'input de l'utilisateur corresponde bien à une préférence. si non alors afficher une saisie incorrecte
- ça serait cool de passer toutes les procédures et fonctions qui ont un paramètre "trouve" en utilisant les pointeurs, ça rendrait le cool clean et c'est pas sorcier (EXEMPLE DANS testItineraire.pas pour illustration)


## IDÉES
- Ajout choix du budget ? Voir comment on fait, est-ce qu'on propose comme choix : "- cher possible" / "peu importe" seulement ? on pourrait aussi générer 2 voyages avec chacun des critères différents de budget pour proposer les 2
- Ajout des hôtels ? 2/3 hôtels par capitale, 1 pas cher et 1 cher ?

## NOTES
- important à mettre dans le rapport : le renommage de types en voyageTypes => conflit avec les types de pascal ce qui empêchait l'import de certaines librairies
- il est important de respecter le camelCase dans le nommage des fichiers et unités afin que tout le monde puisse le compiler sans problème et avoir une convention. si jamais ça compile pas de votre côté il faut supprimer tous les fichiers compilés type .o .ppu
- à réfléchir pour bientôt : voir pour intégrer une librairie d'image afin de générer une sortie plus visuelle de l'itinéraire proposé et des activités
