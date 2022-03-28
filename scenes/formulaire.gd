extends Control


var gender = "not defined" # Retient le sexe choisi par le joueur.
var nom = "not defined" # Retient le nom choisi par le joueur.
var nom_ville = "not defined" # Retient le nom de la ville choisi par le joueur.
var bureau = 0 # Retient qu'elle bureau le joueur à choisi.
var aff = "nowhere" # Définit verre qu'elle partie du questionnaire, le message d'érreur doit revenir.
# Called when the node enters the scene tree for the first time.

func _ready():
	aff = "part1"
	print("gender: " + gender)
	print("nom: " + nom)
	print("nom_ville: " + nom_ville)
	$Panel_part1/label/nom.set_virtual_keyboard_enabled(true)
	$Panel_part1/label3/nom_ville.set_virtual_keyboard_enabled(true)
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_def_femme_pressed():
	#Select Gender woman
	if gender == "not defined":
		gender = "woman"
		PlayerData.gender = true
		print("gender: " + gender)
		$Panel_part1/def_femme.modulate = Color(0,1,1,1)
		$Panel_confirmation/sexe.set_text("Sexe: F")
		return
	
	if gender == "man":
		gender = "woman"
		PlayerData.gender = true
		print("gender: " + gender)
		$Panel_part1/def_femme.modulate = Color(0,1,1,1)
		$Panel_part1/def_homme.modulate = Color(1,1,1,1)
		$Panel_confirmation/sexe.set_text("Sexe: F")
		return


func _on_def_homme_pressed():
	#Select Gender man
	if gender == "not defined":
		gender = "man"
		PlayerData.gender = false
		print("gender: " + gender)
		$Panel_part1/def_homme.modulate = Color(0,1,1,1)
		$Panel_confirmation/sexe.set_text("Sexe: M")
		return
	
	if gender == "woman":
		gender = "man"
		PlayerData.gender = false
		print("gender: " + gender)
		$Panel_part1/def_homme.modulate = Color(0,1,1,1)
		$Panel_part1/def_femme.modulate = Color(1,1,1,1)
		$Panel_confirmation/sexe.set_text("Sexe: M")
		return

func _on_next_pressed():
	nom_ville = $Panel_part1/label3/nom_ville.text
	$Panel_confirmation/ville.set_text("Ville: " + nom_ville)
	PlayerData.city = nom_ville
	print("nom: " + nom)
	nom = $Panel_part1/label/nom.text
	print("nom: " + nom)
	$Panel_confirmation/nom.set_text("Nom: " + nom)
	#Check if all field are filled
	if nom == "not defined" or nom_ville == "not defined" or gender == "not defined":
		$Panel_part1.visible = false
		$Panel_alert.visible = true
		return
	if nom == "" or nom_ville == "" or gender == "":
		$Panel_part1.visible = false
		$Panel_alert.visible = true
		return
	else:
		aff = "part2"
		$Panel_part1.visible =false
		$Panel_part2.visible = true
		return

func _on_bureau1_pressed():
	if bureau == 0:
		bureau = 1
		$Panel_part2/bureau2/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_part2/bureau3/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_confirmation/Sprite_bureau.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_1.png")
		$background.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_1.png")
		PlayerData.bureau = "bureau_1.png"
		return
		
	if bureau == 2:
		bureau = 1
		$Panel_part2/bureau1/Sprite.modulate = Color(1,1,1,1)
		$Panel_part2/bureau2/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_part2/bureau3/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_confirmation/Sprite_bureau.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_1.png")
		$background.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_1.png")
		PlayerData.bureau = "bureau_1.png"
		return
		
	if bureau == 3:
		bureau = 1
		$Panel_part2/bureau1/Sprite.modulate = Color(1,1,1,1)
		$Panel_part2/bureau2/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_part2/bureau3/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_confirmation/Sprite_bureau.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_1.png")
		$background.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_1.png")
		PlayerData.bureau = "bureau_1.png"
		return


func _on_bureau2_pressed():
	if bureau == 0:
		bureau = 2
		$Panel_part2/bureau1/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_part2/bureau3/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_confirmation/Sprite_bureau.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_2.png")
		$background.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_2.png")
		PlayerData.bureau = "bureau_2.png"
		return
		
	if bureau == 1:
		bureau = 2
		$Panel_part2/bureau2/Sprite.modulate = Color(1,1,1,1)
		$Panel_part2/bureau1/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_part2/bureau3/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_confirmation/Sprite_bureau.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_2.png")
		$background.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_2.png")
		PlayerData.bureau = "bureau_2.png"
		return
		
	if bureau == 3:
		bureau = 2
		$Panel_part2/bureau2/Sprite.modulate = Color(1,1,1,1)
		$Panel_part2/bureau1/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_part2/bureau3/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_confirmation/Sprite_bureau.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_2.png")
		$background.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_2.png")
		PlayerData.bureau = "bureau_2.png"
		return


func _on_bureau3_pressed():
	if bureau == 0:
		bureau = 3
		$Panel_part2/bureau1/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_part2/bureau2/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_confirmation/Sprite_bureau.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_3.png")
		$background.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_3.png")
		PlayerData.bureau = "bureau_3.png"
		return
		
	if bureau == 1:
		bureau = 3
		$Panel_part2/bureau3/Sprite.modulate = Color(1,1,1,1)
		$Panel_part2/bureau1/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_part2/bureau2/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_confirmation/Sprite_bureau.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_3.png")
		$background.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_3.png")
		PlayerData.bureau = "bureau_3.png"
		return
		
	if bureau == 2:
		bureau = 3
		$Panel_part2/bureau3/Sprite.modulate = Color(1,1,1,1)
		$Panel_part2/bureau1/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_part2/bureau2/Sprite.modulate = Color(1,1,1,0.25)
		$Panel_confirmation/Sprite_bureau.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_3.png")
		$background.get_stylebox("panel", "").texture = preload("res://assets/sprites/backgrounds/bureau_3.png")
		PlayerData.bureau = "bureau_3.png"
		return


func _on_return_panel_part2_pressed():
	aff = "part1"
	$Panel_part2.visible = false
	$Panel_part1.visible = true
	return


func _on_next_panel_part2_pressed():
	if bureau == 0:
		$Panel_part2.visible = false
		$Panel_alert.visible = true
		return
	else:
		$Panel_part2.visible = false
		$Panel_confirmation.visible = true
		return


func _on_return_panel_alert_pressed():
	if aff == "part1":
		$Panel_alert.visible = false
		$Panel_part1.visible = true
		return
	if aff == "part2":
		$Panel_alert.visible = false
		$Panel_part2.visible = true


func _on_return_panel_confirmation_pressed():
	$Panel_confirmation.visible = false
	$Panel_part2.visible = true
	return


func _on_confirmer_pressed():
	#skip intro***
#	get_tree().change_scene("res://scenes/CityBuilder.tscn")
	#***
	get_parent().start_next_state()
	return
