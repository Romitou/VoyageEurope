# VoyageEurope

### Pasdoc
https://github.com/pasdoc/pasdoc

Executéer cette commande afin de générer la documentation pour toutes les unités Pascal du projet. Le programme va créer des fichiers HTML disponibles dans le dossier `doc` où vous trouverez un fichier `index.html` qui pourra être ouvert dans le navigateur pour visualiser la documentation générée.
```
bin/pasdoc.exe --output doc/ *.pas
```

### Pascal Format
https://github.com/quadroid/jcf-pascal-format

Exécuter cette commande afin de mettre en forme l'unité Pascal définie en paramètre. Ce programme permet de garantir une cohérence syntaxique et de convention au travers de tous les fichiers du projet selon les règles définies dans le fichier de configuration.

⚠️ Faites un commit avant d'exécuter cette commande sur vos fichiers. En cas de problème de formattage, vos fichiers ayant été commit pourront être restaurés. Exécuter cette commande sur des fichiers qui ne sont pas commit expose à des modifs qui peuvent ne pas être réversibles.

```
bin/pascal-format.exe -config=pascal-format .\main.pas
```