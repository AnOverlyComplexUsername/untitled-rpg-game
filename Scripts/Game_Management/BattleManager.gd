extends Node2D

##Battle Manager will handle all logic for turn order and player
## actions during battle
class_name BattleManager

var targettedEnemyLimb : Limb = null
var hoveredEnemyLimb : Limb = null

func _ready():
	Global.battle_manager = self

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			print("Left mouse button")
			if hoveredEnemyLimb != null:
				set_targetted_limb(hoveredEnemyLimb)
				targettedEnemyLimb.select()
			
func set_targetted_limb(limb : Limb):
	if targettedEnemyLimb != null and targettedEnemyLimb != limb:
		targettedEnemyLimb.deselect()
	targettedEnemyLimb = limb
	 
func set_hovered_limb(limb : Limb):
	hoveredEnemyLimb = limb
