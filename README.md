# Voyage en Europe

Voyage en Europe est un projet réalisé dans le cadre du projet informatique à l'INSA Rouen Normandie. Celui-ci a pour objectif de proposer une génération d'un trajet au sein des pays européens, en respectant les critères saisis par l'utilisateur. Un itinéraire passant par un pays principal sera alors généré et s'adaptera à la durée du séjour et des contraintes afin de proposer des activités à réaliser dans chacun des pays.

🌱 Des comparaisons et des commentaires sur le rejet de CO2 en fonction du mode de transport sélectionné par l'utilisateur sont affichés. Ces données peuvent permettre de faire prendre conscience des différences économiques et écologiques selon le type de voyage sélectionné.


## Tester localement
Assurez-vous d'avoir installé le compilateur Free Pascal. Nous avons utilisé la version `3.2.2 [2021/05/16]` afin de réaliser ce projet. Une fois installé, compilez le projet grâce à la commande suivante dans le répertoire du projet :

```bash
fpc main.pas
```

Il ne vous reste plus qu'à exécuter le programme et suivre les instructions.

```bash
./main
```


## Tester le programme

Afin d'exécuter les tests, vous devez compiler chacun d'entre eux et les exécuter. Prenons exemples avec `testItineraire` :

```bash
fpc testItineraire.pas
./testItineraire
```

La sortie de ce test unitaire doit être de la forme suivante : `✅ Tous les tests ont été réussis`.

## Utilitaires utilisés

### Pasdoc
https://github.com/pasdoc/pasdoc

Executéer cette commande afin de générer la documentation pour toutes les unités Pascal du projet. Le programme va créer des fichiers HTML disponibles dans le dossier `doc` où vous trouverez un fichier `index.html` qui pourra être ouvert dans le navigateur pour visualiser la documentation générée.
```
bin/pasdoc.exe --implementation-comments=prefer-implementation --output doc/ *.pas
```

### Pascal Format
https://github.com/quadroid/jcf-pascal-format

Exécuter cette commande afin de mettre en forme l'unité Pascal définie en paramètre. Ce programme permet de garantir une cohérence syntaxique et de convention au travers de tous les fichiers du projet selon les règles définies dans le fichier de configuration.

```
bin/pascal-format.exe -config=pascal-format .\main.pas
```
## Auteurs

- LEPREVOST Romain - romain.leprevost@insa-rouen.fr
- LION Alexis - alexis.lion@insa-rouen.fr
- MULLET Simon - simon.mullet@insa-rouen.fr