extends AbstractLimbEntity

##A basic limb implementation of AbstractLimb
class_name Limb

var selected : bool = false
var selectedColor : Color = Color("ffffffff")
var deselectedColor : Color = Color("ffffff00")
var hoverColor : Color = Color("ffffff60")
var hitColor : Color =  Color("ff0034ff")
func on_death(_l : AbstractLimbEntity) -> void:
	self.queue_free()

func on_hit():
	pass

func mouse_hover() -> void:
	if targettable and Global.battle_manager.allowEnemyLimbSelection:
		if selected: 
			self.get_material().set_shader_parameter("color", selectedColor)
		else:
			self.get_material().set_shader_parameter("color", hoverColor)
		Global.battle_manager.set_hovered_limb(self)
		
func mouse_leave():
	if Global.battle_manager.allowEnemyLimbSelection:
		Global.battle_manager.set_hovered_limb(null)
		if not selected:
			self.get_material().set_shader_parameter("color", deselectedColor)

func select(): 
	selected = true
	self.get_material().set_shader_parameter("color",selectedColor)


func deselect():
	selected = false
	self.get_material().set_shader_parameter("color", deselectedColor)

##Gets the position of the click area; 
##useful as the sprite position doesn't match up w/ where 
##player's cursor will be
func get_click_area_global_position() -> Vector2:
	return self.clickArea.get_child(0).global_position
