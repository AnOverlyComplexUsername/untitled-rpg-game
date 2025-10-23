extends Node2D

##Battle Manager will handle all logic for turn order and player
## actions during battle
class_name BattleManager

var targettedEnemyLimb : Limb = null
var hoveredEnemyLimb : Limb = null

var turnNumber : int = 0 ##Current turn number; used for indexing array
var limbTurn : int = 0 ##tracks which limb's turn it is 
var playersTurn : bool = true ##If current turn is player's
 
@export var turnOrder : Array[AbstractCombatEntity]
@export var playerEntity : PlayerBattleEntity

@export_category("Player Battle UI Elements")
@export var attackButton : Button 
@export var endTurnButton : Button 
@export var turnText : Label
@export var playerUIElements : Array[Button]

func _ready():
	Global.battle_manager = self
	attackButton.button_down.connect(lock_targetted_limb)
	endTurnButton.button_down.connect(end_turn)
	endTurnButton.disabled = true
	#start_combat()

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			if hoveredEnemyLimb != null and playersTurn:
				set_targetted_limb(hoveredEnemyLimb)
				targettedEnemyLimb.select()

##Intializes conditions for combat
func start_combat() -> void:
	turnNumber = 0 
	next_turn()
	

func end_turn() -> void:
	playerEntity.attack()
	next_turn()

##
func next_limb_turn() -> void:
	playerEntity.Limbs[limbTurn].deselect()
	if limbTurn + 1 < playerEntity.Limbs.size():
		limbTurn += 1
		playerEntity.Limbs[limbTurn].select()
	else:
		attackButton.disabled = true
		endTurnButton.disabled = false

##Advances turn order
func next_turn() -> void: 
	turnNumber += 1
	var turnOrderIndex = (turnNumber - 1) % turnOrder.size()
	if turnOrder[turnOrderIndex] is PlayerBattleEntity:
		playersTurn = true
		limbTurn = 0 
		turnText.text = "Player's turn; Turn: " + str(turnNumber)
		playerEntity.Limbs[limbTurn].select()
		for buttons : Button in playerUIElements:
			buttons.disabled = false
		endTurnButton.disabled = true
	else:
		playersTurn = false
		turnText.text = "Enemy's turn; Turn: " + str(turnNumber)
		for buttons : Button in playerUIElements:
			buttons.disabled = true
		turnOrder[turnOrderIndex].attack()
		next_turn()
		
	

func end_combat() -> void:
	pass
	

func set_targetted_limb(limb : Limb) -> void:
	if targettedEnemyLimb != null and targettedEnemyLimb != limb:
		targettedEnemyLimb.deselect()
	targettedEnemyLimb = limb
	 
func set_hovered_limb(limb : Limb) -> void:
	hoveredEnemyLimb = limb
	
	##Locks selected target for limb to attack/act on 
func lock_targetted_limb() -> void: 
	if targettedEnemyLimb != null:
		playerEntity.Limbs[limbTurn].target_limb(targettedEnemyLimb)
		targettedEnemyLimb.deselect()
		targettedEnemyLimb = null
		next_limb_turn()
