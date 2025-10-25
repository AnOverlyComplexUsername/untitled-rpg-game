extends Node2D

##Battle Manager will handle all logic for turn order and player
## actions during battle
class_name BattleManager

var targettedEnemyLimb : Limb = null
var hoveredLimb : Limb = null
var currentPlayerLimbSelected : PlayerLimb = null

var turnNumber : int = 0 ##Current turn number; used for indexing array
var limbTurn : int = 0 ##tracks which limb's turn it is 
var playersTurn : bool = true ##If current turn is player's

##Allows player to select enemy limb; only on if atatcking
var allowEnemyLimbSelection : bool = false 

@export var turnOrder : Array[AbstractCombatEntity]
@export var playerEntity : PlayerBattleEntity
var playerLimbTurnOrder : Array[PlayerLimb]

@export_category("Player Battle UI Elements")
@export var attackButton : Button 
@export var endTurnButton : Button 
@export var backButton : Button 
@export var turnText : Label
@export var playerUIElements : Array[Control]

func _ready():
	Global.battle_manager = self
	attackButton.button_down.connect(start_attack)
	endTurnButton.button_down.connect(end_turn)
	backButton.button_down.connect(undo_limb_turn)
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
			if not playersTurn:
				return
			if hoveredLimb is PlayerLimb and !allowEnemyLimbSelection:
				if currentPlayerLimbSelected != null:
					currentPlayerLimbSelected.deselect()
				currentPlayerLimbSelected = hoveredLimb
				currentPlayerLimbSelected.select()
				enable_limb_action_menu()
			elif allowEnemyLimbSelection and (hoveredLimb != PlayerLimb and  hoveredLimb != null):
				targettedEnemyLimb = hoveredLimb
				lock_targetted_limb()
				allowEnemyLimbSelection = false
				if currentPlayerLimbSelected != null:
					currentPlayerLimbSelected.deselect()
					currentPlayerLimbSelected.targettable = false
					playerLimbTurnOrder.append( currentPlayerLimbSelected)
				limbTurn += 1


			
			


#region Handles turn order; win/lose conditions
##Intializes conditions for combat
func start_combat() -> void:
	turnNumber = 0 
	backButton.disabled = true
	endTurnButton.disabled = true
	disable_limb_action_menu()
	next_turn()
	

func end_turn() -> void:
	for l : PlayerLimb in playerLimbTurnOrder:
		l.attack(l.target)
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
	if turnOrder[turnOrderIndex] is PlayerBattleEntity:
		for l : PlayerLimb in playerLimbTurnOrder:
			l.targettable = true 
		playersTurn = true
		turnText.text = "Player's turn; Turn: " + str(turnNumber)		
		endTurnButton.disabled = true
		backButton.disabled = true
	else:
		playersTurn = false
		turnText.text = "Enemy's turn; Turn: " + str(turnNumber)
		disable_limb_action_menu()
		turnOrder[turnOrderIndex].attack()
		next_turn()
		
	

func end_combat() -> void:
	pass #TODO: Finish this
#endregion
	
#region Handles UI Behavior During Combat
##Undos the last limb action done for player
func undo_limb_turn():
	limbTurn = clampi(limbTurn - 1,0,playerEntity.Limbs.size())
	playerLimbTurnOrder.pop_back().targettable = true
	currentPlayerLimbSelected = null
	hoveredLimb = null


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





#endregion

#region Handling enemy Limb targetting for player actions 
##Updates which limb should be currently selected
##@deprecated: No longer used for current system
func update_player_limb_selection(): 
	var i : int = 0
	while i < playerEntity.Limbs.size():
		if !is_instance_valid(playerEntity.Limbs[i]) or playerEntity.Limbs[i] == null:
			playerEntity.Limbs.remove_at(i)
			i -= 1
		playerEntity.Limbs[i].deselect()
		i += 1
		
	playerEntity.Limbs[limbTurn].select()

func get_selected_player_limb() -> PlayerLimb:
	return currentPlayerLimbSelected

##sets currently selected limb
##@deprecated: No longer used for current system
func set_targetted_limb(limb : Limb) -> void:
	if targettedEnemyLimb != null and targettedEnemyLimb != limb:
		targettedEnemyLimb.deselect() #deselect old selected limb
	targettedEnemyLimb = limb

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
