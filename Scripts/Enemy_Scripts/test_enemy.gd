extends AbstractCombatEntity

func attack() -> void:
	for i in self.Limbs.size():
		if is_instance_valid(self.Limbs[i]) and self.Limbs[i] is AttackingLimb:
			self.Limbs[i].attack(Global.battle_manager.playerEntity.Limbs[1])
		pass
