extends Control
##Will manage how inventory will be displayed in UI
class_name InventoryManager

@export_category("UI Elements")
@export var keyItemContainer : VBoxContainer
@export var consumableItemContainer : VBoxContainer
@export var equipableItemContainer : VBoxContainer
@export var descriptionText : RichTextLabel
@export_group("equipment slots")
@export var headEquip : Equip_Slot
@export var torsoEquip : Equip_Slot
@export var armLEquip : Equip_Slot
@export var armREquip : Equip_Slot
@export var legsEquip : Equip_Slot


var UIElements : Array[Control]
var addedItemSlots : Dictionary[AbstractItem, InventorySlot]
var enabled : bool = true 

func _ready():
	Global.inventory_manager = self
	load_inventory()
	self.hide()
	
	
##Loads inventory and creates item slots according to game manager inventory
func load_inventory() -> void:
	if !Global.game_manager.inventory.is_empty():
		for item : AbstractItem in Global.game_manager.inventory:
			add_slot(item)
	
	#this code is awful :(
	if !Global.game_manager.equippedItems.is_empty():
		for type : AbstractEquipment.EquipmentType in Global.game_manager.equippedItems:
			match type:
				AbstractEquipment.EquipmentType.EYES:
					headEquip.set_equipment(Global.game_manager.equippedItems.get(type))
				AbstractEquipment.EquipmentType.TORSO:
					torsoEquip.set_equipment(Global.game_manager.equippedItems.get(type))
				AbstractEquipment.EquipmentType.LEGS:
					legsEquip.set_equipment(Global.game_manager.equippedItems.get(type))
				AbstractEquipment.EquipmentType.ARM_L:
					armLEquip.set_equipment(Global.game_manager.equippedItems.get(type))
				AbstractEquipment.EquipmentType.ARM_R:
					armREquip.set_equipment(Global.game_manager.equippedItems.get(type))
			headEquip.update_equip_display()
			torsoEquip.update_equip_display()
			legsEquip.update_equip_display()
			armLEquip.update_equip_display()
			armREquip.update_equip_display()

				

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

##Disables ability to open inventory
func disable_inventory() -> void:
	enabled = false
	self.hide()

##Enables ability to open inventory 
func enable_inventory() -> void:
	enabled = true
	
func _process(_delta): 
	if enabled and Input.is_action_just_pressed("inventory"):
		self.visible = !self.visible
