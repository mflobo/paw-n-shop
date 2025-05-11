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
	"oh I am so sorry, I really didn’t mean that, I LOOOVE YOU CATS!",
	"Anyways, really need this jar restored, think you can fix it?"
]

var click_count: int = 0

@onready var customer_1_node = $Customer1 # Node name uses underscore in screenshot
@onready var witch_chat_container_node = $ChatWitch
# Path to label needs to be correct based on your scene tree
@onready var witch_dialogue_label_node = $ChatWitch/WitchChatBox/Witch_1

# --- NEW: @onready vars for window layers (using underscores as per your screenshot) ---
@onready var background_outside_node: Sprite2D = $background_outside
@onready var background_back_node: Sprite2D = $background_back
@onready var lightshadow_node: Sprite2D = $lightshadow
@onready var shadow_node: Sprite2D = $shadow
# Note: background_middle and background_front are not listed here
# as their visibility is static for this specific window opening effect.

# Updated GameState enum to include intro steps
enum GameState { INTRO_WINDOW_EFFECT, DIALOGUE_SETUP, WITCH_DIALOGUE, IN_WORKSHOP }
var current_game_state = GameState.INTRO_WINDOW_EFFECT # Start here

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

# --- NEW: Function to handle the window opening effect ---
func trigger_window_effect():
	$HatchOpen.play()
	print("Triggering window effect...")
	if background_back_node:
		background_back_node.visible = false
		print("background_back hidden")
	else:
		printerr("background_back_node not found for window effect!")

	if lightshadow_node:
		lightshadow_node.visible = false
		print("lightshadow hidden")
	else:
		printerr("lightshadow_node not found for window effect!")

	if shadow_node:
		shadow_node.visible = false
		print("shadow hidden")
	else:
		printerr("shadow_node not found for window effect!")

	if background_outside_node: # This should already be visible if all layers start visible
		background_outside_node.visible = true # Ensure it's visible
		print("background_outside ensured visible")
	else:
		printerr("background_outside_node not found!")
	
	current_game_state = GameState.DIALOGUE_SETUP # Move to next state
	click_count = 0 # Reset click count for the next interaction phase


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		click_count += 1

		match current_game_state:
			GameState.INTRO_WINDOW_EFFECT:
				if click_count == 1:
					trigger_window_effect()
			
			GameState.DIALOGUE_SETUP:
				if click_count == 1: # This is now the second click overall
					$WitchWalk.play()
					$WitchVoice.play()
					if customer_1_node:
						customer_1_node.is_moving = true # Or however you trigger movement
					current_game_state = GameState.WITCH_DIALOGUE
					current_line = 0
					if witch_chat_container_node and witch_dialogue_label_node:
						witch_chat_container_node.visible = true
						if current_line < witch_lines.size():
							witch_dialogue_label_node.text = witch_lines[current_line]
						else:
							witch_dialogue_label_node.text = "..."
					click_count = 0 # Reset for dialogue progression

			GameState.WITCH_DIALOGUE:
				current_line += 1 # Assumes each click in this state advances dialogue
				if witch_chat_container_node and witch_dialogue_label_node:						
					if not witch_chat_container_node.visible : # If somehow hidden, reshow
						witch_chat_container_node.visible = true
						
					if current_line < witch_lines.size():
						witch_dialogue_label_node.text = witch_lines[current_line]
					else: # Dialogue finished
						if witch_chat_container_node:
							witch_chat_container_node.visible = false
						$PanningSound.play()
						pan_camera_to_workshop()
						current_game_state = GameState.IN_WORKSHOP
						click_count = 0
				else:
					printerr("Dialogue UI nodes not found during WITCH_DIALOGUE state!")


			GameState.IN_WORKSHOP:
				if click_count == 1:
					pan_camera_to_shop()
					# Decide what happens when returning: back to dialogue setup or idle?
					current_game_state = GameState.DIALOGUE_SETUP 
					click_count = 0

func _ready():
	# Initial visibilities: "Every layer is visible when the game starts"
	# So, we don't need to explicitly set them to true here if they are already
	# visible in the editor. However, explicitly setting the outside to visible
	# after others are hidden is good.
	# For the effect to work, background_back, lightshadow, shadow MUST start visible.
	# And background_outside also needs to be visible (it will be "revealed").

	if background_outside_node: background_outside_node.visible = true
	if background_back_node: background_back_node.visible = true
	if lightshadow_node: lightshadow_node.visible = true
	if shadow_node: shadow_node.visible = true
	# background_middle and background_front should also be visible from the editor.


	if witch_chat_container_node:
		witch_chat_container_node.visible = false # Dialogue UI starts hidden

	# Node path checks (good for debugging)
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
