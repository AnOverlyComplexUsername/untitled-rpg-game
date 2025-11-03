extends Control
##Will manage how inventory will be displayed in UI
class_name InventoryManager

@export_category("UI Elements")
@export var keyItemContainer : VBoxContainer
@export var consumableItemContainer : VBoxContainer
@export var equipableItemContainer : VBoxContainer
@export var descriptionText : RichTextLabel
var UIElements : Array[Control]
var addedItemSlots : Dictionary[AbstractItem, InventorySlot]

func _ready():
	Global.inventory_manager = self
	load_inventory()
	self.hide()
	
	
##Loads inventory and creates item slots according to game manager inventory
func load_inventory() -> void:
	for item : AbstractItem in Global.game_manager.inventory:
		add_slot(item)

##Adds one new slot for an item
func add_slot(item : AbstractItem) -> void:
	if !Global.game_manager.inventory.has(item): ##Breaks if item isn't valid in player's inventory
		return
	var newSlot = InventorySlot.NewInventorySlot(item,
	Global.game_manager.inventory.get(item))
	addedItemSlots[item] = newSlot
	match item.get_item_type():
		item.ItemType.CONSUMABLE_ITEM:
			consumableItemContainer.add_child(newSlot)
		item.ItemType.KEY_ITEM:
			keyItemContainer.add_child(newSlot)
		item.ItemType.EQUIPMENT_ITEM:
			equipableItemContainer.add_child(newSlot)
	newSlot.select.connect(update_description)
	
	
##Update item counter
func update_slot(item : AbstractItem, n : int) -> void:
	var slot := addedItemSlots[item]
	slot.add_item_to_stack(n)
	
func update_description(selectedItem : AbstractItem) -> void:
	descriptionText.text = selectedItem.get_item_description()

##Deletes all inventory slots in the inventory UI 
func reset_inventory() -> void:
	pass
	
	
func _process(_delta): 
	if Input.is_action_just_pressed("inventory"):
		self.visible = !self.visible
