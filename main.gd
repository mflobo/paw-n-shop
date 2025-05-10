extends Node

var screen_size
var click_count = 0
			
#Move camera 1915 px to the right
func pan_camera_right():
	var camera = $Camera2D
	var new_position = camera.position + Vector2(1915, 0) 
	camera.position = new_position

#Function to run tutorial
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		click_count +=1
		#Enter first customer
		if click_count == 1:
			$Customer1.is_moving = true
		#Pan camera to the right
		elif click_count == 2:
			pan_camera_right()
	
	
