extends Node2D
class_name damageNumPopup
@onready var animation :  AnimationPlayer = $Control/DamageNumberLabel/PopupAnimation
@onready var damageText : Label = $Control/DamageNumberLabel
static var scene : PackedScene = preload("res://Scenes/UI_Scenes/damage_number.tscn")
var damage : int = 0

##Static constructor for new popups
static func new_popup(d : int, p : Vector2 = Vector2(0,0)) -> damageNumPopup:
	var new : damageNumPopup = scene.instantiate()
	new.damage = d
	print(p)
	new.global_position = p
	return new
	
func _ready():
	damageText.text = str(damage)
	animation.play("Ani_Damage_number")
	
