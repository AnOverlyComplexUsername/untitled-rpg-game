extends AbstractLimbEntity

##A basic limb implementation of AbstractLimb
class_name Limb

func on_death() -> void:
	self.queue_free()

func mouse_hover() -> void:
	print('buh')
	if targettable:
		self.get_material().set_shader_parameter("color", Color("ffffffff"))
		
func mouse_leave():
	print("uh")
	self.get_material().set_shader_parameter("color", Color("ffffff00"))
