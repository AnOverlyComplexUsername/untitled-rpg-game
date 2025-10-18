extends CharacterBody2D
class_name Player 

#TODO: Finish basic top down 2d movement; thinking of using composition for this (?)

#This script should contain all player movement/behavior code; 
#stats & other player descriptors will be in GameController

@export var speed : float = 200.0 

@export var canMove : bool = true #used to toggle/enable movement

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta):
	if canMove:
		get_input()
		move_and_slide()
