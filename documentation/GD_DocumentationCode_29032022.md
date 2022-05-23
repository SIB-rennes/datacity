# Sommaire

-[Variables globales]
-[Sauvegarder une variable]
-[Charger une variable sauvegardé]
-[Accéder au fichier de sauvegarde du projet godot]
-[Suppression de la sauvegarde]
-[Ajouter un scénario ]
-[Ajouter un grade de gain]
-[Ajouter un nouveau bâtiment]
-[Variable dans Wisker]
-[Modifier le tutoriel]

### Variables Globales ------------------------------------------------------------------------

Toutes les variables globales se trouvent dans le script *player_data.gd*, cela comprend:

-Le nombre de data point du joueur = variable *datapoints*
-Les revenus passif du joueur = variable *incomes*
-Si le tuto est fini ou non = variable *tuto_advancement*
-La population = dictionnaire *city_data*
-La population maximal = dictionnaire *city_data*
-La satisfaction = dictionnaire *city_data*
-Le grade de gain actuel = variable *limit_level*
-Le genre choisi par le joueur = variable *gender*
-Le nom de la ville choisi par le joueur = variable *city*
-Le bureau choisi par le joueur = variable *bureau*
-Le nom du fichier de sauvegarde = variable constante *SAVEFILE*

### Sauvegarder une variable ------------------------------------------------------------------

La sauvegarde du jeu se fait dans le script *CityBuilder.gd*, via la fonction *save()*.

Pour qu'une variable soit sauvegardée, il faut créer une chaîne de caractères suivis de la
variable dans le dictionnaire *save_dict* comme ci-dessous.

Exemple:
	
	var save_dict = {
		"nom": variable
	}

### Charger une variable sauvegardé -----------------------------------------------------------

Le chargement de la sauvegarde du projet, ce fait dans la fonction *Load()* dans le
script *CityBuilder.gd*.

Pour charger une variable sauvegardée, il faut d'abord ajouter le nom que vous lui
avez donné dans *save_dict*, dans le tableau nommé *keys*.

Exemple:
	var keys = ["nom"]

Puis ajoutez la ligne mise dans l'exemple suivant, juste avant le *return* se trouvant, 
à la fin de la fonction *load()*.

Exemple:
	variable = dic["nom"]

### Accéder au fichier de sauvegarde du projet godot ------------------------------------------

Lorsque la fonction *save()* de *CityBuilder.gd* sauvegarde des variables, elle créait un
fichier regroupant toutes les informations sauvegardé.

# Sur Windows

Pour accéder à ce fichier, il faut entrer la commande [win+r] et entrer %appdata% puis
appuyer sur *OK*.

Ensuite, ouvrez le dossier nommé *Godot* puis *app_userdata*.

Le fichier devrait se trouver dans le dossier nommé *data_city*, il devrait se nommer,
*savegame.save*.

# Sur Linux

~/.local/share/godot/datacity = chemin vers le fichier de sauvegarde

En cas de probléme, voir sur:
https://docs.godotengine.org/fr/stable/tutorials/io/data_paths.html

### Suppression de la sauvegarde --------------------------------------------------------------

Pour supprimer la sauvegarde faite dans la fonction *save()* de *CityBuilder.gd*,
vous devez supprimer le fichier de sauvegarde (*savegame.save*).

Sinon, pour le supprimer depuis le code, vous devrez créer une variable comme dans
l'exemple suivant.

Exemple:
	var dir = Directory.new()

Ensuite, il vous suffira de créer la ligne de code de l'exemple suivant, dans la
fonction où vous souhaitez supprimer le fichier de sauvegarde.

Exemple:
	dir.remove("user://savegame.save")

(Pour voir un exemple concret, rendez-vous dans le script *main_menu.gd*)

### Ajouter un scénario -----------------------------------------------------------------------

Tout d'abord créé un fichier json contenant les données de votre scénario, grâce
à Wisker.

Ensuite, une fois le fichier json créais et mit dans le dossier *scenarios* du jeu,
rendez-vous dans le script *scenario_data.gd*, et ajoutez votre scénario dans le
dictionnaire nommé *INSTANCES_PATH* comme dans l'exemple ci-dessous.
(Remplacer *exemple_scenar.json* par le nom de votre scénario)

Exemple:
	const INSTANCES_PATH = {
		"res://scenarios/exemple_scenar.json": 
			"res://scenarios/dialog_conference_variables.gd",
	}

Ensuite, rendez-vous dans le script *scenaristic_events.gd* et ajouté les conditions
de lancement de votre scénario dans le dictionnaire nommé *EVENTS_CONDITIONS*.
(un exemple est présent au début du script, juste avant *EVENT_CONDITIONS*)

Puis, dans le dictionnaire nommé *DIALOG_FILES*, donnez un nom à votre scénario
et indiqué son chemin comme dans l'exemple ci-dessous.
(Remplacer *exemple_scenar.json* par le nom de votre scénario)

Exemple:
	const DIALOG_FILES = {
		"Exemple":"res://scenarios/exemple_scenar.json",
	}

Ensuite renseigné dans le dictionnaire nommé *SUMMARIES*, ce qui va être indiqué
au joueur, quand il va ouvrir la notification du scénario.

Exemple:
	const SUMMARIES = {
		"Exemple": "Votre adjointe veut vous parler de l'exemple",
	}

Pour finir, si votre scénario est censé donner des bâtiments, renseignez, qu'elle
bâtiment et le nombre que le scénario doit en donner dans le dictionnaire nommé,
*OFFERED_BUILDINGS*.

Exemple:
	const OFFERED_BUILDINGS = {
		"Exemple": {
			"Maison 1": 1,
		},
	}

### Ajouter un grade de gain ------------------------------------------------------------------

Dans le script *player_data.gd*, se trouve une fonction *_physics_process(delta)* qui à
pour but d'augmenter la limite de construction indiqué dans le dictionnaire nommé
*building_limit*, de chaque bâtiment présent dans le dictionnaire nommé "building_grade",
de 1.

Un grade est passait une fois que le joueur à atteint un certain niveau de population,
mais le grade peut être perdus, si le joueur se retrouve de nouveau en dessous du
niveau de population requis pour l'obtention du grade.

Pour ajouter un grade, il faut modifier le *_physics_process(delta)* en y ajoutant d'abord
l'exemple suivant.

Exemple:
	elif PlayerData.city_data[POPULATION] > 200 && limit_level == "1"
		limit_level = "2"
		for building in PlayerData.building_grade:
			if PlayerData.building_limit[building] < PlayerData.building_limit_max[building]:
				PlayerData.building_limit[building] = PlayerData.building_limit[building] += 1

