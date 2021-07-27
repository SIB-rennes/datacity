[Retourner au Sommaire]: ../README.md

[Retourner au Sommaire]


### Changer des visuels

D'une manière générale, il est déconseillé de changer la taille des éléments.Cela peut avoir des impacts sur l'apparence du jeu et impliquer des modifications des différentes scènes.

C'est notamment un véritable problème pour les UI, qui réagissent de manière dynamique et dont la taille n'est pas fixe et dépend de leur éléments (icônes comprises).


##### Visuels de même Taille

Si le nouveau visuel fait la même taille que le précédent, son changement est plutôt simple :

1. Ouvrir le projet avec Godot
2. Ecraser l'ancien fichier
3. Lorsque la fenêtre Godot reprendra le focus, le nouveau visuel sera chargé et remplacera le précédent

##### Visuels de tailles différentes

- S'il s'agit d'un bâtiment, se rendre directement à la partie [Mettre à jour un bâtiment].

[Mettre à jour un bâtiment]: #mettre-à-jour-un-bâtiment

- Les fonds des dialogues sont automatiquement ajustés en fonction de la taille de la fenêtre.

- Si l'élément à mettre à jour est un élément de l'UI (hérite de *Control*, en vert par défaut), il vaut mieux se référer à [ce tutoriel] pour comprendre comment sont construites les interfaces avec Godot et quels seront les paramètres à changer.

- Si l'élément à mettre à jour est un élément 2D (hérite de *Node2D*, en bleu par défaut), il faudra sûrement mettre à jour sa position et son échelle dans l'inspecteur. Si de plus, il est animé par un [AnimationPlayer], il faudra peut-être mettre à jour ses points clés pour garder une animation semblable.

[ce tutoriel]: https://docs.godotengine.org/en/stable/getting_started/step_by_step/ui_game_user_interface.html

[AnimationPlayer]: https://docs.godotengine.org/en/stable/tutorials/2d/2d_sprite_animation.html#sprite-sheet-with-animationplayer

### Mettre à jour un bâtiment

Sur la grille des bâtiments, une case fait 530 pixels de large par 320 de haut.

#### Changer la taille sur la grille

Si la taille occupée par le bâtiment sur la grille doit changer, il faut modifier sa taille dans *game_data/buildings_data.gd*. Le dictionnaire à mettre à jour est SIZES.

#### Changer la texture d'un bâtiment

Pour changer la texture d'un bâtiment :
1. Remplacer la texture par la nouvelle dans les fichiers du projet.

2. Ouvrir le projet avec Godot, qui doit alors lancer l'importation de la nouvelle texture.
3. Mettre à jour le dictionnaire SIZES si besoin dans *game_data/buildings_data.gd*.

#### Changer les bonus

Les bonus d'un bâtiment peuvent être modifiés dans le fichier *game_data/buildings_data.gd*. (Voir [Ajouter ses caractéristiques]).

[Ajouter ses caractéristiques]: #ajouter-ses-caractéristiques

#### Changer les seuils d'obtention

Les seuils d'obtention d'un bâtiment peuvent être modifiés dans le fichier *game_data/buildings_data.gd*. (Voir [Ajouter ses caractéristiques]).

[Ajouter ses caractéristiques]: #ajouter-ses-caractéristiques



### Ajouter un bâtiment

Sur la grille des bâtiments, une case fait 530 pixels de large par 320 de haut.

Les bâtiments, même s'ils tiennent sur une case unique, peuvent évidemment être plus grands. Ils apparaîtront alors par dessus les bâtiments placés plus hauts sur la grille.

#### Pour ajouter un bâtiment

##### Ajouter son visuel

