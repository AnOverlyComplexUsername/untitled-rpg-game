extends Node2D

##Battle Manager will handle all logic for turn order and player
## actions during battle
class_name BattleManager

#Variables relating to target selection
var targettedEnemyLimb : Limb = null
var hoveredLimb : Limb = null
var currentPlayerLimbSelected : PlayerLimb = null

#Variables relating to battle progression
var turnNumber : int = 0 ##Current turn number; used for indexing array
var limbTurn : int = 0 ##tracks which limb's turn it is 
var playersTurn : bool = true ##If current turn is player's

var currentEncounter : EnemyEncounter = null

##Allows player to select enemy limb; only on if atatcking
var allowEnemyLimbSelection : bool = false 

@export var turnOrder : Array[AbstractCombatEntity]
@export var playerEntity : PlayerBattleEntity
var playerLimbTurnOrder : Array[PlayerLimb]
var enemyCount : int = 0
@export_category("Player Battle UI Elements")
@export var defendButton : Button
@export var itemButton : Button
@export var attackButton : Button 
@export var endTurnButton : Button 
@export var backButton : Button 
@export var turnText : Label
@export var playerUIElements : Array[Control]

func _ready():
	Global.battle_manager = self
	attackButton.button_down.connect(start_attack)
	endTurnButton.button_down.connect(end_turn)
	defendButton.button_down.connect(defend)
	backButton.button_down.connect(undo_limb_turn)
	playerEntity.entity_dead.connect(kill_entity)

	#start_combat()

func _process(_delta):
	if limbTurn > 0: backButton.disabled = false 
	else: backButton.disabled = true
	if limbTurn >= playerEntity.Limbs.size(): endTurnButton.disabled = false
	else: endTurnButton.disabled = true
	
	
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			if not playersTurn: #Blocks inputs if it's not player's turn
				return

			#allows player to only select player limb for action before attacking
			if hoveredLimb is PlayerLimb and !allowEnemyLimbSelection:
				if currentPlayerLimbSelected != null:
					currentPlayerLimbSelected.deselect()
				currentPlayerLimbSelected = hoveredLimb
				currentPlayerLimbSelected.select()
				enable_limb_action_menu()
			
			#if player already selected attack; allows enemy limb targetting
			elif allowEnemyLimbSelection and (!hoveredLimb is PlayerLimb and  hoveredLimb != null):
				targettedEnemyLimb = hoveredLimb
				lock_targetted_limb()
				if currentPlayerLimbSelected != null:
					currentPlayerLimbSelected.targettable = false
					playerLimbTurnOrder.append( currentPlayerLimbSelected)
				currentPlayerLimbSelected.StoredAction = PlayerLimb.Actions.ATTACK
				reset_limb_selection()
				limbTurn += 1


##Sorts turn order according to move priority		
func sort_turn_order(a : AbstractCombatEntity, b :AbstractCombatEntity):
	if a.movePriority > b.movePriority: return true
	return false


#region Turn order; win/lose conditions

##removes all combatants after a fight/before
func reset_comabat_grounds():
	pass

##Kills entity when recieving kill signal
#ngl i feel like there's a memory leak here for some reason
func kill_entity(e : AbstractCombatEntity):
	if e is PlayerBattleEntity:
		lose_combat()
		e.queue_free()
	else:
		print(e)
		enemyCount -= 1
		if enemyCount <= 0:
			win_combat()


##Intializes conditions for combat
func start_combat(encounter : EnemyEncounter) -> void:
	Global.inventory_manager.disable_inventory() #Disables inventory from being opened
	currentEncounter = encounter
	turnOrder.clear()
	playerLimbTurnOrder.clear()
	turnOrder.append(playerEntity)
	enemyCount = encounter.Enemies.size()
	#Adds enemies to scene & turn order
	for e : PackedScene in encounter.Enemies:
		var enemy = AbstractCombatEntity.new_entity(e, encounter.Enemies.get(e))
		print(enemy)
		self.add_child(enemy)
		turnOrder.append(enemy)
		enemy.entity_dead.connect(kill_entity)

	turnOrder.sort_custom(sort_turn_order)
	turnNumber = 0 
	backButton.disabled = true
	endTurnButton.disabled = true
	reset_comabat_grounds()
	disable_limb_action_menu()
	next_turn()
	
