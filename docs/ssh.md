# Accès SSH à l’ordinateur Omarchy depuis la maison

Le script se lance **sur l’ordinateur Omarchy cible, dans un terminal local**.
Sa préparation dans ce dépôt n’active aucun service.

## Prévisualiser puis activer

Depuis la racine du dépôt :

```bash
bash scripts/ssh_setup.sh --plan
bash scripts/ssh_setup.sh --apply
```

Le premier mode affiche uniquement l’aide. Le second affiche les adresses locales,
demande le compte existant, l’IPv4 de l’ordinateur et le sous-réseau autorisé.
Exemple fictif : `192.168.1.50` et `192.168.1.0/24`. Utiliser les valeurs réelles
de son réseau, visibles avec `ip -4 address` et `ip -4 route`.
La saisie exacte `ACTIVER` autorise les effets affichés, puis `sudo` demande
les droits nécessaires. Le script ne doit pas être lancé avec `sudo bash`.

Le script installe `openssh` si nécessaire, sauvegarde la configuration sous un
dossier unique `/var/backups/omarchy-ssh.*`, génère les clés d’hôte manquantes,
valide la syntaxe avec `sshd -t`, puis active et redémarre `sshd.service`.
La sauvegarde contient aussi l’état initial du service dans `service-state.txt`.
Si pacman échoue, résoudre le problème de paquets selon la procédure Omarchy
habituelle ; le script n’effectue pas de mise à jour partielle avec `pacman -Sy`.

**La configuration principale est remplacée.** Les anciens fichiers
`/etc/ssh/sshd_config.d/` restent sur disque mais ne sont plus inclus.
Cette approche convient à une configuration domestique dédiée ; examiner les
personnalisations existantes avant de confirmer. Les unités systemd personnalisées
et les surcharges de `sshd.service` sont refusées.

L’accès est limité au compte choisi depuis le CIDR privé indiqué, sur le port 22
et l’IPv4 choisie. Root, IPv6 et les redirections SSH sont désactivés.
Les clés SSH existantes du compte et son mot de passe actuel sont acceptés.
Le script ne crée pas de mot de passe ni de clé personnelle et ne change pas
`authorized_keys`. Un compte verrouillé ou sans mot de passe utilisable peut
nécessiter une clé déjà autorisée. Les restrictions du compte/PAM restent applicables.

## Pare-feu et connexion

Le script ne modifie pas le pare-feu. Si UFW est utilisé, vérifier son état :

```bash
sudo ufw status verbose
```

Si UFW est actif et bloque l’accès, autoriser explicitement le réseau choisi.
Exemple à adapter, à exécuter seulement après avoir décidé d’ajouter cette règle :

```bash
sudo ufw allow from 192.168.1.0/24 to 192.168.1.50 port 22 proto tcp
```

Ne pas activer UFW ni ouvrir le port à toutes les sources pour cette opération.
Pour un autre pare-feu, préparer une règle équivalente dans celui déjà utilisé.
Aucune redirection de port sur le routeur n’est nécessaire pour un accès à la
maison. Les appareils doivent pouvoir communiquer entre eux : un Wi-Fi invité
ou une isolation des clients peut empêcher la connexion.

Depuis le Mac ou un autre ordinateur du réseau :

```bash
ssh mon_compte@192.168.1.50
```

Comparer l’empreinte présentée à celle affichée par le script avant d’accepter
la première connexion. Le mot de passe demandé est celui du compte Omarchy.

Sur Omarchy, pour diagnostiquer :

```bash
sudo systemctl status sshd.service
sudo ss -ltnp 'sport = :22'
sudo journalctl -u sshd.service -n 50 --no-pager
```

Prévoir une réservation DHCP sur le routeur pour conserver l’adresse choisie.
Si l’IPv4 change, la liaison à cette adresse peut empêcher SSH de démarrer :
relancer la configuration depuis un terminal local avec la nouvelle adresse.

## Revenir à la configuration précédente

Depuis un terminal local, remplacer le chemin ci-dessous par le dossier affiché
par le script et lire son `service-state.txt` :

```bash
sudo cat /var/backups/omarchy-ssh.XXXXXXXX/service-state.txt
sudo cp -a /var/backups/omarchy-ssh.XXXXXXXX/sshd_config /etc/ssh/sshd_config
sudo /usr/bin/sshd -t
```

Si l’ancien état était `active=active`, redémarrer avec
`sudo systemctl restart sshd.service`. Sinon, arrêter avec
`sudo systemctl stop sshd.service`.
Si l’ancien état était `enabled=enabled`, utiliser
`sudo systemctl enable sshd.service`. Sinon, utiliser
`sudo systemctl disable sshd.service`.
Vérifier ensuite `sudo systemctl status sshd.service`.

Si la règle UFW de l’exemple a été ajoutée, la retirer avec les mêmes valeurs :

```bash
sudo ufw delete allow from 192.168.1.0/24 to 192.168.1.50 port 22 proto tcp
```

En cas d’échec après le remplacement de la configuration, le script tente de
restaurer automatiquement le fichier et les états de service initiaux.
Vérifier cette restauration si une commande échoue. Le paquet installé, les
clés d’hôte générées et les sauvegardes sont conservés ; ils ne sont pas supprimés
automatiquement.

## Vérification

Les contrôles locaux de syntaxe et de génération de configuration ne prouvent
pas le fonctionnement sur Omarchy. L’installation, le démarrage du service et
la connexion depuis un deuxième appareil restent à valider sur la machine cible.

Références : [OpenSSH sur Arch Linux](https://wiki.archlinux.org/title/OpenSSH),
[configuration du serveur OpenSSH](https://man.openbsd.org/sshd_config) et
[UFW sur Arch Linux](https://wiki.archlinux.org/title/Uncomplicated_Firewall).