Puis ajoutez l'exemple suivant dans la fonction *_physics_process(delta)*.

Exemple:
	elif PlayerData.city_data[POPULATION] < 200 && limit_level == "2"
		limit_level = "1"
		for building in PlayerData.building_grade:
			if PlayerData.building_limit[building] < PlayerData.building_limit_max[building]:
				PlayerData.building_limit[building] = PlayerData.building_limit[building] -= 1

(Dans les deux exemples précédant le chiffre devant *PlayerData.city_data[POPULATION]* est le
niveau de population requis pour le gain ou la perte du grade)

### Ajouter un nouveau bâtiment ---------------------------------------------------------------

Tout d'abord, vous devrez mettre le sprite de votre bâtiment dans le dossier *building*,
présent dans le dossier *assets*, en format png.

Puis ouvrez le tilset nommé *buildings.tres* et glissez-y le sprite de votre bâtiment.

Ensuite, sélectionnez votre bâtiment dans le tileset et cliquez sûr
*Nouvelle Simple Tuile* ensuite, activez l'aimantation et affichez la grille, via le
bouton qui représente une grille avec un aiment.

Ensuite, à droite, dans *Snap Options*, vous allez régler le x de *Step* à 530 et son y à 330.

Puis, dans *Selected Tile*, vous allez donner un nom à votre bâtiment dans la case *Name*,
dans la case nommé *Tex Offset*, vous allez régler la position x et y de la Tile de façon, à
ce que le batiment sois bien placé sur les cases.

(pour les exemples suivant nous utiliserons *Exemple_name* comme nom de bâtiment, pensez donc
à le remplacer par le nom de votre bâtiment)

