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

#[color=#271415][font_size=40]
var screen_size
var click_count = 0
var current_line = 0

var witch_lines = [
	"[color=#271415][font_size=40]Witch: Hey! I am looking for someone to fix my broken jar.",
	"[color=#271415][font_size=40]An imbecile in a trenchcoat bumped into me yesterday and now the jar is in a thousand pieces!",
	"[color=#271415][font_size=40]Bah stupid cats, they never look where they are walking - always clumsy and…",
	"[color=#271415][font_size=40]oh I am so sorry, I really didn’t mean that, I LOOOVE CATS!",
	"[color=#271415][font_size=40]Anyways, really need this jar restored, think you can fix it? "
]
			
#Move camera 1915 px to the right
func pan_camera_right():
	var camera = $Camera2D
	var new_position = camera.position + Vector2(1915, 0) 
	camera.position = new_position

#Move camera 1915 px to the left
func pan_camera_left():
	var camera = $Camera2D
	var new_position = camera.position - Vector2(1915, 0) 
	camera.position = new_position
	
func witch_chat():
	pass
	
#Function to run tutorial
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
			$Customer1.is_moving = true
			
		elif click_count == 2:
			$ChatWitch/WitchChatBox.visible = true
			$ChatWitch/WitchChatBox/Witch_1.text = witch_lines[current_line]
		
		elif click_count == 3:
			current_line +=1
			$ChatWitch/WitchChatBox/Witch_1.text = witch_lines[current_line]
		
		elif click_count == 4:
			current_line +=1
			$ChatWitch/WitchChatBox/Witch_1.text = witch_lines[current_line]
		
		elif click_count == 5:
			current_line +=1
			$ChatWitch/WitchChatBox/Witch_1.text = witch_lines[current_line]
		
		elif click_count == 6:
			current_line +=1
			$ChatWitch/WitchChatBox/Witch_1.text = witch_lines[current_line]	
		
			
		#Pan camera to the right
		elif click_count == 7:
			pan_camera_right()
			$ChatWitch/WitchChatBox.visible = false  # ✅ Korrekt sökväg

		elif click_count == 8: 
			pan_camera_left()
			
	
	
