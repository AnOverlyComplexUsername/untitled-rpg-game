extends AbstractCombatEntity


func attack() -> void:
	for i in self.Limbs.size():
		if Global.battle_manager.playerEntity.Limbs.size() <= 0:
			return
		if is_instance_valid(self.Limbs[i]) and self.Limbs[i] is AttackingLimb:
			self.Limbs[i].attack(Global.battle_manager.playerEntity.Limbs[
				randi_range(0,Global.battle_manager.playerEntity.Limbs.size() - 1)])
