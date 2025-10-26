@abstract
extends Node2D
##Entity class for entities during battle
class_name AbstractCombatEntity

##The limb parts that constitute the entity
@export var Limbs : Array[Limb] 

##Determines priority of who moves, higher number moves first
## By default it goes player then enemy, from left to right
@export var movePriority : int = 0

func _ready():
	for l : AbstractLimbEntity in Limbs:
		l.healthComp.death.connect(handle_limb_death)
##Static factory for entity when spawning entites 
##[br] must define originScene before calling
static func new_entity(originScene : PackedScene, spawnPos : Vector2):
	var new : AbstractCombatEntity = originScene.instantiate()
	new.global_position = spawnPos
	return new

func handle_limb_death(l : AbstractLimbEntity):
	Limbs.pop_at(Limbs.find(l)).queue_free()

@abstract func attack() -> void
