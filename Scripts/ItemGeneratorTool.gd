@tool 
class_name ItemGeneratorTool
extends EditorScript

var window : Window
var gui := preload("uid://citubjepbscdo")
var ITEM_PATH := "res://Resources/Items/"
var EQUIPMENT_PATH := "res://Resources/Items/Equipment/"
var txtrReference : TextureRect #reference to texture display being changed in UI
func _run():
	window = Window.new()
	EditorInterface.popup_dialog(window, Rect2(Vector2(100,100), Vector2(1200,720)))
	
	var gui_scene := gui.instantiate()
	window.add_child(gui_scene)
	
	gui_scene.create_new.connect(_try_create_equipment_resource)
	gui_scene.customize_icon.connect(_set_new_inv_sprite)
	
	window.close_requested.connect(func():
		window.queue_free()
		)


@warning_ignore("int_as_enum_without_cast")
@warning_ignore("int_as_enum_without_match")
##Creates a new resource for equipment or key items; consumables not yet implemented
func  _try_create_equipment_resource(
	iName : String = "", desc: String = "", 
	health : int = 5, dodge : float = 0.0, 
	damage : int = 5, accuracy : float = 1.0,
	itemType : AbstractItem.ItemType = -1, 
	equipmentType : AbstractEquipment.EquipmentType = -1,
	invIcon : Texture = null, battleIcon : Texture = null
) -> bool:
	if(FileAccess.file_exists(ITEM_PATH + "/" + iName + ".tres") or 
	FileAccess.file_exists(EQUIPMENT_PATH + "/" + iName + ".tres")):
		return false
	var resource
	var dupe
	print(iName)
	if itemType == 0:
		resource = ResourceLoader.load(ITEM_PATH + "/test_item.tres")
		dupe = resource.duplicate(true) as KeyItem

	elif itemType == 1:
		if equipmentType == 3 or equipmentType == 4:
			resource = ResourceLoader.load(EQUIPMENT_PATH + "/TestArmL.tres")
			dupe = resource.duplicate(true) as ArmEquipment
			dupe.accuracy = accuracy
			dupe.damage = damage 

		else:
			resource = ResourceLoader.load(EQUIPMENT_PATH + "/testTorso.tres")
			dupe = resource.duplicate(true) as Equipment
		dupe.combatIcon = battleIcon

		
		dupe.ItemIcon = invIcon
		dupe.health = health
		dupe.hitPercent = dodge
		dupe.equipType = equipmentType
		
	if dupe == null:
		return false
		
	dupe.ItemName = iName
	dupe.ItemDescription = desc
	dupe.type = itemType + 1
	
	
	if itemType == 0:
		ResourceSaver.save(dupe, ITEM_PATH+ "/" + iName + ".tres")
	elif itemType == 1:
		ResourceSaver.save(dupe, EQUIPMENT_PATH+ "/" + iName + ".tres")
	
	
	return true

func _set_new_inv_sprite(txtr : TextureRect) -> void:
	var file := EditorFileDialog.new()
	file.title = "Select new inv sprite"
	file.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file.access = EditorFileDialog.ACCESS_FILESYSTEM
	file.display_mode = EditorFileDialog.DISPLAY_THUMBNAILS
	file.add_filter("*.png, *.jpg, *.jpeg", "Imagses")
	window.add_child(file)
	file.popup_centered(Vector2i(1200,700))
	txtrReference = txtr
	file.file_selected.connect(set_texture)
	
	
	

func set_texture(path : String) -> void:
	var ext = path.get_extension()
	if  ext == "png" or ext == "jpg" or ext == "jpeg": #validates file
		var image = Image.new()
		image.load(path)
		var texture = ImageTexture.new()
		texture.set_image(image)
		txtrReference.texture = texture
	else:
		push_error("Wrong file format! Please pick an image!!")
	
	
	
	
	