1. Mettre le visuel dans le dossier *assets/sprites/buildings/*

2. Dans l'éditeur Godot, ouvrir *tilesets/buildings.tres*. Un onglet *Tileset* apparaît en bas.
3. Faire glisser depuis le *FileSystem* de Godot l'image du nouveau bâtiment dans la colonne avec les autres bâtiments.
4. Cliquer sur *New Single Tile*, et entourer les contours du bâtiment.
5. A droite, dans *Selected Tile* :
   * Indiquer le nom du bâtiment (ce nom sera utilisé dans le reste des fichiers du jeu)
   * Modifier son Tex Offset, s'il y a besoin de replacer le bâtiment sur la grille (parce qu'il est décalé par exemple).

[Utiliser une TileMap avec Godot]

[Utiliser une TileMap avec Godot]: https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html


##### Ajouter ses caractéristiques

1. Ouvrir *game_data/buildings_data.gd*

2. Indiquer la taille du bâtiment dans SIZES (s'il occupe plus d'une case).
3. Précharger son visuel dans TEXTURE.
4. Indiquer ses caractéristiques, comme par exemple la population qu'il peut accueillir, les points qu'il attribue en santé ou en sécurité, ...
5. Si le bâtiment s'obtient avec l'augmentation de la population, indiquer tous les combien le joueur doit l'obtenir dans BUILDINGS_FROM_POP.
6. Si le bâtiment s'obtient avec l'augmentation de la population *maximale*, indiquer tous les combien le joueur doit l'obtenir dans BUILDINGS_FROM_MAX_POP.


#### Pour visualiser un nouveau bâtiment

1. Ouvrir la scène CityBuilder

2. Cliquer sur le noeud Map/Buildings
3. Sélectionner le bâtiment à droite dans la liste
4. Placer le bâtiment sur la grille (clic droit pour effacer).

Si le bâtiment n'est pas centré, il est toujours possible de modifier son Tex offset, en ouvrant de nouveau *tilesets/buildings.tres* et en sélectionnant le contour jaune créé lors de *New Single Tile*.


### Modifier un événement scénaristique


#### Modifier le contenu
Pour modifier le contenu d'un dialogue, il suffit d'ouvrir le fichierdu dialogue avec Whiskers et de mettre à jour le graphe du dialogue.

#### Modifier les réglages

Les paramètres des événements se trouvent dans le fichier *game_data/scenaristic_events.gd*.

Le nom des événements n'est pas défini à un endroit particulier, aussi faut-il faire attention à utiliser le même nom pour une événement spécifique.

##### Conditions d'apparition

Ce fichier détermine les conditions d'apparitions des différents événements.
Un événment ne peut être déclenché que si toutes ses conditions sont remplies et qu'il n'y a pas d'événement déjà en attente.

Les conditions d'apparition sont regroupées sous forme d'un dictionnaire contenant le nom des événements et les conditions qui y sont liées.

Ces conditions sont elles-mêmes sous la forme d'un dictionnaire. Ce dernier contient des clés (méthodes) et des valeurs (paramètres de méthodes).

*Exemple de conditions :*
```Python
"PublierDonneesTransports": {
  "had_event(x)": ["PremieresMaisons"],
  "not had_event(x)": ["PublierDonneesTransports"], # Not again
  "probability(x)": .3, # 30% chance after each building
  "population_over(x)": 50 # The event won't trigger if the population count is under x
},
```

Les fonctions sont définies dans la suite du fichier et  prennent toutes un unique paramètre, marqué (x).
S'il y a besoin d'avoir plusieurs paramètres, on passe en paramètre des tableaux.

S'il y a besoin d'ajouter des types de conditions, il faut créer une nouvelle fonction dans le fichier *game_data/scenaristic_events.gd*. Cette fonction doit prendre un unique paramètre et renvoyer un booléen.


##### Lien vers le JSON

Le dictionnaire DIALOG_FILES contient le lien vers le fichier JSON, créé par Whiskers.

##### Résumé de l'événement

Lorsque le joueur reçoit une notification pour un événement et l'ouvre, un résumé de l'événement s'affiche. Le joueur peut alors lancer le dialogue ou fermer la notification.

Ce résumé est écrit dans le dictionnaire SUMMARIES.

##### Bâtiment offerts systématiquement

Certains événements donnent des bâtiments systématiquement, peu importe le chemin parcouru à la résolution. Ces bâtiments obtenus ne seront pas affichés dans la fenêtre résultat de l’évènement.

Ces bâtiments sont marqués dans le dictionnaire OFFERED_BUILDINGS.



### Ajouter un événement scénaristique

1.	Créer le graphe de dialogue avec whiskers
2.	Ajouter les réglages de l'événement dans le fichier gamedata/scenaristic_events.gd :
  *	EVENTS_CONDITIONS : Ajouter les conditions de l’évènement .
  *	DIALOG_FILES : Ajouter le lien du fichier JSON créé par Whiskers.
  *	 SUMMARIES : Indiquer le résumé de l’évènement en quelques mots.
  * OFFERED_BUILDINGS : mettre les bâtiments qui seront systématiquement donnés à la fin de l’évènement. Peu importe le résultat de l’évènement (réussi ou non), le joueur recevra ces bâtiments et ils ne seront pas affichés dans la fenêtre résultat de l’évènement.

Pour plus d'informations sur les réglages, voir la partie [Modifier un événement scénaristique].

[Modifier un événement scénaristique]: #modifier-un-événement-scénaristique
