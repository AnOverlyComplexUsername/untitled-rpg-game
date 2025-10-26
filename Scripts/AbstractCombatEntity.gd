@abstract
extends Node2D
##Entity class for entities during battle
class_name AbstractCombatEntity

##The limb parts that constitute the entity
@export var Limbs : Array[Limb] 

##Determines priority of who moves, higher number moves first
## By default it goes player then enemy, from left to right
@export var movePriority : int = 0

##Static factory for entity when spawning entites 
##[br] must define originScene before calling
static func new_entity(originScene : PackedScene, spawnPos : Vector2):
	var new : AbstractCombatEntity = originScene.instantiate()
	new.global_position = spawnPos
	return new
	
@abstract func attack() -> void
