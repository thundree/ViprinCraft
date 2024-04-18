#Main player managing script. Manages the player.
#

extends Node

var playerFirstPersonCameraSensitivity = 0.005; #Camera sensitivity multiplier for 1st person.
var playerSpeedVariable = 0.09; #How far forwards or backwards the player moves when they click "player_moveForward" keybind, based on one unit in godot.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass

#Player input controller;
#manages all inputs from the user, enabeling player movement and abillity to look around, etc.
func _input(event):
	
	#Player camera rotation controller (1st person)
	if event is InputEventMouseMotion:
		playerRotationandCameraController_firstPerson(event);
	
	#Evaluate the keys the player pressed, and if the keys are (t,f,g,h) then move the player accordingly in the method "playerMoveController(event)";
	if (Input.is_action_pressed("player_moveForward") || Input.is_action_pressed("player_moveBackward") || Input.is_action_pressed("player_strafeRight") || Input.is_action_pressed("player_strafeLeft")):
		playerMoveController(event);
	
	pass

#Allows and evaluates which move key the player pushed, and allows them to move.
func playerMoveController(event):
	#Local variables to hold data for computation when figuring out how the player should move, based on the degree of there rotation.
	var currentPlayerRotation = get_parent().get_node("player").get_rotation_degrees(); #Contains info on the players rotational axises.
	var degreesRegion_left = 0; #In the current 90 degree region of rotation, number of degrees from the left till the next axis (90, 180, 270 or (-x, -z, x, z, etc).
	var degreesRegion_right = 0; #In the current 90 degree region of rotation, number of degrees from the right till the next axis (90, 180, 270 or (-x, -z, x, z, etc).
	var rotation_X_Z_region = 0; #The region the player is facing via rotation, this allows the simplification of the movement code; Key: 0 = top left, 1 = bottom left, 2 = top right, 3 = bottom right.
	
	#Identify the region the player is facing. This is used to move the player later on, simpifing the code.
	#Also bring the degree of there rotation down below 90, since we have the region, and one given region is only 90 degrees, we don't need the degree above that.
	if (currentPlayerRotation.y < 90 && currentPlayerRotation.y > 0):
		rotation_X_Z_region = 0;
		degreesRegion_right = currentPlayerRotation.y;
		degreesRegion_left = 90 - currentPlayerRotation.y;
	elif (currentPlayerRotation.y < 180 && currentPlayerRotation.y > 90):
		rotation_X_Z_region = 1;
		degreesRegion_right = currentPlayerRotation.y - 90;
		degreesRegion_left = 180 - currentPlayerRotation.y;
	elif (currentPlayerRotation.y < 0 && currentPlayerRotation.y > -90):
		rotation_X_Z_region = 2;
		degreesRegion_right = 90 - (currentPlayerRotation.y * -1);
		degreesRegion_left = currentPlayerRotation.y * -1;
	elif (currentPlayerRotation.y < -90 && currentPlayerRotation.y > -180):
		rotation_X_Z_region = 3;
		degreesRegion_right = 180 - (-1 * currentPlayerRotation.y);
		degreesRegion_left = (-1 * currentPlayerRotation.y) - 90;
	
	#If the player enters the "player_moveForward" keybind, then move them forward, based on the direction they are facing.
	if (Input.is_action_pressed("player_moveForward") == true):
		print(currentPlayerRotation.y);
		
		#Move the player based on "degreesRegion_left" and "degreesRegion_right" using the region the player is facing.
		if (rotation_X_Z_region == 0):
			get_parent().get_node("player").position.z -= (degreesRegion_left / 90) * playerSpeedVariable;
			get_parent().get_node("player").position.x -= (degreesRegion_right / 90) * playerSpeedVariable;
		elif (rotation_X_Z_region == 1):
			get_parent().get_node("player").position.z += (degreesRegion_left / 90) * playerSpeedVariable;
			get_parent().get_node("player").position.x -= (degreesRegion_right / 90) * playerSpeedVariable;
		elif (rotation_X_Z_region == 2):
			get_parent().get_node("player").position.z -= (degreesRegion_left / 90) * playerSpeedVariable;
			get_parent().get_node("player").position.x += (degreesRegion_right / 90) * playerSpeedVariable;
		elif (rotation_X_Z_region == 3):
			get_parent().get_node("player").position.z += (degreesRegion_left / 90) * playerSpeedVariable;
			get_parent().get_node("player").position.x += (degreesRegion_right / 90) * playerSpeedVariable;
	
	pass

#Manages the rotation of the player on the X axis, along with camera rotation on the Y axis, all controlled from the mouse.
func playerRotationandCameraController_firstPerson(event):
	
	#Manage player camera and turn with mouse inputs.
	get_parent().get_node("player").rotate_y(-1 * (event.relative.x * playerFirstPersonCameraSensitivity)); #Rotate/turn the player on the X-axis based on the mouse direction of travel.
	$player_pov.rotate_x(-1 * (event.relative.y * playerFirstPersonCameraSensitivity)); #Allow the player to look up and down with the mouse.
	
	pass
