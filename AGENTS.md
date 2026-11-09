# Guide pour les assistants IA

## Rôle du dépôt

Ce dépôt est consacré aux dotfiles et aux scripts de personnalisation de l’ordinateur personnel sous Omarchy à la maison. Il sert à sauvegarder et versionner les configurations, à préparer les scripts qui reproduisent les réglages et à documenter leur utilisation et leur restauration.

Limiter les changements à ce périmètre. Le développement d’applications ou de logiciels indépendants demande une nouvelle demande explicite de l’utilisateur.

## Organisation

- `dotfiles/` : configurations du bureau, des applications et des plugins ; consulter aussi `dotfiles/README.md` et les éventuels guides locaux.
- `scripts/` : scripts de configuration et de personnalisation.
- `docs/` : documentation en français, utilisation des scripts, sauvegardes et retour arrière.
- `tests/` : contrôles isolés des scripts et des fichiers générés.

## Règle impérative : autorisation préalable

**Ne jamais rien installer ni rien modifier sur l’ordinateur de l’utilisateur sans son autorisation explicite préalable pour l’intervention concernée.**

- Une demande de modification de fichiers dans ce dépôt autorise uniquement les changements nécessaires à cette demande dans le dépôt. Elle n’autorise pas leur application à l’ordinateur.
- Avant toute installation ou modification de l’environnement de la machine, expliquer précisément l’action proposée, les fichiers ou réglages concernés et ses effets, puis attendre l’autorisation explicite de l’utilisateur.
- Cette règle couvre notamment l’installation, la mise à jour et la suppression de logiciels ou de dépendances, la copie de configurations hors du dépôt, la création de liens symboliques, ainsi que la modification des dotfiles actifs, des services et des paramètres système.
- Ne pas exécuter un script d’installation, de configuration, de maintenance ou un utilitaire susceptible de modifier la machine sans cette autorisation, même si ce script se trouve dans le dépôt ou si son exécution est présentée comme un test.
- Ne jamais considérer une proposition, une absence de réponse ou une autorisation donnée pour une autre intervention comme un accord.

## Manière de travailler

- Préparer les dotfiles, les scripts et la documentation dans le dépôt selon la demande de l’utilisateur.
- Préserver les personnalisations existantes et les modifications en cours qui ne concernent pas la demande.
- Garder distinctes la préparation des fichiers dans le dépôt et leur installation ou leur activation sur la machine.
- Avant une intervention autorisée sur des configurations existantes, prévoir une sauvegarde et expliquer comment revenir à l’état précédent.
- Pour les scripts qui modifient la machine, prévoir un aperçu des effets et une confirmation explicite avant application. Documenter les paramètres à remplir, les fichiers ou réglages concernés et la restauration.
- Vérifier les chemins, les liens symboliques et les identifiants de périphériques avant de proposer une copie ou une activation ; ne pas supposer qu’ils conviennent à une autre installation.
- Conserver les licences et la provenance des plugins tiers lors de leur sauvegarde ou modification.
- Ne pas ajouter de secrets, de mots de passe, de clés privées ou de données personnelles sensibles aux fichiers versionnés.
- Privilégier les contrôles de syntaxe et les tests isolés sans effet sur la machine. Un test ne doit pas installer de dépendance, monter un disque, changer des droits ou activer un service sans autorisation préalable pour cette intervention.
- Indiquer les vérifications réellement effectuées et distinguer les contrôles des fichiers d’une validation sur une installation Omarchy réelle.
