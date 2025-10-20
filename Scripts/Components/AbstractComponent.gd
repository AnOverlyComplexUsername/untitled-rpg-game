@abstract 
##abstract component; has functions for enabling/disabling itself
class_name AbstractComponent
extends Node2D
func enable(): ##Enables Component Functionality
	self.enable()
	
func disable(): ##Disables Component Functionality
	self.disable()
