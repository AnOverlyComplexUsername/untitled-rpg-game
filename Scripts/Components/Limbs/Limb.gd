extends AbstractLimbEntity

##A basic limb implementation of AbstractLimb
class_name Limb

var selected = false


func on_death() -> void:
	self.queue_free()

func mouse_hover() -> void:
	print('buh')
	if targettable:
		if selected: 
			self.get_material().set_shader_parameter("color", Color("ffffffff"))
		else:
			self.get_material().set_shader_parameter("color", Color("ffffff9a"))
		Global.battle_manager.set_hovered_limb(self)
		
func mouse_leave():
	print("uh")
	Global.battle_manager.set_hovered_limb(null)
	self.get_material().set_shader_parameter("color", Color("ffffff00"))

func select():
	selected = true
	self.get_material().set_shader_parameter("color", Color("ffffffff"))


func deselect():
	selected = false
	print('deselected')
