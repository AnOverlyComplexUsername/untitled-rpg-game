@tool
extends Control
@onready var item_type = $VBoxContainer/ItemType
@onready var name_text_edit = $VBoxContainer/NameTextEdit
@onready var desc_text_edit = $VBoxContainer/DescTextEdit
@onready var health_text_edit = $VBoxContainer/HealthTextEdit
@onready var dodge_text_edit = $VBoxContainer/DodgeTextEdit
@onready var damage_text_edit = $VBoxContainer/DamageTextEdit
@onready var accuracy_text_edit = $VBoxContainer/AccuracyTextEdit
@onready var create_button = $VBoxContainer/CreateButton
@onready var equipment_type = $VBoxContainer/EquipmentType
@onready var inv_icon = $"Inv Icon"
@onready var inv_icon_Customizer = $InvIconCustomizer
@onready var battle_icon = $"Battle Icon"
@onready var battle_sprite_customizer = $BattleSpriteCustomizer

var editingEquipment : bool  = false
var editingArms : bool = false
##Sends signal of all the attributes for an item
signal create_new(itemName : String, desc, health, dodge, damage, 
accuracy, itemType, equipmentType, invIcon, combatIcon)

signal customize_icon(texture)
func _ready():
	pass

##Checks if all necessary fields are filled to create
##It works i think don't look into it too deeply 
func _process(_delta):
	if name_text_edit.text != "" and desc_text_edit.text != "":
		if editingEquipment:
				if health_text_edit.text != "" and dodge_text_edit.text != "" and equipment_type.get_selected_id() != -1:
					if !editingArms:
						create_button.disabled = false
					elif damage_text_edit.text != "" and accuracy_text_edit.text != "":
						create_button.disabled = false
				else:
					create_button.disabled = true		
	
		else:
			create_button.disabled = false
	else:
		create_button.disabled = true
func _hide_ui():
	equipment_type.hide()
	health_text_edit.hide() 
	dodge_text_edit.hide()
	damage_text_edit.hide() 
	accuracy_text_edit.hide()
	
func _on_item_type_item_selected(index):
	name_text_edit.show()
	desc_text_edit.show()
	match index:
		0: #Key Item
			_hide_ui()
			editingEquipment = false
			battle_sprite_customizer.visible = false
			battle_icon.visible = false
			
		1: #Equipment
			print('buh')
			equipment_type.show()
			health_text_edit.show() 
			dodge_text_edit.show()
			battle_sprite_customizer.visible = true
			battle_icon.visible = true
			editingEquipment = true



func _on_equipment_type_item_selected(index):
	if index > 2:
		damage_text_edit.show() 
		accuracy_text_edit.show()
		editingArms = true
	else:
		editingArms = false
		damage_text_edit.hide() 
		accuracy_text_edit.hide()


func _on_create_button_pressed():
	var itemName : String = name_text_edit.text
	var desc : String= desc_text_edit.text
	var health : int = int(health_text_edit.text)
	var dodge : float = float(dodge_text_edit.text)
	var damage : int  = int(damage_text_edit.text)
	var accuracy : float = float(accuracy_text_edit.text)
	var itemType : AbstractItem.ItemType = item_type.get_selected_id()
	var equipmentType : AbstractEquipment.EquipmentType = equipment_type.get_selected_id()
	var invIcon : Texture = inv_icon.texture
	var combatIcon : Texture = battle_icon.texture
	create_new.emit(itemName,desc,health,dodge,damage,accuracy,itemType,equipmentType, invIcon, combatIcon)


func _on_inv_icon_customizer_pressed():
	customize_icon.emit(inv_icon)


func _on_battle_sprite_customizer_pressed():
	customize_icon.emit(battle_icon)
