# Modernisation macOS — version de développement

Objectif : Sonoma 14 et toutes les versions stables suivantes sur Apple Silicon.
La cible minimale reste 14.0. Ce document ne certifie pas encore la compatibilité
avec chacune de ces versions. Aucun nouveau moteur Wine n'est inclus.

## Modifications

- Manifeste Swift 6 explicite, cohérent avec le langage du projet Xcode.
- Dépendance publique téléchargée par HTTPS, sans clé SSH GitHub.
- Détection Rosetta par exécution Intel, sans chemin privé de macOS ni cache périmé.
- Vérification de Rosetta après installation ; l'assistant ne continue plus en cas d'échec.
- Attente asynchrone et modifications de l'interface sur le MainActor dans l'étape Rosetta.
- Tests et compilation Release automatisables, archive ZIP non signée.

## Compilation

Installer Xcode complet (Swift 6 ou ultérieur), sélectionner son Developer Directory
et installer SwiftLint (`brew install swiftlint`). Depuis la racine :

```sh
scripts/build-macos.sh
```

Résultat attendu : `build/artifacts/Whisky-unsigned.zip`.
Cette archive de développement n'est ni signée pour distribution ni notariée.
La signature Developer ID et la notarisation sont nécessaires avant distribution
publique. Le script ne publie rien et n'installe rien dans Applications.

Le workflow utilise macOS 15 et 26, avec une cible de déploiement 14.0. Les runners
GitHub Sonoma ont été retirés : Sonoma doit être testé sur un Mac ou une VM locale.
Un SDK récent et une cible 14.0 ne prouvent pas à eux seuls le fonctionnement sur
Sonoma ni sur une version plus récente que le runner.

## Vérifications réalisées

Sur Apple Silicon, macOS 15.7.3, Swift 6.1.2 : compilation de WhiskyKit et quatre
tests de détection réussis (succès, code d'échec, exécutable absent, absence de cache).
Ces tests utilisent des processus de contrôle et ne simulent pas l'installation de Rosetta.
L'application SwiftUI n'a pas été compilée ici : Xcode complet absent.
Le workflow a été ajouté mais n'a pas été exécuté sur GitHub.

## Conditions avant une version stable

Sur Sonoma, Sequoia, Tahoe et la dernière version stable disponible :

1. Compiler l'application avec Xcode et vérifier son ouverture.
2. Tester l'assistant avec Rosetta présente, absente, puis avec installation refusée.
3. Créer une bouteille de test, ouvrir winecfg, lancer un exécutable Windows.
4. Tester les jeux visés, D3DMetal et DXVK séparément.
5. Vérifier les bouteilles existantes à partir de copies de sauvegarde.
6. Signer, notarier et vérifier l'archive de distribution.

WhiskyWine reste celui de l'amont, dont la maintenance est arrêtée. Les corrections
ci-dessus ne remplacent pas la modernisation de Wine, DXVK ou D3DMetal. Un échec
Steam/jeu doit être reproduit avec ses logs avant de choisir et intégrer un moteur
plus récent compatible avec les réglages et le format de bouteilles de Whisky.

Références :
- https://docs.getwhisky.app/maintenance-notice
- https://github.com/actions/runner-images
