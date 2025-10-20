extends AbstractLimbEntity

##Player limb


class_name PlayerLimb

func _ready():
	targettable = false

func on_death(): ##Determines what the limb does when it's destroyed:
	pass

func mouse_hover(): ##What happens when mouse hovers over attackable limb:
	pass

func mouse_leave(): ##What happens when mouse leaves attackable limb area:
	pass
