extends Node
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
		#Enter first customer
		if click_count == 1:
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
			
	
	
