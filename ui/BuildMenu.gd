extends MarginContainer
class_name BuildMenu

signal exited_build_menu
signal selected_building(building_name)

onready var building_container = $background/MarginContainer/ScrollContainer/building_container

onready var admin = $background/FilterContainer/GridContainer/admin
onready var assosiatif = $background/FilterContainer/GridContainer/assosiatif
onready var commercial = $background/FilterContainer/GridContainer/commercial
onready var habitation = $background/FilterContainer/GridContainer/habitation
onready var loisir = $background/FilterContainer/GridContainer/loisir
onready var sante = $background/FilterContainer/GridContainer/sante

var building_button = preload("res://ui/building_button.tscn")


func scrolling(value):
	$background/MarginContainer/ScrollContainer.scroll_vertical_enabled = value
	print($background/MarginContainer/ScrollContainer.scroll_vertical_enabled)


func hide():
	# Remove each building button
	for child in building_container.get_children():
		building_container.remove_child(child)
	
	.hide()


func add_building(building_name: String, left: int):
	var button = building_button.instance()
	button.set_building(building_name, left)
	# Add as a child
	building_container.add_child(button)
	
	# Connect
	# The button will send this 4th parameter whenever it is pressed
	button.connect("selected_building", self, "_on_selected_building", [building_name])


func modulate_all(selected):
	admin.modulate = Color( 1, 1, 1, 1 )
	assosiatif.modulate = Color( 1, 1, 1, 1 )
	commercial.modulate = Color( 1, 1, 1, 1 )
	habitation.modulate = Color( 1, 1, 1, 1 )
	loisir.modulate = Color( 1, 1, 1, 1 )
	sante.modulate = Color( 1, 1, 1, 1 )
	
	if selected != null:
		selected.modulate = Color("ff9b1a")


func _on_loisir_pressed():
	# Remove each building button
	for child in building_container.get_children():
		building_container.remove_child(child)
	
	for building in PlayerData.building_list:
		if building in BuildingsData.LOISIR:
			add_building(building, PlayerData.building_list[building])
	
	modulate_all(loisir)


func _on_admin_pressed():
	# Remove each building button
	for child in building_container.get_children():
		building_container.remove_child(child)
	
	for building in PlayerData.building_list:
		if building in BuildingsData.ADMIN:
			add_building(building, PlayerData.building_list[building])
	
	modulate_all(admin)


func _on_assosiatif_pressed():
	# Remove each building button
	for child in building_container.get_children():
		building_container.remove_child(child)
	
	for building in PlayerData.building_list:
		if building in BuildingsData.ASSOCIATIF:
			add_building(building, PlayerData.building_list[building])
	
	modulate_all(assosiatif)


func _on_commercial_pressed():
	# Remove each building button
	for child in building_container.get_children():
		building_container.remove_child(child)
	
	for building in PlayerData.building_list:
		if building in BuildingsData.COMMERCIAL:
			add_building(building, PlayerData.building_list[building])
	
	modulate_all(commercial)


func _on_habitation_pressed():
	# Remove each building button
	for child in building_container.get_children():
		building_container.remove_child(child)
	
	for building in PlayerData.building_list:
		if building in BuildingsData.HABITATION:
			add_building(building, PlayerData.building_list[building])
	
	modulate_all(habitation)


func _on_sante_pressed():
	# Remove each building button
	for child in building_container.get_children():
		building_container.remove_child(child)
	
	for building in PlayerData.building_list:
		if building in BuildingsData.SANTE:
			add_building(building, PlayerData.building_list[building])
	
	modulate_all(sante)


func _on_selected_building(building_name):
	emit_signal("selected_building", building_name)


func _on_QuitButton_pressed():
	emit_signal("exited_build_menu")
