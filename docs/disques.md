# Préparer les quatre disques ext4

Sur Omarchy, relever les **UUID des systèmes de fichiers**, pas les PARTUUID :

```bash
lsblk -f
```

Dans `scripts/disk_setup.sh`, remplir les quatre chaînes de `UUIDS` :

```bash
UUIDS=(
  "UUID-DU-PREMIER-DISQUE"
  "UUID-DU-DEUXIEME-DISQUE"
  "UUID-DU-TROISIEME-DISQUE"
  "UUID-DU-QUATRIEME-DISQUE"
)
```

Ce sont les seuls champs obligatoires. Les labels existants sont conservés.
Un disque sans label reçoit `Disque1`, `Disque2`, etc. Pour choisir d’autres
noms, remplir les entrées correspondantes de `LABELS`. Les labels doivent être
distincts, sans slash ni antislash, avec au maximum 16 octets (certains caractères
accentués occupent plusieurs octets). Le compte propriétaire est automatiquement
celui qui lance le script ; `OWNER` permet de le préciser.

Depuis la racine du dépôt :

```bash
bash scripts/disk_setup.sh --plan
```

Ce mode contrôle les valeurs saisies et décrit les effets sans sudo ni modification.
Il ne vérifie pas encore les périphériques physiques.

## Appliquer sur Omarchy

Fermer les fichiers et applications utilisant les quatre disques et démonter
leurs partitions de données dans le gestionnaire de fichiers ou GNOME Disques.
Ne pas démonter de partition système. Le script refuse les partitions déjà
montées, les UUID ambigus, les formats autres qu’ext4 et les points de montage
non vides ou symboliques. Il n’installe aucune dépendance automatiquement.

```bash
bash scripts/disk_setup.sh --apply
```

Lancer depuis un terminal local **sans sudo devant bash**. Le script demande
les droits sudo pour les contrôles, puis affiche les quatre associations
UUID/périphérique/label et le propriétaire cible. La saisie exacte `CONFIGURER`
autorise les changements suivants :

- sauvegarder `/etc/fstab`, les anciens labels, les propriétaires, groupes,
  permissions, ACL et capacités exécutables dans `/var/backups/omarchy-disks.*` ;
- monter les quatre partitions sous `/mnt/<label>` ;
- attribuer les dossiers et fichiers existants au compte courant et à son groupe
  principal (`RECURSIVE=true` par défaut, sans suivre les liens symboliques) ;
- définir les labels et écrire les entrées UUID dans `/etc/fstab`, puis recharger
  systemd pour les prochains démarrages.

Pour attribuer uniquement la racine de chaque disque, choisir `RECURSIVE=false`.
La sauvegarde des métadonnées et la prise de possession récursives peuvent prendre
du temps sur de gros volumes. Le script ne change pas les bits de permissions
volontairement ; `chown` peut retirer les bits setuid/setgid et les capacités
exécutables. Les anciennes métadonnées sont sauvegardées pour la restauration.
Des ACL restrictives existantes peuvent encore limiter certains accès.

Les entrées existantes correspondant aux quatre partitions sont commentées et
remplacées. Une ancienne entrée sur un chemin système (par exemple `/home`) est
refusée ; les montages imbriqués ou bind qui entrent en conflit demandent une
vérification manuelle. Les autres entrées fstab restent conservées.

`nofail` permet de poursuivre le démarrage si un disque manque ; `x-gvfs-show`
demande son affichage dans les gestionnaires de fichiers compatibles GVfs.
L’affichage exact dépend du gestionnaire de fichiers. Rouvrir celui-ci et vérifier
les quatre labels après l’opération. Le script ne formate rien, ne change aucun
UUID et ne sauvegarde pas le contenu des fichiers.

## Retour arrière ou interruption

Le travail n’est pas une transaction : en cas d’échec, certaines partitions
peuvent être déjà montées et partiellement attribuées. Le dossier de sauvegarde
est affiché avant les changements sur les disques. Ne pas supprimer ce dossier.

Depuis un terminal local, fermer les applications utilisant les disques.
Pour chaque index `0`, `1`, `2`, `3` présent dans la sauvegarde, lire
`uuid-INDEX.txt`, `target-INDEX.txt` et `label-INDEX.txt` afin d’identifier le disque,
son point de montage et son ancien label. Les commandes ci-dessous sont des
exemples pour l’index `0`, à adapter au dossier réel :

```bash
sudo cat /var/backups/omarchy-disks.XXXXXXXX/uuid-0.txt
sudo cat /var/backups/omarchy-disks.XXXXXXXX/target-0.txt
sudo cat /var/backups/omarchy-disks.XXXXXXXX/label-0.txt
```

Vérifier que la même partition est montée au même emplacement que lors de la
sauvegarde. Si elle ne l’est plus, la remonter à cet emplacement avant de restaurer
les ACL, car celles-ci contiennent des chemins absolus. Ne restaurer que les
ensembles dont `permissions-INDEX.complete` existe :

```bash
sudo setfacl --restore=/var/backups/omarchy-disks.XXXXXXXX/permissions-0.acl
sudo setfattr --restore=/var/backups/omarchy-disks.XXXXXXXX/capabilities-0.attrs
```

Ces commandes restaurent les métadonnées sauvegardées, dont propriétaires et
groupes, pour les fichiers encore présents. Les fichiers créés ou déplacés après
la sauvegarde ne sont pas automatiquement remis à leur état antérieur. Les liens
symboliques ne sont pas pris en possession et ne figurent pas dans cette sauvegarde.

Rétablir ensuite l’ancien label, y compris une chaîne vide si le disque n’en avait pas :

```bash
sudo e2label /dev/disk/by-uuid/UUID-DU-DISQUE 'ANCIEN-LABEL'
```

Démonter les quatre points `/mnt/<label>` utilisés par le script. Comparer le fstab
actuel à sa sauvegarde avant restauration pour préserver d’éventuels changements
ultérieurs, puis, si la copie convient :

```bash
sudo cp -a /var/backups/omarchy-disks.XXXXXXXX/fstab /etc/fstab
sudo systemctl daemon-reload
sudo findmnt --verify
```

Remonter les disques selon leur ancienne configuration, ou via le gestionnaire
de fichiers. Les dossiers vides créés sous `/mnt` peuvent rester en place.

## Limite de validation

La préparation dans le dépôt et les tests de génération de fstab ne montent
aucun disque. Le montage réel, le démarrage et l’affichage des labels restent
à vérifier sur l’ordinateur Omarchy.

Références : [fstab](https://man7.org/linux/man-pages/man5/fstab.5.html),
[findmnt](https://man7.org/linux/man-pages/man8/findmnt.8.html),
[e2label](https://man7.org/linux/man-pages/man8/e2label.8.html).
