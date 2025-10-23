extends AttackingLimb

##Player limb
class_name PlayerLimb

var target : Limb = null
var actionable : bool = true

func _ready():
	targettable = false

func target_limb(l : Limb) -> void:
	target = l

func attack(limb : AbstractLimbEntity) -> void:
	if actionable:
		super.attack(limb)
	
	
func on_death(): ##Determines what the limb does when it's destroyed:
	pass

func mouse_hover(): ##What happens when mouse hovers over attackable limb:
	pass

func mouse_leave(): ##What happens when mouse leaves attackable limb area:
	pass

func on_hit(): ##What happens when limb is hit and takes damage
	pass
