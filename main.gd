extends Node

@onready var camera: Camera2D = $Camera2D
@export var pan_duration: float = 0.8
var shop_camera_target_x: float = 0.0
var workshop_camera_target_x: float = 1915.0

var current_line: int = 0
var witch_lines: Array[String] = [
	"Witch: Hey! I am looking for someone to fix my broken jar.",
	"An imbecile in a trenchcoat bumped into me yesterday and now the jar is in a thousand pieces!",
	"Bah stupid cats, they never look where they are walking - always clumsy and…",
	"oh I am so sorry, I really didn’t mean that, I LOOOVE CATS!",
	"Anyways, really need this jar restored, think you can fix it?"
]

var click_count: int = 0

@onready var customer_1_node = $Customer1
@onready var witch_chat_container_node = $ChatWitch
@onready var witch_dialogue_label_node = $ChatWitch/WitchChatBox/Witch_1

enum GameState { IDLE, WITCH_DIALOGUE, IN_WORKSHOP }
var current_game_state = GameState.IDLE

func _move_camera_to(target_x_pos: float):
	if not camera:
		printerr("Camera2D not found!")
		return
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "global_position:x", target_x_pos, pan_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func pan_camera_to_workshop():
	_move_camera_to(workshop_camera_target_x)
	print("Panning to workshop")

func pan_camera_to_shop():
	_move_camera_to(shop_camera_target_x)
	print("Panning to shop")

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		click_count += 1
		
		match current_game_state:
			GameState.IDLE:
				if click_count == 1:
					if customer_1_node:
						customer_1_node.is_moving = true
					current_game_state = GameState.WITCH_DIALOGUE
					current_line = 0
					if witch_chat_container_node and witch_dialogue_label_node:
						witch_chat_container_node.visible = true
						if current_line < witch_lines.size():
							witch_dialogue_label_node.text = witch_lines[current_line]
						else:
							witch_dialogue_label_node.text = "..."
					click_count = 0
					
			GameState.WITCH_DIALOGUE:
				current_line += 1
				if witch_chat_container_node and witch_dialogue_label_node:
					if current_line < witch_lines.size():
						witch_dialogue_label_node.text = witch_lines[current_line]
					else:
						if witch_chat_container_node:
							witch_chat_container_node.visible = false
						pan_camera_to_workshop()
						current_game_state = GameState.IN_WORKSHOP
						click_count = 0
				
			GameState.IN_WORKSHOP:
				if click_count == 1:
					pan_camera_to_shop()
					current_game_state = GameState.IDLE 
					click_count = 0

func _ready():
	if witch_chat_container_node:
		witch_chat_container_node.visible = false

	if not camera:
		printerr("Camera2D node ($Camera2D) not found or not ready!")
	if not customer_1_node:
		printerr("Customer1 node ($Customer1) not found!")
	if not witch_chat_container_node:
		printerr("Dialogue Chat container node ($ChatWitch) not found!")
	if not witch_dialogue_label_node:
		printerr("Dialogue Label node ($ChatWitch/Witch_1) not found!")
	
	if camera:
		camera.global_position.x = shop_camera_target_x
