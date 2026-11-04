# Guide pour les assistants IA

## Rôle du dépôt

Ce dépôt accompagne le projet d’installation d’Omarchy sur l’ordinateur personnel à la maison. Il sert à sauvegarder et versionner les configurations et les dotfiles, à documenter les personnalisations et à développer de petits logiciels utilitaires pour cet environnement.

## Règle impérative : autorisation préalable

**Ne jamais rien installer ni rien modifier sur l’ordinateur de l’utilisateur sans son autorisation explicite préalable pour l’intervention concernée.**

- Une demande de modification de fichiers dans ce dépôt autorise uniquement les changements nécessaires à cette demande dans le dépôt. Elle n’autorise pas leur application à l’ordinateur.
- Avant toute installation ou modification de l’environnement de la machine, expliquer précisément l’action proposée, les fichiers ou réglages concernés et ses effets, puis attendre l’autorisation explicite de l’utilisateur.
- Cette règle couvre notamment l’installation, la mise à jour et la suppression de logiciels ou de dépendances, la copie de configurations hors du dépôt, la création de liens symboliques, ainsi que la modification des dotfiles actifs, des services et des paramètres système.
- Ne pas exécuter un script d’installation, de configuration, de maintenance ou un utilitaire susceptible de modifier la machine sans cette autorisation, même si ce script se trouve dans le dépôt ou si son exécution est présentée comme un test.
- Ne jamais considérer une proposition, une absence de réponse ou une autorisation donnée pour une autre intervention comme un accord.

## Manière de travailler

- Préparer le code, les configurations et la documentation dans le dépôt selon la demande de l’utilisateur.
- Garder distinctes la préparation des fichiers dans le dépôt et leur installation ou leur activation sur la machine.
- Avant une intervention autorisée sur des configurations existantes, prévoir une sauvegarde et expliquer comment revenir à l’état précédent.
- Ne pas ajouter de secrets, de mots de passe, de clés privées ou de données personnelles sensibles aux fichiers versionnés.
- Indiquer les vérifications réellement effectuées et distinguer les contrôles des fichiers d’une validation sur une installation Omarchy réelle.
