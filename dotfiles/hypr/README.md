# Écrans et espaces de travail sans hyprmoncfg

## Configuration préparée

`hyprland.lua` charge les fichiers personnels suivants :

- `monitors.lua` : Dell à gauche (`-1920x0`), ASUS à droite (`0x0`),
  chacun en 1920 × 1080 à 60 Hz, échelle 1. Les réglages VRR et de
  luminance du fichier généré sont conservés, ainsi que `GDK_SCALE=1`.
- `workspaces.lua` : espaces 1 à 5 sur le Dell et 6 à 10 sur l’ASUS.
  Les espaces 1 et 6 sont ceux par défaut de leurs écrans respectifs.
  Les espaces 1 à 6 sont persistants, comme dans la sauvegarde initiale.
  Les raccourcis globaux du fichier généré sont conservés pour empêcher
  Omarchy de réaffecter les numéros par écran.

`hyprmoncfg-monitors.lua` reste une archive et n’est plus chargé.
Les plugins tiers restent sauvegardés dans le dépôt.
Le fichier `dotfiles/omarchy/shell.json` décrit encore l’ancienne barre :
il ne faut pas le recopier tel quel pendant cette migration.

## Application à préparer sur Omarchy

**Aucune étape ci-dessous n’a été exécutée. Une autorisation explicite est
nécessaire avant toute intervention sur la machine, conformément à `AGENTS.md`.**

1. Comparer la configuration active avec cette sauvegarde. Vérifier la version
   Lua d’Hyprland/Omarchy, les descriptions des écrans et la disposition voulue.
2. Créer une sauvegarde datée de `~/.config/hypr`, de
   `~/.config/omarchy/shell.json` et de `~/.config/hyprmoncfg`, et relever
   l’état actif/activé de `hyprmoncfgd.service`. Garder ces données personnelles
   hors des fichiers versionnés.
3. Arrêter et désactiver le service utilisateur `hyprmoncfgd.service` pour
   qu’il ne réapplique pas un profil pendant la migration. Cette opération
   sera à autoriser avec la copie des fichiers.
4. Copier uniquement les trois fichiers préparés (`hyprland.lua`,
   `monitors.lua`, `workspaces.lua`), en intégrant au préalable toute différence
   personnelle trouvée dans la configuration active.
5. Dans les réglages de la barre Omarchy, désactiver les deux plugins
   `crmne.hyprmoncfg` et `crmne.hyprmoncfg-workspaces`, puis choisir un widget
   de remplacement. Le widget Omarchy est conçu pour des espaces locaux par
   écran : son affichage et ses clics doivent être vérifiés avec les numéros
   globaux 1 à 10. L’apparence groupée des anciens widgets n’est pas fournie
   par ces fichiers Hyprland.
6. Recharger Hyprland et contrôler les erreurs de configuration, la disposition,
   les raccourcis de navigation/déplacement, les numéros de la barre, puis
   le comportement après une nouvelle session et un débranchement/rebranchement.

Il n’est pas nécessaire de désinstaller les paquets pour rendre les fichiers
personnels autonomes. La suppression des logiciels serait une intervention
supplémentaire. L’application automatique de profils selon les écrans connectés
ne sera plus assurée par hyprmoncfg.

## Retour à l’état précédent

Restaurer les fichiers Hyprland et la configuration de barre depuis la sauvegarde
datée, puis rétablir l’état précédent du service et recharger Hyprland.
Si `workspaces.lua` n’existait pas avant, retirer uniquement le fichier ajouté
lors de cette intervention. Les profils d’origine restent conservés.

## Validation

Les règles d’écrans et de workspaces ont été comparées au fichier généré
sauvegardé. Aucun rechargement ni test visuel sur Omarchy n’a été effectué.
L’environnement de préparation ne fournit ni Hyprland ni interpréteur Lua.
