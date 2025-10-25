extends AttackingLimb

##Player limb
class_name PlayerLimb

##Transparent when not selected for an action
var unselectedPlayerLimbColor = Color(1.0, 1.0, 1.0, 0.486)

##Not transparent when selected
var selectedPlayerLimbColor = Color(1.0, 1.0, 1.0, 1.0) 

var target : Limb = null
var actionable : bool = true

func _ready():
	super._ready()
	enable_transparency()
	
func target_limb(l : Limb) -> void:
	target = l

func attack(limb : AbstractLimbEntity) -> void:
	if actionable:
		super.attack(limb)

func enable_transparency() -> void:
	self.use_parent_material = true
	self.modulate = unselectedPlayerLimbColor

func disable_transparency() -> void:
	self.use_parent_material = false
	self.modulate = selectedPlayerLimbColor


func mouse_hover(): ##What happens when mouse hovers over attackable limb:
	if targettable and !Global.battle_manager.allowEnemyLimbSelection:
		if selected: 
			self.get_material().set_shader_parameter("color", selectedColor)
		else:
			self.get_material().set_shader_parameter("color", hoverColor)
		Global.battle_manager.set_hovered_limb(self)
		disable_transparency()

func mouse_leave(): ##What happens when mouse leaves attackable limb area:
	if Global.battle_manager.get_selected_player_limb() != self:
		super.mouse_leave()
		enable_transparency()

func on_hit(): ##What happens when limb is hit and takes damage
	pass

func select():
	disable_transparency()
	super.select()

func deselect():
	enable_transparency()
	super.deselect()

func on_death(_l : AbstractLimbEntity) -> void:
	pass
