# Configurations Omarchy

Sauvegarde des configurations du bureau, des terminaux, des éditeurs et des plugins.
Les fichiers présents ici ne sont pas appliqués automatiquement à la machine.

Les profils de navigateur, cookies, historiques, identifiants GitHub, données
PulseAudio, caches, verrous, sauvegardes temporaires et données de session sont
exclus par le fichier `.gitignore` du dépôt. Seuls les manifestes
`NativeMessagingHosts` sont conservés dans les dossiers des navigateurs.
La configuration Git personnelle, les favoris GTK et les profils contenant
les numéros de série des écrans sont également exclus.

Les plugins tiers sont sauvegardés comme des fichiers ordinaires, avec leurs
licences et les modifications locales. `plugins-sources.json` indique leur
dépôt d’origine et le commit utilisé comme base. Leurs historiques Git imbriqués
ne font pas partie de la sauvegarde.

Certains liens symboliques et chemins dépendent de cette installation Omarchy.
La restauration demande de les vérifier et d’obtenir une autorisation avant
toute copie vers les configurations actives.

Vérifications effectuées avant cette sauvegarde : tests Node des espaces de
travail, sept tests Python de disposition Omaplug et test Node du tiroir.
Ces contrôles ne constituent pas une validation visuelle sur le bureau.
