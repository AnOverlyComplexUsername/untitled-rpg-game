extends AbstractLimbEntity

##A basic limb implementation of AbstractLimb
class_name Limb

var selected : bool = false
var selectedColor : Color = Color("ffffffff")
var deselectedColor : Color = Color("ffffff00")
var hoverColor : Color = Color("ffffff60")

func on_death() -> void:
	self.queue_free()

func mouse_hover() -> void:
	if targettable:
		if selected: 
			self.get_material().set_shader_parameter("color", selectedColor)
		else:
			self.get_material().set_shader_parameter("color", hoverColor)
		Global.battle_manager.set_hovered_limb(self)
		
func mouse_leave():
	Global.battle_manager.set_hovered_limb(null)
	if not selected:
		self.get_material().set_shader_parameter("color", deselectedColor)

func select():
	selected = true
	self.get_material().set_shader_parameter("color",selectedColor)


func deselect():
	selected = false
	print('deselected')
	self.get_material().set_shader_parameter("color", deselectedColor)
