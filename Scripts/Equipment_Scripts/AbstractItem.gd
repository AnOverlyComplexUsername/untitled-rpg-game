@abstract

extends Resource
class_name AbstractItem
##All items in the inventory will inhereit AbstractItem 

enum ItemType {
	CONSUMABLE_ITEM, ##Item that the player can  use
	KEY_ITEM, ##Item that is key for progression
	EQUIPMENT_ITEM ##Item that the player can equip
	}
	
@export_category("Item Descriptors")
##Icon that will be displayed in inventory
@export var ItemIcon : Texture 

##Name of Item 
@export var ItemName : String 

##Desc of Item
@export_multiline var ItemDescription : String

##Used for item sorting in inventory
@export var type : ItemType = ItemType.CONSUMABLE_ITEM

func get_item_name() -> String:
	return ItemName
	
func get_item_icon() -> Texture:
	return ItemIcon
	
func get_item_description() -> String:
	return ItemDescription

func get_item_type() -> ItemType:
	return type
