#Main game control script. This script is locked on the main node of the main scene.
#This script is used to set game wide parameters.

extends Node


#Init game
func _ready():
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED; #Lock the mouse in the game window, so that is cannot leave, and can easily be used to spin/look around as a player control.
	
	pass # Replace with function body.


#Main game loop for the entire games control;
func _process(delta):
	pass