##Handles what limbs should do according to stored action 
##Also checks if there are any enemies left; if none then combat ends
func end_turn() -> void:
	for l : PlayerLimb in playerLimbTurnOrder:
		if is_instance_valid(l) == false:
			lose_combat()
			return
		match l.get_stored_action():
			PlayerLimb.Actions.ATTACK:
				l.attack(l.target)
			PlayerLimb.Actions.DEFEND:
				l.healthComp.set_damage_reduction(0.65) 
				#by default blocking will reduce damage by 65%
			PlayerLimb.Actions.ITEM:
				pass #TODO: Implement
	next_turn()

##Advances Player Limb Turn Order
func next_limb_turn() -> void:
	playerEntity.Limbs[limbTurn].deselect()
	if limbTurn + 1 < playerEntity.Limbs.size():
		limbTurn += 1
		playerEntity.Limbs[limbTurn].select()
		backButton.disabled = false
		allowEnemyLimbSelection = false
	else:
		attackButton.disabled = true
		endTurnButton.disabled = false

##Advances turn order
func next_turn() -> void: 
	turnNumber += 1
	var turnOrderIndex : int = (turnNumber - 1) % turnOrder.size()
	limbTurn = 0 

	##Player turn handling 
	if turnOrder[turnOrderIndex] is PlayerBattleEntity:
		 #resets targetting for player limbs; allows player to click on them 
		for l : PlayerLimb in playerLimbTurnOrder:
			l.targettable = true 
		playerLimbTurnOrder.clear()
		playersTurn = true
		turnText.text = "Player's turn; Turn: " + str(turnNumber)		
		endTurnButton.disabled = true
		backButton.disabled = true
		reset_limb_selection()

	else: ##Enemy turn handling 
		playersTurn = false
		turnText.text = "Enemy's turn; Turn: " + str(turnNumber)
		disable_limb_action_menu()
		turnOrder[turnOrderIndex].attack()
		next_turn()

func win_combat() -> void:
	Global.scene_manager.disable_battle_scene()
	Global.inventory_manager.enable_inventory()

	reward_player()
	print("victory!")
	turnOrder.clear()

##transfer rewards from encounter to player after
func reward_player() -> void:
	for item : AbstractItem in  currentEncounter.get_item_reward():
		Global.game_manager.add_to_inventory(item)
	Global.game_manager.add_money(currentEncounter.MoneyReward)

##Called when player loses important limb (torso/head)  
func lose_combat() -> void:
	Global.scene_manager.change_overworld_scenes(
		"res://Scenes/UI_Scenes/game_over_scene.tscn", 
		Global.scene_manager.sceneAction.HIDE)
	turnOrder.clear()

	
#endregion
	
#region UI Behavior During Combat
##Undos the last limb action done for player
func undo_limb_turn():
	limbTurn = clampi(limbTurn - 1,0,playerEntity.Limbs.size())
	playerLimbTurnOrder.pop_back().targettable = true
	reset_limb_selection()
	hoveredLimb = null
	disable_limb_action_menu()


func disable_limb_action_menu() -> void:
	for ui : Control in playerUIElements:
			ui.hide()
			ui.process_mode = Node.PROCESS_MODE_DISABLED


##Goes next to selected limb and becomes visible and active for use
func enable_limb_action_menu() -> void:
	for ui : Control in playerUIElements:
		if get_selected_player_limb() != null:
			ui.global_position = get_selected_player_limb().get_click_area_global_position() + Vector2(40,-80)
		ui.show()
		ui.process_mode = Node.PROCESS_MODE_INHERIT

##Starts functionaltiy for player limb attacking when player clicks attack button
func start_attack():
	allowEnemyLimbSelection = true
	disable_limb_action_menu()

##Blocks a certian percentage of damage from enemy; costs entire turn
func defend():
	for l : PlayerLimb in playerEntity.Limbs:
		l.StoredAction = l.Actions.DEFEND
		playerLimbTurnOrder.append(l)
	end_turn()

#endregion

#region  Enemy Limb targetting for player actions 

##resets limb selections back to null and base settings
func reset_limb_selection() -> void:
	if currentPlayerLimbSelected != null:
		currentPlayerLimbSelected.deselect()
	currentPlayerLimbSelected = null
	allowEnemyLimbSelection = false
	hoveredLimb = null

func get_selected_player_limb() -> PlayerLimb:
	return currentPlayerLimbSelected

##Updates what limb is currently be hovered over
func set_hovered_limb(limb : Limb) -> void:
	hoveredLimb = limb
	
	##Locks selected target for limb to attack/act on 
func lock_targetted_limb() -> void: 
	if targettedEnemyLimb != null:
		currentPlayerLimbSelected.target_limb(targettedEnemyLimb)
		targettedEnemyLimb.deselect()
		targettedEnemyLimb = null
#endregion