(Si le bâtiment fait plus d'une case pensez à bien sélectionne l'intégralité des case sur
l'affichage)

Après avoir fait tout ça, rendez-vous dans le script *building_data.gd* et ajoutez les
dimensions de votre bâtiment en vecteur2 dans le dictionnaire nommé *SIZES*, comme dans
l'exemple suivant.

Exemple:
	const SIZES = {
		"Exemple_name": Vector2(1,1),
	}

Ensuite, indiquez dans le dictionnaire nommé *OFFSET* les valeurs présentes dans la case
*Tex Offset* de votre bâtiment, comme dans l'exemple ci-dessous.

Exemple:
	const OFFSET = {
		"Exemple_name": Vector2(0, -11.156)
	}

Après cela, dans le dictionnaire nommé *TEXTURES*, indiquez le chemin du sprite de
Votre bâtiment, comme dans l'exemple suivant.
(Pensez à remplacer *exemple_building.png* par le nom du sprite de votre bâtiment)

Exemple:
	const TEXTURES = {
		"Exemple_name": preload("res://assets/sprites/buildings/exemple_building.png"),
	}

Puis, dans le dictionnaire nommé *PRIX* indiquez le prix en datapoints que le joueur va
devoir payer pour construire votre bâtiment, comme dans l'exemple suivant.

Exemple:
	const PRIX = {
		"Exemple_name": 300,
	}

Ensuite, ajoutez votre bâtiment dans le dictionnaire nommé *INFLATION*, et indiquez de
combien augmentera le prix du batiment chaque fois que le joueur en posera un.

Exemple:
	const INFLATION = {
		"EXEMPLE_NAME": 100,
	}

Ensuite, ajoutez votre bâtiment dans le dictionnaire avec le nom de la catégorie de
bâtiment dont vous souhaitez qu'il fasse partie, vous devrez choisir entre *ADMIN*
(administratif), *ASSOCIATIF*, *COMMERCIAL*, *HABITATION*, *LOISIR*, *SANTE* et
*DECO* (décoration).

Exemple:
	const DECO = {
		"Exemple_name": 1,
	}

Puis, si votre bâtiment fait 4 cases, vous devez l'ajoutez de la même façon que dans
l'exemple précédant, dans le dictionnaire nommé *MEDIUM_BUILDING*, mais s'il fait
9 cases, il faudra l'ajoutez dans le dictionnaire nommé *BIG_BUILDING*.

Si votre bâtiment est un bâtiment commercial, vous devez l'ajouter dans le dictionnaire
nommé *INCOMES*, en indiquant combien de datapoints il rapporte chaque seconde.

Exemple:
	const INCOMES = {
		"Exemple_name": 10,
	}

Si votre bâtiment est une habitation, alors vous devrez indiquer combien de population
il ajoute dans le dictionnaire nommé *POPULATION_SPACE*.

Exemple:
	const POPULATION_SPACE = {
		"Exemple_name": 20,
	}

Si votre bâtiment est un bâtiment rapportant de la satisfaction, vous devrez indiquer
dans le dictionnaire nommé *SATISFACTION_POINTS*, combien de points de satisfaction il
rapporte.

Exemple:
	const SATISFACTION_POINTS = {
		"exemple_name": 50,
	}

Ensuite, rendez-vous dans le script *player_data.gd* est ajouté votre bâtiment dans le
dictionnaire nommé *building_list*, afin qu'il soit ajouté dans le menu de construction.

Exemple:
	const building_list = {
		"Exemple_name": 1,
	}

Puis ajoutez le dans le dictionnaire nommé *building_limit*.
(le joueur pourra poser le bâtiment, à chaque fois que la valeur indiquée est supérieure à 1)

Exemple:
	const building_limit = {
		"Exemple_name": 1,
	}

Après ça, indiquez dans le dictionnaire *building_limit_max* le nombre maximal de fois,
où le joueur pourra construire le bâtiment.

Exemple:
	const building_limit_max = {
		"Exemple_nameé: 10,
	}

Si vous souhaitez que la limite de construction du bâtiment augmente via les grades, ajoutez
votre bâtiment dans le dictionnaire nommé *building_grade*.

Exemple:
	const building_grade = {
		"Exemple_name": 1,
	}

### Variables dans Wisker ---------------------------------------------------------------------

Grâce à la fonction *process_single_data_block()* présente dans le script nommé
*DialogScene.gd*, nous pouvons modifier des éléments via les dialog nodes de Wisker.
(pour plus d'infos sur les dialogue nodes, allez voir le doc sur Wisker)

# Définir l'arriére plans

Pour définir l'image en arrière plans de la scène *DialogScene.tscn*, il suffit
d'écrire *background=*, suivis du nom de l'image voulu.

Exemple:
	background=bureau_1.png

Pour que le jeu affiche le bureau, sélectionne par le joueur au dans le formulaire
de début de jeu, il suffit de remplacer le nom de l'image par */bureau/*.

Exemple:
	background=/bureau/

La fonction *process_single_data_block()* ira alors chercher le nom l'image du bureau
choisi par le joueur, dans *player_data.gd*, dans la variable *bureau*

# Définir le nom de l'interlocuteur

Pour affiché le nom du personnage parlant au joueur, il vous suffit d'écrire *name=*,
suivis du nom du personnage.

Exemple:
	name=Adjointe

Pour faire en sorte qu'aucun nom ne soit affichée, mettez juste un espace après *name=*.

Exemple:
	name= 

# Définir qui parle au joueur

Pour afficher l'image du personnage qu parle au joueur, il vous suffit d'écrire *character=*,
suivis du nom du sprite voulu.

Exemple:
	character:adjointe.png

Pour faire en sorte que personne ne soit affichée à l'écran, il suffit d'écrire,
*transparent.png* à la suite de *character=*.

Exemple:
	character:transparent.png

# Faire revenir le scénario en cas d'échéc

Pour que le scénario revienne en cas d'échec, il vous suffit d'écrire *redo=*, suivis de *true*,
juste avant l'end node du scénario (entre l'end node et la mauvaise réponse).

Exemple:
	redo=true

# Prendre en compte le genre

Le genre du joueur et compter comme une variable normale de Wisker, donc pour l'utiliser il
suffit de créer un condition node et de lui relier un expression node possédant la variable
gender.

Ensuite, les dialogues à la suite de *true* devrons être aux féminins et ceux à la suite
de false devrons êtres en au masculin.

(true = femme ; false = homme)

# Définir les bâtiment gagnés

Pour définir quel bâtiment, le joueur gagne dans le scénario, il faut écrire *building=*,
suivis du nom du bâtiment souhaité.
(Il faut aussi que le batiment et le nombre débloqué soit renseigné dans *scenaristic_event.gd*
comme vus dans ###Ajouter un scénario###)

Exemple:
	building=Déchetterie

### Modifier le tutoriel ----------------------------------------------------------------------

Pour modifier le tutoriel qui se lance au début de la scène de gestion (*CityBUilder.tscn*),
Vous devez ajouter ou modifier des états présents dans l'énumération nommée *State_tuto* qui
se trouve dans le script *CtyBuiilder.gd*.

(l'introduction utilise le même principe de fonctionnement dans son script *introduction.gd*)

# Ajouter un état

Tout d'abord, vous devez donner un nom à votre nouvel état dans *State_tuto*, comme dans
l'exemple suivant.
(pour les exemple suivant, nous utiliserons *EXEMPLE_STATE* pour nommé le nouvel état crée)

Exemple:
	enum State_tuto {
		EXEMPLE_STATE
	}

Ensuite dans la fonction *listen_state_data()*, vous allez devoir ajouter votre nouvel état
à la suite de *match current_tuto:*, puis vous devrez écrire ce que doit faire le script, quand
*current_tuto* se trouve être votre nouvelle variable.

Exemple:
	func listen_state_data():
		current_tuto = next_tuto
		set_next_tuto()
		can_click = false
		can_use = "not_defined"
		match current_tuto:
			State_tuto.EXEMPLE_STATE:
				print("Exemple")
				yield(get_tree().create_timer(0.5), "timeout")
				can_click = true

Enfin, dans la fonction *set_next_tuto()* indiquer à la suite de quel état se lancera
votre nouvel état, et quel état il lancera une fois finis, comme dans l'exemple suivant.

Exemple:
	func set_next_tuto():
		match current_tuto:
			State_tuto.RANDOM_STATE_1:
				State_tuto.EXEMPLE_STATE
			State_tuto.EXEMPLE_STATE:
				State_tuto.RANDOM_STATE_2

# Modifier un état

Il vous suffit de modifier ce qui se trouve à la suite de l'état que vous souhaitez modifier
dans la fonction *listen_state_data()*.

#### Pour créer une mécanique qui permet d'ouvrir des documents lors des scénarios :
Dans DialogScene.tscn, créer un TextureButton « open_bureau » :
    Lui ajouter un signal « pressed »
ajouter un TextureRect « bureau_bg »
Créer un nœud control « bureau » :
    ajouter des nœuds enfants Node2D + TextureButton « doc_1 » « doc_2 » « doc_3 »
    créer un TextureButton « close_bureau » dans le Node2D et lui ajouter un signal pressed

## Dans DialogScene.gd :
##  ligne 25 :
var can_pass = true

var bureau_open = false

##  Ligne 117 :
    # Process inputs
func _input(event):
	# if we touched the screen or the mouse
	if bureau_open == false:
		if event is InputEventScreenTouch or event is InputEventMouseButton:
			if event.pressed:
				if can_pass == true:
					process_player_click()
			
		# If we pressed space
		elif event is InputEventKey:
			if event.pressed and event.unicode == KEY_SPACE:
				if can_pass == true:
					process_player_click()
                    
##  ligne 378 :
func _on_close_bureau_pressed():
	$bureau.hide()
	$Background.show()
	$Character.show()
	$UI.show()
	


func _on_open_bureau_pressed():
	$bureau.show()
	$Background.hide()
	$Character.hide()
	$UI.hide()

##  ligne 384 :
func _on_close_bureau_pressed():
	bureau_open = false
	$bureau.hide()
	$Background.show()
	$Character.show()
	$UI.show()
	


func _on_open_bureau_pressed():
	can_pass = true
	bureau_open = true
	$bureau.show()
	$Background.hide()
	$Character.hide()
	$UI.hide()


func _on_open_bureau_mouse_entered():
	can_pass = false


func _on_open_bureau_mouse_exited():
	can_pass = true

## cacher le bureau

#### Pour l'animation :
Créer un AnimationsPlayer avec ces données :
Ne pas oublier de mettre les boutons pour fermer les documents invisible jusqu’à 0.9, c’est important pour la suite.
Bureau 1 :
    Doc 1 :
        0 secondes :
            Position : x=-5.626 y=297.826
            Rotation Degree : -18.7
            Scale : x=1 y=1
            Z Index : 0
        1 seconde :
            Position : x=-224.608 y=-1.728
            Rotation Degree : 0
            Scale : x=2 y=2
            Z Index : 2
    Doc 2 :
        0 secondes :
            Position : x=311.306 y=226.748
            Rotation Degree : 0
            Scale : x=1 y=1
            Z Index : 0
        1 seconde :
            Position : x=-224.608 y=-1.728
            Rotation Degree : 0
            Scale : x=2 y=2
            Z Index : 2
    Doc 3 :
    0 secondes :
        Position : x=676.733 y=240.604
        Rotation Degree : 26
        Scale : x=1 y=1
        Z Index : 0
    1 seconde :
        Position : x=-224.608 y=-1.728
        Rotation Degree : 0
        Scale : x=2 y=2
        Z Index : 2
Bureau 2 :
    Doc 1 :
    0 secondes :
        Position : x=334.758 y=297.826
        Rotation Degree : -18.7
        Scale : x=1 y=1
        Z Index : 0
    1 seconde :
        Position : x=-224.608 y=-1.728
        Rotation Degree : 0
        Scale : x=2 y=2
        Z Index : 2
    Doc 2 :
    0 secondes :
        Position : x=570.327 y=226.748
        Rotation Degree : 0
        Scale : x=1 y=1
        Z Index : 0
    1 seconde :
        Position : x=-224.608 y=-1.728
        Rotation Degree : 0
        Scale : x=2 y=2
        Z Index : 2
    Doc 3 :
    0 secondes :
        Position : x=846.258 y=239.347
        Rotation Degree : 26
        Scale : x=1 y=1
        Z Index : 0
    1 seconde :
        Position : x=-224.608 y=-1.728
        Rotation Degree : 0
        Scale : x=2 y=2
        Z Index : 2
Bureau 3 :
    Doc 1 :
    0 secondes :
        Position : x=13.444 y=317.956
        Rotation Degree : -18.7
        Scale : x=1 y=1
        Z Index : 0
    1 seconde :
        Position : x=-224.608 y=-1.728
        Rotation Degree : 0
        Scale : x=2 y=2
        Z Index : 2
    Doc 2 :
    0 secondes :
        Position : x=311.368 y=240.748
        Rotation Degree : 0
        Scale : x=1 y=1
        Z Index : 0
    1 seconde :
        Position : x=-224.608 y=-1.728
        Rotation Degree : 0
        Scale : x=2 y=2
        Z Index : 2
    Doc 3 :
    0 secondes :
        Position : x=614.733 y=245.664
        Rotation Degree : 26
        Scale : x=1 y=1
        Z Index : 0
    1 seconde :
        Position : x=-224.608 y=-1.728
        Rotation Degree : 0
        Scale : x=2 y=2
        Z Index : 2
        
## DialogScene.gd :
## ligne 410 :
func _on_doc_1_pressed():
	$bureau/bureau_bg/doc1/doc_1/Animation.play("take")


func _on_close_1_pressed():
	$bureau/bureau_bg/doc1/doc_1/Animation.play_backwards("take")


func _on_doc_2_pressed():
	$bureau/bureau_bg/doc2/doc_2/Animation.play("take")


func _on_close_2_pressed():
	$bureau/bureau_bg/doc2/doc_2/Animation.play_backwards("take")


func _on_doc_3_pressed():
	$bureau/bureau_bg/doc3/doc_3/Animation.play("take")


func _on_close_3_pressed():
	$bureau/bureau_bg/doc3/doc_3/Animation.play_backwards("take")

## Pour changer la jauge de satisfaction, il faut d'abord aller dans CityUI.tscn :
Changer la barre de Santé en barre de Satisfaction et supprimer les autres
Changer le nom du label Santé en « Satisfaction »

## Puis ensuite dans CityUi.gd :
##  ligne 31 :

    # Bars
onready var bar_satisfaction = $VboxContainer/TopContainer/TopLeftContainer/NeedContainer/Satisfaction

##  ligne 76 :

    # Satisfaction
var satisfaction_percent = (50.0 * PlayerData.city_data[PlayerData.SATISFACTION]) / max_pop
bar_satisfaction.set_percentage(satisfaction_percent)

## Buildings_data.gd:
Supprimer les catégories Santé Loisir ect
##  ligne 102 :

    # increase satisfaction
const SATISFACTION_POINTS = {
	"Espaces verts": 5,
	"Place de marché": 5,
	"Supérette": 5,
	"Médiathèque": 5,
	"Poste": 5,
	"Lycée": 5,
	"Cinema": 5,
	"Theatre": 5,
	"Monument": 5,
	"Musee": 5,
	"Centre associatif": 5,
	"Pistes cyclables": 5,
	"Pharmacie": 5,
	"Caserne de pompiers": 5,
	"Cimetiere": 5,
	"Déchetterie": 5,
	"Supermarche": 5,
	"Universite": 5,
	"Hopital": 5,
	"Banque": 5
}

##  ligne 225 :

elif building in SATISFACTION_POINTS:
		res = [PlayerData.SATISFACTION, SATISFACTION_POINTS[building]]

## Et enfin, player_data.gd :
##  ligne 9 :
Supprimer les constantes des anciennes catégories
const SATISFACTION = "Satisfaction"

##  ligne 74 :

var city_data = {
	POPULATION: 0, # The population
	POPULATION_MAX: 0, # Max population
	SATISFACTION: 0,
}

##  ligne 159 :

    # update the population count and returns the difference
static func update_population():
	# Get the minimum of the constraints
	var tab = 	[PlayerData.city_data[POPULATION_MAX], 
				PlayerData.city_data[SATISFACTION]]

	# The new population value
	var population = tab.min()
	PlayerData.city_data[POPULATION] = population
	
	
## Dans formulaire.tscn:
##  créer un nouveau panel « Panel_choix_ville » avec ces paramètres :
Margin :
    Left : 287
    Top : 7
    Right : 735
    Bottom : 565
Rect :
    Position : x=287 y=7
    Size : x=448 y=558
##  Enregistrer le thème du « Panel_part2 » et l’appeler « formulaire1 ».
##  Charger ce thème sur Panel_choix_ville.
##  Créer un nœud enfant Label :
Lui appliquer ces paramètres, ainsi que la police « main_font.ttf » (res://assets/fonts/main_font.tres):
Margin :
    Left : 17
    Top : 33
    Right : 568
    Bottom : 78
Rect :
    Position : x=17.53 y=33.589
    Size : x=551 y=41
Scale : x=0.75 y=0.75
##  Enregistrer les thèmes utilisés sur le bouton bureau1 dans « themes » en tant que « box_normal », « box_pressed » et « box_hover ».
##  Créer trois nœuds boutons, enfants de Panel_choix_de_ville avec ces paramètres :
ville_1 :
    Position : x=41.53 y=67.589
    Size : x=369 y=137
ville_2 :
    Position : x=41.53 y=209.589
    Size : x=369 y=137
ville_3 :
    Position : x=41.53 y=357.589
    Size : x=369 y=137
Ne pas oublier de leur appliquer les thèmes précédemment enregistrés (box_normal, box_pressed et box_hover)
Ajouter à chaque bouton un nœud enfant Sprite pour y placer une image de chaque ville différente
Ajouter aux trois boutons un signal « pressed » pour formulaire.gd

##  Dupliquer return_panel_part2 et next_panel_part2 et les placer en tant que nœuds enfants de Panel_choisir_ville :
leur ajouter des signaux « pressed » pour formulaire.gd.

##  Dans le Panel_confirmation monter les catégories « nom » « sexe » « ville » pour laisser de la place. Dupliquer le panel « sprite_bureau » et le renommer « sprite_ville ». Lui donner un nouveau Custom Style → StyleBoxTexture et ne rien mettre dedans.

## player_data.gd :
##  ligne 98 :
var map = « not defined »

## formulaire.gd :
##  ligne 10 :
var ville = 0
##  ligne 195 :
aff = "part3"
		$Panel_part2.visible = false
		$Panel_choix_ville.visible = true
##  ligne 208 :
if aff == "part3":
		$Panel_alert.visible = false
		$Panel_choix_ville.visible = true
##  ligne 209 :
func _on_return_panel_confirmation_pressed():
	$Panel_confirmation.visible = false
	$Panel_choix_ville.visible = true
	return
## ligne 223 :
func _on_ville_1_pressed():
	ville = 1
	PlayerData.map = "map1"
	$Panel_confirmation/Sprite_ville.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/ville1.png")
	return


func _on_ville_2_pressed():
	ville = 2
	PlayerData.map = "map2"
	$Panel_confirmation/Sprite_ville.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/ville2.png")
	return


func _on_ville_3_pressed():
	ville = 3
	PlayerData.map = "map3"
	$Panel_confirmation/Sprite_ville.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/ville3.png")
	return


func _on_return_panel_part3_pressed():
	aff = "part2"
	$Panel_choix_ville.visible = false
	$Panel_part2.visible = true


func _on_next_panel_part3_pressed():
	if ville == 0:
		$Panel_choix_ville.visible = false
		$Panel_alert.visible = true
		print(ville)
		return
	else:
		$Panel_choix_ville.visible = false
		$Panel_confirmation.visible = true
		print(ville)
        
## Ne pas oublier de cacher les maps dans CityBuilder.tscn

## CityBuilder.gd :
##  ligne 13 :
onready var map_1 = $Map
onready var map_2 = $Map2
onready var map_3 = $Map3
##  ligne 71 :
    # the buildings Tilemap
onready var buildings_map = $Map/Buildings
onready var buildings_map2 = $Map2/Buildings
onready var buildings_map3 = $Map3/Buildings

##  ligne 104 :
func _ready():
	if PlayerData.map == "map1":
		map_1.show()
		if "AmenagementCyclable" in PlayerData.event_occured:
			$Map/Roads_cycles_and_bus.show()
			print("CYCLE")
		else:
			$Map/Roads_cycles_and_bus.hide()
			print("NO_CYCLE")
		$AnimationPlayer.play("ship")
		$AnimationPlayer2.play("Wave")
		$BirdAnimationPlayer.play("birds")
		get_incomes()
		if PlayerData.save_found == true:
			tuto_completed = true
		if tuto_completed == false:
			ui.close_tutorial()
		print(PlayerData.gender)
		$Map/Buildings/preview.hide()
		dialog_tuto.rect_position = Vector2(492, 280)
		$CanvasLayer/CityUI/Panel/TutorialCity.show()
		# Blocks the camera if there is a tutorial
		$Camera2D.block_camera(true)
	elif PlayerData.map == "map2":
		map_2.show()
		if "AmenagementCyclable" in PlayerData.event_occured:
			$Map/Roads_cycles_and_bus.show()
			print("CYCLE")
		else:
			$Map/Roads_cycles_and_bus.hide()
			print("NO_CYCLE")
		$AnimationPlayer.play("ship")
		$AnimationPlayer2.play("Wave")
		$BirdAnimationPlayer.play("birds")
		get_incomes()
		if PlayerData.save_found == true:
			tuto_completed = true
		if tuto_completed == false:
			ui.close_tutorial()
		print(PlayerData.gender)
		$Map2/Buildings/preview.hide()
		dialog_tuto.rect_position = Vector2(492, 280)
		$CanvasLayer/CityUI/Panel/TutorialCity.show()
		# Blocks the camera if there is a tutorial
		$Camera2D.block_camera(true)
	elif PlayerData.map == "map3":
		map_3.show()
		if "AmenagementCyclable" in PlayerData.event_occured:
			$Map/Roads_cycles_and_bus.show()
			print("CYCLE")
		else:
			$Map/Roads_cycles_and_bus.hide()
			print("NO_CYCLE")
		$AnimationPlayer.play("ship")
		$AnimationPlayer2.play("Wave")
		$BirdAnimationPlayer.play("birds")
		get_incomes()
		if PlayerData.save_found == true:
			tuto_completed = true
		if tuto_completed == false:
			ui.close_tutorial()
		print(PlayerData.gender)
		$Map3/Buildings/preview.hide()
		dialog_tuto.rect_position = Vector2(492, 280)
		$CanvasLayer/CityUI/Panel/TutorialCity.show()
		# Blocks the camera if there is a tutorial
		$Camera2D.block_camera(true)
##  ligne 165 :
if PlayerData.must_load_save:
		print ("Must load save")
		if load_save():
			if PlayerData.tuto_advancement == true:
				tuto_completed = true
			print(PlayerData.map)
			if PlayerData.map == "map1":
				$Map.show()
				$Map/Buildings/preview.hide()
					$AnimationPlayer.play("ship")
					$AnimationPlayer2.play("Wave")
					$BirdAnimationPlayer.play("birds")
			elif PlayerData.map == "map2":
				$Map2.show()
				$Map2/Buildings/preview.hide()
				$AnimationPlayer.play("ship")
					$AnimationPlayer2.play("Wave")
				$BirdAnimationPlayer.play("birds")
			elif PlayerData.map == "map3":
				$Map3,show()
				$Map3/Buildings/preview.hide()
				$AnimationPlayer.play("ship")
					$AnimationPlayer2.play("Wave")
				$BirdAnimationPlayer.play("birds")
			print("Save loaded !")
			# Hides the tutorial
			ui.close_tutorial()
			update_ui()

##  ligne 214 :
#Save the value of the occupied Tile
	if PlayerData.map == "map1":
		occupied_tile = buildings_map.tile_set.find_tile_by_name("Occupied")
		preview_tile = buildings_map.tile_set.find_tile_by_name("FantomBuilding")
	elif PlayerData.map == "map2":
		occupied_tile = buildings_map2.tile_set.find_tile_by_name("Occupied")
		preview_tile = buildings_map2.tile_set.find_tile_by_name("FantomBuilding")
	elif PlayerData.map == "map3":
		occupied_tile = buildings_map3.tile_set.find_tile_by_name("Occupied")
		preview_tile = buildings_map3.tile_set.find_tile_by_name("FantomBuilding")
##  ligne 278 :
func _physics_process(delta):
	if PlayerData.map == "map1":
		if state == State.CHOOSING_PLACE:
			check_preview(building_to_place, $Map/Buildings.tile)
	elif PlayerData.map == "map2":
		if state == State.CHOOSING_PLACE:
			check_preview(building_to_place, $Map2/Buildings.tile)
	elif PlayerData.map == "map3":
		if state == State.CHOOSING_PLACE:
			check_preview(building_to_place, $Map3/Buildings.tile)

##  ligne 302 :
if PlayerData.map == "map1":
				if buildings_map.get_cell(x,y) == 48:
					constructible = true
				else:
					#check if the others case are occupied.
					if buildings_map.get_cell(x, y) != TileMap.INVALID_CELL:
						occupied = true
			elif PlayerData.map == "map2":
				if buildings_map2.get_cell(x,y) == 48:
					constructible = true
				else:
				#check if the others case are occupied.
					if buildings_map2.get_cell(x, y) != TileMap.INVALID_CELL:
						occupied = true
			elif PlayerData.map == "map3":
				if buildings_map3.get_cell(x,y) == 48:
					constructible = true
				else:
				#check if the others case are occupied.
					if buildings_map3.get_cell(x, y) != TileMap.INVALID_CELL:
						occupied = true
##  ligne 325 :
if constructible && !occupied:
		if PlayerData.map == "map1":
			$Map/Buildings.can_place = true
		elif PlayerData.map == "map2":
			$Map2/Buildings.can_place = true
		elif PlayerData.map == "map3":
			$Map3/Buildings.can_place = true
	else:
		if PlayerData.map == "map1":
			$Map/Buildings.can_place = false
		elif PlayerData.map == "map2":
			$Map2/Buildings.can_place = false
		elif PlayerData.map == "map3":
			$Map3/Buildings.can_place = false
##  ligne 348 :
if PlayerData.map == "map1":
				$Map/Buildings/preview.position = case_center_coords
				$Map/Buildings.validation = true
			elif PlayerData.map == "map2":
				$Map2/Buildings/preview.position = case_center_coords
				$Map2/Buildings.validation = true
			elif PlayerData.map == "map3":
				$Map3/Buildings/preview.position = case_center_coords
				$Map3/Buildings.validation = true
			# Ask for validation
			ask_validation()
		else:
			if PlayerData.map == "map1":
				$Map/Buildings.can_place = false
			elif PlayerData.map == "map2":
				$Map2/Buildings.can_place = false
			elif PlayerData.map == "map3":
				$Map3/Buildings.can_place = false
##  ligne 378 :
if PlayerData.map == "map1":
				if buildings_map.get_cell(x,y) == 48:
					print("constructible map1")
					constructible = true
				else:
					if buildings_map.get_cell(x, y) != TileMap.INVALID_CELL:
						print("occupied map1")
						occupied = true
			elif PlayerData.map == "map2":
				if buildings_map2.get_cell(x,y) == 48:
					print("constructible map2")
					constructible = true
				else:
					if buildings_map2.get_cell(x, y) != TileMap.INVALID_CELL:
						print("occupied map2")
						occupied = true
			elif PlayerData.map == "map3":
				if buildings_map3.get_cell(x,y) == 48:
					print("constructible map3")
					constructible = true
				else:
					if buildings_map3.get_cell(x, y) != TileMap.INVALID_CELL:
						print("occupied map3")
						occupied = true
##  ligne 414 :
for x in range(pos.x, pos.x - size.x, - 1):
		for y in range(pos.y, pos.y + size.y, + 1):
			if PlayerData.map == "map1":
				buildings_map.set_cell(x, y, 1)
			elif PlayerData.map == "map2":
				buildings_map2.set_cell(x, y, 1)
			elif PlayerData.map == "map3":
				buildings_map3.set_cell(x, y, 1)
##  ligne 425 :
if PlayerData.map == "map1":
		buildings_map.set_cellv(pos, building)
	elif PlayerData.map == "map2":
		buildings_map2.set_cellv(pos, building)
	elif PlayerData.map == "map3":
		buildings_map3.set_cellv(pos, building)
##  ligne 528 :
state = State.STANDARD
		$Map/Buildings/preview.hide()
		$Map2/Buildings/preview.hide()
		$Map3/Buildings/preview.hide()
		if PlayerData.map == "map1":
			buildings_map.show_constructible_tile(false)
		if PlayerData.map == "map2":
			buildings_map2.show_constructible_tile(false)
		if PlayerData.map == "map1":
			buildings_map3.show_constructible_tile(false)
##  ligne 572 :
if PlayerData.map == "map1":
				building_to_place = buildings_map.tile_set.find_tile_by_name(building_name)
			elif PlayerData.map == "map2":
				building_to_place = buildings_map2.tile_set.find_tile_by_name(building_name)
			elif PlayerData.map == "map3":
				building_to_place = buildings_map3.tile_set.find_tile_by_name(building_name)
##  ligne 643 :
if PlayerData.map == "map1":
		buildings_map.validation = false
	if PlayerData.map == "map2":
		buildings_map2.validation = false
	if PlayerData.map == "map3":
		buildings_map3.validation = false
##  ligne 672 :
update_ui()
	if PlayerData.map == "map1":
		$Map/Buildings/preview.hide()
	elif PlayerData.map == "map2":
		$Map2/Buildings/preview.hide()
	elif PlayerData.map == "map3":
		$Map3/Buildings/preview.hide()
	state = State.STANDARD
	if PlayerData.map == "map1":
		buildings_map.show_constructible_tile(false)
	if PlayerData.map == "map2":
		buildings_map2.show_constructible_tile(false)
	if PlayerData.map == "map3":
		buildings_map3.show_constructible_tile(false)
##  ligne 803 :
var save_dict = {
			# Save data from PlayerData
			"building_list": PlayerData.building_list,
			"building_limit": PlayerData.building_limit,
			"bureau": PlayerData.bureau,
			"gender": PlayerData.gender,
			"event_occured": PlayerData.event_occured,
			"city_data": PlayerData.city_data,
			"data_points": PlayerData.data_points,
			"tuto_completed": tuto_completed,
			"city_name": PlayerData.city,
			"map": PlayerData.map,
			"player_incomes": PlayerData.incomes,
			# Currently waiting event
			"current_event": current_event,
			
			# Grid of buildings
			"buildings": buildings_map.save_string(),
			"buildings2": buildings_map2.save_string(),
			"buildings3": buildings_map3.save_string(),
		}

##  ligne 832 :
var keys = ["building_list","building_limit", "bureau","gender","event_occured",
	"city_data","data_points","city_name", "current_event","buildings","buildings2","buildings3","tuto_completed", "player_incomes"]
	
	# Check each key	
	for k in keys:
		if not k in dic.keys():
			return false
	# Try to load the buildings
	if PlayerData.map == "map1":
		if not buildings_map.load_string(dic["buildings"]):
			return false
	elif PlayerData.map == "map2":
		if not buildings_map2.load_string(dic["buildings2"]):
			return false
	elif PlayerData.map == "map3":
		if not buildings_map3.load_string(dic["buildings3"]):
			return false
			
	buildings_map.load_string(dic["buildings"])
	buildings_map2.load_string(dic["buildings2"])
	buildings_map3.load_string(dic["buildings3"])
		
	PlayerData.building_limit = dic["building_limit"]
	PlayerData.bureau = dic["bureau"]
	PlayerData.gender = dic["gender"]
	PlayerData.city = dic["city_name"]
	PlayerData.building_list = dic["building_list"]
	PlayerData.event_occured = dic["event_occured"]
	PlayerData.city_data = dic["city_data"]
	PlayerData.map = dic["map"]
	PlayerData.data_points = dic["data_points"]
	PlayerData.tuto_advancement = dic["tuto_completed"]
	PlayerData.incomes = dic["player_incomes"]
	
	current_event = dic["current_event"]
	print(PlayerData.map)
	return true
##  ligne 881 :
func update_preview():
	if PlayerData.map == "map1":
		buildings_map.show_constructible_tile(true)
		buildings_map.validation = false
	elif PlayerData.map == "map2":
		buildings_map2.show_constructible_tile(true)
		buildings_map2.validation = false
	elif PlayerData.map == "map3":
		buildings_map3.show_constructible_tile(true)
		buildings_map3.validation = false
	if PlayerData.map == "map1":
		$Map/Buildings/preview.show()
	elif PlayerData.map == "map2":
		$Map2/Buildings/preview.show()
	elif PlayerData.map == "map3":
		$Map3/Buildings/preview.show()
	buildings_map.set_preview_offset(building_name_to_place)
	buildings_map2.set_preview_offset(building_name_to_place)
	buildings_map3.set_preview_offset(building_name_to_place)
	if BuildingsData.SIZES[building_name_to_place] == Vector2(1,1):
		if PlayerData.map == "map1":
			$Map/Buildings/preview/preview_tile.show()
			$Map/Buildings/preview/preview_tile_2.hide()
			$Map/Buildings/preview/preview_tile_3.hide()
			$Map/Buildings/preview/preview_tile/building.show()
			$Map/Buildings/preview/preview_tile_2/building.hide()
			$Map/Buildings/preview/preview_tile_3/building.hide()
			$Map/Buildings/preview/preview_tile/building.texture = BuildingsData.TEXTURES[building_name_to_place]
		elif PlayerData.map == "map2":
			$Map2/Buildings/preview/preview_tile.show()
			$Map2/Buildings/preview/preview_tile_2.hide()
			$Map2/Buildings/preview/preview_tile_3.hide()
			$Map2/Buildings/preview/preview_tile/building.show()
			$Map2/Buildings/preview/preview_tile_2/building.hide()
			$Map2/Buildings/preview/preview_tile_3/building.hide()
			$Map2/Buildings/preview/preview_tile/building.texture = BuildingsData.TEXTURES[building_name_to_place]
		elif PlayerData.map == "map3":
			$Map3/Buildings/preview/preview_tile.show()
			$Map3/Buildings/preview/preview_tile_2.hide()
			$Map3/Buildings/preview/preview_tile_3.hide()
			$Map3/Buildings/preview/preview_tile/building.show()
			$Map3/Buildings/preview/preview_tile_2/building.hide()
			$Map3/Buildings/preview/preview_tile_3/building.hide()
			$Map3/Buildings/preview/preview_tile/building.texture = BuildingsData.TEXTURES[building_name_to_place]
	if BuildingsData.SIZES[building_name_to_place]  == Vector2(2,2):
		if PlayerData.map == "map1":
			$Map/Buildings/preview/preview_tile.hide()
			$Map/Buildings/preview/preview_tile_2.show()
			$Map/Buildings/preview/preview_tile_3.hide()
			$Map/Buildings/preview/preview_tile/building.hide()
			$Map/Buildings/preview/preview_tile_2/building.show()
			$Map/Buildings/preview/preview_tile_3/building.hide()
			$Map/Buildings/preview/preview_tile_2/building.texture = BuildingsData.TEXTURES[building_name_to_place]
		elif PlayerData.map == "map2":
			$Map2/Buildings/preview/preview_tile.hide()
			$Map2/Buildings/preview/preview_tile_2.show()
			$Map2/Buildings/preview/preview_tile_3.hide()
			$Map2/Buildings/preview/preview_tile/building.hide()
			$Map2/Buildings/preview/preview_tile_2/building.show()
			$Map2/Buildings/preview/preview_tile_3/building.hide()
			$Map2/Buildings/preview/preview_tile_2/building.texture = BuildingsData.TEXTURES[building_name_to_place]
		elif PlayerData.map == "map3":
			$Map3/Buildings/preview/preview_tile.hide()
			$Map3/Buildings/preview/preview_tile_2.show()
            $Map3/Buildings/preview/preview_tile_3.hide()
			$Map3/Buildings/preview/preview_tile/building.hide()
			$Map3/Buildings/preview/preview_tile_2/building.show()
			$Map3/Buildings/preview/preview_tile_3/building.hide()
			$Map3/Buildings/preview/preview_tile_2/building.texture = BuildingsData.TEXTURES[building_name_to_place]
	if BuildingsData.SIZES[building_name_to_place] == Vector2(3,3):
		if PlayerData.map == "map1":
			$Map/Buildings/preview/preview_tile.hide()
			$Map/Buildings/preview/preview_tile_2.hide()
			$Map/Buildings/preview/preview_tile_3.show()
			$Map/Buildings/preview/preview_tile/building.hide()
			$Map/Buildings/preview/preview_tile_2/building.hide()
			$Map/Buildings/preview/preview_tile_3/building.show()
			$Map/Buildings/preview/preview_tile_3/building.texture = BuildingsData.TEXTURES[building_name_to_place]
		elif PlayerData.map == "map2":
			$Map2/Buildings/preview/preview_tile.hide()
			$Map2/Buildings/preview/preview_tile_2.hide()
			$Map2/Buildings/preview/preview_tile_3.show()
			$Map2/Buildings/preview/preview_tile/building.hide()
			$Map2/Buildings/preview/preview_tile_2/building.hide()
			$Map2/Buildings/preview/preview_tile_3/building.show()
			$Map2/Buildings/preview/preview_tile_3/building.texture = BuildingsData.TEXTURES[building_name_to_place]
		elif PlayerData.map == "map3":
			$Map3/Buildings/preview/preview_tile.hide()
			$Map3/Buildings/preview/preview_tile_2.hide()
			$Map3/Buildings/preview/preview_tile_3.show()
			$Map3/Buildings/preview/preview_tile/building.hide()
			$Map3/Buildings/preview/preview_tile_2/building.hide()
			$Map3/Buildings/preview/preview_tile_3/building.show()
			$Map3/Buildings/preview/preview_tile_3/building.texture = BuildingsData.TEXTURES[building_name_to_place]

			
### Pour mettre les dialogues en gras, il faut d'abord aller dans DialogScene.tscn :
Cocher la case Bold Font et y mettre la police « main_button » (res://assets/fonts/font_infos.tres)
Changer les paramètres.
Font Data =  res://assets/fonts/main_font.ttf

## Dans Whiskers, mettre [b]texte[/b] autour du texte que l’on veut mettre en gras.

## Dans DialogScene.gd, ligne 198 :
    # Set the dialog line on the UI (if not a data block)
if not is_data_block():
		dialog_line.bbcode_text = block.text
		
		
## Pour changer les Data Points en monnaie, il faut d'abord aller dans buildings_data.gd :
##  ligne 6 :
const POPULATION = "Population"
const POPULATION_MAX = "Population max"
const SATISFACTION = "Satisfaction"
const PRIX = "Prix"
##  ligne 134 :

const PRIX = {
	"Complexe Sportif": 50,
	"Office de tourisme": 30,
	"Etablissement de santé": 20,
	"Maison 1": 10,
	"Grande maison": 100,
	"Maison 3": 10,
	"Immeuble": 50,
	"Mairie": 0,
	"Supérette":50,
	"Grand Cafe": 20,
	"Commissariat": 10,
	"Grande Ecole": 10,
	"Grand Commissariat": 15,
	"Grand Hôpital": 15,
	"Hopital": 10,
	"Musee": 20,
	"Parc": 5,
	"Supermarché": 200,
	"Ecole": 5,
	"Theatre": 10,
	"Centre Associatif": 150,
	"Caserne": 30,
	"Déchetterie": 30
	
}




## Dans CityBuilder.gd :
##  ligne 159 :
    # update the population count and returns the difference
static func update_population():
	# Get the minimum of the constraints
	var tab = 	[PlayerData.city_data[POPULATION_MAX], 
				PlayerData.city_data[SATISFACTION]]
#				PlayerData.city_data[PRIX]]
##  ligne 430 :
func _on_BuildMenu_selected_building(building_name):
	if tuto_completed == true or can_use == "building_button" or can_use == "select_building" or can_use == "pose_building":
		if can_use == "select_building":
			listen_state_data()
			
		if PlayerData.data_points - BuildingsData.PRIX[building_name] < 0:
			open_no_datapoints()
		else:
		# Save the building
			building_name_to_place = building_name
			building_to_place = buildings_map.tile_set.find_tile_by_name(building_name)

## Dans BuildingButton.gd :
##  ligne 72 :
func set_building_prix(building : String):
	var prix = BuildingsData.get_buildings_price(building)
	$Building/Prix.text = str("Prix: ", + BuildingsData.PRIX[building], " Datapoints")



## Dans player_data.gd :
##  ligne 84 :
    # Data points accumulated
var data_points = 300



## Fenêtre pop-up :

Nouvelle scène → nom : pas_datapoints → type : MarginContainer

Margin Container = PasDatapoints → Mouse → Filter : Ignore
	→ NinePatchRect = Background (Texture = assets/ui/dialogs/bg_construire.png)
        → Button (Copier-coller de la scene tutorial_city)
			→ créer un nœud
            →Créer un nœud enfant de PasDatapoints VboxContainer « MainContainer »
		      → Créer un label
        → Créer un nœud enfant de « MainContainer » MarginContainer appelé 					« ScrollMargin »
        	→ Créer un nœud enfant VboxContainer
				→ Créer un nœud enfant MarginContainer
                    → Noeud enfant RichTextLabel "Vous n'avez pas assez de Data Points !" couleur du texte : 441d00
                    
## Pour le bug qui affiche juste "Texte" quand la fenêtre du jeu est agrandie, il suffit de retirer le texte du Bb Code de DialogScene.tscn. Rien ne va s’afficher sur la scène mais une fois dans le jeu, le problème est réglé.

## Pour changer le délai entre les dialogues, il faut aller dans DialogScene.gd et changer les constantes des délais (ligne 43 et 50)
    # Display delay, to prevent the answers from popping too fast
const DELAY_BEFORE_DISPLAY = 0.75
onready var timer_display = $TimerDisplay


    # Answer delay, to prevent clicking to fast on the buttons
const DELAY_BEFORE_ANSWER = 0.75
var answer_delay = 0.0

## Pour éviter de passer trop vite du moment où on choisit un bâtiment au moment où on le place, ce qui peut placer le bâtiment à l’endroit du clic (pour choisir ou annuler la construction) :
##  Dans CityBuilder.gd, changer le timer ligne 457 :
yield(get_tree().create_timer(0.3), "timeout") # Delay


## Pour changer la case sélectionnée lors du placement :
##  CityBuilder.gd, ligne 241 :
func map_clicked(case_index, case_center_coords, _occupied):
	# If Choosing the place
	if state == State.CHOOSING_PLACE:
		if can_place(building_to_place, case_index):
			# Save the location
			building_case = case_index
			build_case_center = case_center_coords
			$Map/Buildings/preview.position = case_center_coords
			$Map/Buildings.validation = true
			# Ask for validation
			ask_validation()
		else:
			$Map/Buildings.can_place = false
