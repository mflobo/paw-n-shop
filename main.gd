extends Node

@onready var camera: Camera2D = $Camera2D 
var click_count = 0 

@export var pan_duration: float = 0.8 

var shop_camera_target_x: float = 0.0 
var workshop_camera_target_x: float = 1915.0 

func _move_camera_to(target_x_pos: float):
	if not camera:
		printerr("Camera2D not found!")
		return

	var tween = get_tree().create_tween()
	tween.tween_property(camera, "position:x", target_x_pos, pan_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func pan_camera_to_workshop():
	_move_camera_to(workshop_camera_target_x)
	print("Panning to workshop")

func pan_camera_to_shop():
	_move_camera_to(shop_camera_target_x)
	print("Panning to shop")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		click_count +=1
		if click_count == 1:
			if $Customer1: 
				$Customer1.is_moving = true
		elif click_count == 2:
			pan_camera_to_workshop() 
		elif click_count == 3:
			pan_camera_to_shop()  
