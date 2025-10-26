extends AbstractCombatEntity
##Holds basic/test/default behaviors for enemy type entities
class_name Enemy

#Lazy check for if it's dead or not
#theortically not that expensive to do; can probably be more optimizeddd
func _process(_delta):
	if Limbs.is_empty():
		self.queue_free()

func attack() -> void:
	for i in self.Limbs.size():
		if !is_instance_valid(self.Limbs[i]):
			continue
		if Limbs[i].healthComp.health <= 0:
			continue
		if Global.battle_manager.playerEntity.Limbs.size() <= 0:
			return
		if self.Limbs[i] is AttackingLimb:
			self.Limbs[i].attack(Global.battle_manager.playerEntity.Limbs[
				randi_range(0,Global.battle_manager.playerEntity.Limbs.size() - 1)])
