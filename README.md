# Omarchy-setup

Ce dépôt regroupe mes dotfiles et mes scripts de personnalisation pour mon ordinateur sous Omarchy à la maison.

Il sert à :

- sauvegarder et versionner les configurations de mon environnement ;
- préparer des scripts pour reproduire mes réglages et mes personnalisations ;
- documenter leur utilisation, les sauvegardes et le retour à la configuration précédente.

## Organisation

| Dossier | Contenu |
| --- | --- |
| [`dotfiles/`](dotfiles/README.md) | Configurations du bureau, des applications, des terminaux, des éditeurs et des plugins. |
| `scripts/` | Scripts de configuration et de personnalisation. |
| `docs/` | Guides d’utilisation et procédures de retour arrière. |
| `tests/` | Contrôles des scripts et de leurs fichiers générés. |

Les fichiers sont préparés et versionnés ici. Leur présence dans le dépôt ne les applique pas à la machine. Les chemins et les liens symboliques doivent être vérifiés avant toute restauration.

## Scripts disponibles

- [Configurer l’accès SSH depuis le réseau de la maison](docs/ssh.md) : script
  interactif avec prévisualisation, confirmation et sauvegarde avant activation.
- [Monter et prendre possession de quatre disques ext4](docs/disques.md) : UUID
  à renseigner, conservation des labels, montage automatique et sauvegarde.

Pour consulter les effets prévus sans appliquer les changements :

```bash
bash scripts/ssh_setup.sh --plan
bash scripts/disk_setup.sh --plan
```

Pour le script des disques, remplir d’abord les quatre UUID dans le fichier. Consulter le guide correspondant avant d’utiliser `--apply` sur Omarchy.

## Sauvegarde et confidentialité

Avant d’appliquer une configuration, sauvegarder les fichiers existants et prévoir le retour arrière. Les secrets, mots de passe, clés privées et données personnelles sensibles doivent rester hors du dépôt. Les exclusions propres aux dotfiles sont décrites dans leur [documentation](dotfiles/README.md).

Les contrôles de fichiers et les tests automatisés ne remplacent pas une validation sur l’installation Omarchy réelle.

## Autorisation avant toute intervention

Le travail dans ce dépôt ne constitue pas une autorisation d’installer des logiciels ou d’appliquer des configurations à mon ordinateur. Toute installation ou modification de l’environnement de la machine doit recevoir mon autorisation explicite au préalable.

Les assistants IA doivent suivre les consignes du fichier [AGENTS.md](AGENTS.md).
