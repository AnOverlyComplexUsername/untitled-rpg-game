@abstract
extends Node2D
##Entity class for entities during battle
class_name AbstractCombatEntity

signal entity_dead(entity :AbstractCombatEntity)
##The limb parts that constitute the entity
@export var Limbs : Array[Limb] 

##Determines priority of who moves, higher number moves first
## By default it goes player then enemy, from left to right
@export var movePriority : int = 0

#Lazy check for if it's dead or not
#theortically not that expensive to do; 
# please fix this someone
func _process(_delta):
	if Limbs.is_empty():
		entity_dead.emit(self)
		self.queue_free()
		


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
	if !is_instance_valid(l) or Limbs.size() <= 0:
		return
	print(Limbs)
	Limbs.pop_at(Limbs.find(l)).queue_free()

@abstract func attack() -> void
