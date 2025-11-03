extends Control

class_name InventorySlot

@export var assignedItem : AbstractItem
@onready var itemIcon : TextureRect = $SelectButton/TextureRect
@onready var itemNameLabel : Label = $SelectButton/NameLabel
##Hidden on default for one off items like key items
@onready var itemCountLabel : Label = $ItemCountLabel 
static var scene : PackedScene = preload("uid://cxmshvgolrcc3")
var numOfItem : int = 0

signal select(item : AbstractItem)

##Creates a new inventory slot with a given item and # of that item 
static func NewInventorySlot(item : AbstractItem, n : int = 0) -> InventorySlot:
	var new : InventorySlot = scene.instantiate() 
	new.assignedItem = item
	new.numOfItem = n
	return new


func _ready():
	itemCountLabel.hide()
	itemNameLabel.text = assignedItem.get_item_name()
	itemIcon.texture = assignedItem.get_item_icon()
	if assignedItem.get_item_type() == AbstractItem.ItemType.CONSUMABLE_ITEM:
		itemCountLabel.show()
	update_item_counter()

func update_item_counter() -> void:
	itemCountLabel.text = "x" + str(numOfItem)
	itemCountLabel.show()
	

##Adds an addition number of item to the stack; for stackable items
func add_item_to_stack(i : int) -> void:
	numOfItem += i
	update_item_counter()

##Sets the item slot's number of items to given argument	
func set_item_stack(i : int) -> void:
	numOfItem = i
	update_item_counter()


func get_item_name() -> String:
	return assignedItem.get_item_name()

func get_item_description() -> String:
	return assignedItem.get_item_description()


func _on_select_button_pressed():
	emit_signal("select", assignedItem)
