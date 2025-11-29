@abstract
extends Resource

class_name AbstractPassiveEffect

@export var turnDuration : int = 9999

##What passive effects are effected to what 
## can take a combat entity or a limb as the target for the effect 
@abstract func passiveEffect(target : AbstractCombatEntity = null, limb : AbstractLimbEntity = null)
