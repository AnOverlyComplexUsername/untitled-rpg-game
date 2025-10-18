extends AbstractComponent
##Interactable components handle logics behind interactables
class_name InteractableComponent

##Area that the player has to enter to interact w/ entity
@export var interactableArea : Area2D

##Determines if player can currently interact with entity
@export var interactable : bool = true

##Sprite that's attached to entity; used for toggling highlights
@export var sprite : Sprite2D 

##Signal emitted when player triggers interactable; signal caught by parent script
signal interactable_signal()

##tween used for animating highlights
var tween : Tween = null
func _ready():
	disableOutline()
	
##Emits interactable signal when player interacts w/ entity for functionality
func trigger_interactable() -> void:
	interactable_signal.emit()

##Enables entity's player interactability 
func enable_interactable() -> void:
	interactable = true

##Disables entity's player interactability 
func disable_interactivity() -> void:
	interactable = false
	
## toggles outline on current interactable item
func enableOutline() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(sprite.get_material(), "shader_parameter/color", Color(255.014, 255.014, 255.014, 1.0), 0.5)
	tween.play()
	tween.tween_callback(tween.kill)
	
	
## fades out outline when object is no longer current interactable item
func disableOutline() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(sprite.get_material(), "shader_parameter/color", Color(255,255,255,0), 0.2)
	tween.play() #minor bug where tween doesn't fade out properly
	
