extends Node

@onready var camera: Camera2D = $Camera2D
@export var pan_duration: float = 0.8
var shop_camera_target_x: float = 0.0
var workshop_camera_target_x: float = 1915.0
var has_witch_dialogue_played: bool = false

var current_line: int = 0
var witch_lines: Array[String] = [
	"Witch: Hey! I am looking for someone to fix my broken jar.",
	"An imbecile in a trenchcoat bumped into me yesterday and now the jar is in a thousand pieces!",
	"Bah stupid cats, they never look where they are walking - always clumsy and…",
	"oh I am so sorry, I really didn’t mean that, I LOOOVE YOU CATS!",
	"Anyways, really need this jar restored, think you can fix it?"
]

var click_count: int = 0

@onready var customer_1_node = $Customer1
@onready var witch_chat_container_node = $ChatWitch
@onready var witch_dialogue_label_node = $ChatWitch/WitchChatBox/Witch_1
@onready var jar_node: RigidBody2D = $Jar

@onready var background_outside_node: Sprite2D = $background_outside
@onready var background_back_node: Sprite2D = $background_back
@onready var lightshadow_node: Sprite2D = $lightshadow
@onready var shadow_node: Sprite2D = $shadow

# Här lägger vi till jar_puzzle (minigamet)
@onready var jar_puzzle_node = $jar_puzzle 

enum GameState { INTRO_WINDOW_EFFECT, DIALOGUE_SETUP, WITCH_DIALOGUE, IN_WORKSHOP, IN_PUZZLE }
var current_game_state = GameState.INTRO_WINDOW_EFFECT

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

func trigger_window_effect():
	$HatchOpen.play()
	print("Triggering window effect...")
	if background_back_node:
		background_back_node.visible = false
	else:
		printerr("background_back_node not found for window effect!")

	if lightshadow_node:
		lightshadow_node.visible = false
	else:
		printerr("lightshadow_node not found for window effect!")

	if shadow_node:
		shadow_node.visible = false
	else:
		printerr("shadow_node not found for window effect!")

	if background_outside_node:
		background_outside_node.visible = true
	else:
		printerr("background_outside_node not found!")
	
	current_game_state = GameState.DIALOGUE_SETUP
	click_count = 0

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		click_count += 1

		match current_game_state:
			GameState.INTRO_WINDOW_EFFECT:
				if click_count == 1:
					trigger_window_effect()
			
			GameState.DIALOGUE_SETUP:
				if click_count == 1 and not has_witch_dialogue_played:
					$WitchWalk.play()
					$WitchVoice.play()
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
					if not witch_chat_container_node.visible:
						witch_chat_container_node.visible = true
						
					if current_line < witch_lines.size():
						witch_dialogue_label_node.text = witch_lines[current_line]
						if current_line == 4:
							if jar_node:
								jar_node.visible = true
								await get_tree().process_frame
								jar_node.freeze = false
								jar_node.sleeping = false
					else:
						if witch_chat_container_node:
							witch_chat_container_node.visible = false
						has_witch_dialogue_played = true
						$PanningSound.play()
						pan_camera_to_workshop()
						
						# Starta minigamet
						await get_tree().create_timer(1.0).timeout
						if jar_puzzle_node:
							jar_puzzle_node.visible = true
							jar_puzzle_node.set_process(true)
						current_game_state = GameState.IN_PUZZLE
						click_count = 0
				else:
					printerr("Dialogue UI nodes not found during WITCH_DIALOGUE state!")

			GameState.IN_PUZZLE:
				pass

			GameState.IN_WORKSHOP:
				if click_count == 1:
					pan_camera_to_shop()
					current_game_state = GameState.DIALOGUE_SETUP
					click_count = 0

func _on_puzzle_completed():
	print("The puzzle is completed!")
	if jar_puzzle_node:
		jar_puzzle_node.visible = false
		jar_puzzle_node.set_process(false)
	$PanningSound.play()
	pan_camera_to_shop()
	current_game_state = GameState.DIALOGUE_SETUP
	click_count = 0

func _ready():
	if background_outside_node: background_outside_node.visible = true
	if background_back_node: background_back_node.visible = true
	if lightshadow_node: lightshadow_node.visible = true
	if shadow_node: shadow_node.visible = true

	if witch_chat_container_node:
		witch_chat_container_node.visible = false

	if jar_node:
		jar_node.freeze = true
		jar_node.visible = false

	if jar_puzzle_node:
		jar_puzzle_node.visible = false
		jar_puzzle_node.set_process(false)
		if jar_puzzle_node.has_signal("puzzle_completed"):
			jar_puzzle_node.connect("puzzle_completed", Callable(self, "_on_puzzle_completed"))

	if not camera: printerr("Camera2D node ($Camera2D) not found!")
	if not customer_1_node: printerr("Customer1 node ($Customer1) not found!")
	if not witch_chat_container_node: printerr("Witch chat container node ($ChatWitch) not found!")
	if not witch_dialogue_label_node: printerr("Witch dialogue label node ($ChatWitch/WitchChatBox/Witch_1) not found!")
	if not background_outside_node: printerr("background_outside_node not found!")
	if not background_back_node: printerr("background_back_node not found!")
	if not lightshadow_node: printerr("lightshadow_node not found!")
	if not shadow_node: printerr("shadow_node not found!")

	if camera:
		camera.global_position.x = shop_camera_target_x
