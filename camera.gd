extends Node2D  # Or another appropriate node, like Camera2D

var camera: Camera2D
var target_position: Vector2
var is_panning: bool = false
var pan_speed: float = 200  # Speed of panning in pixels per second

# The distance to pan the camera (e.g., 500 pixels to the right)
var pan_distance: float = 500

# Scene to switch to
var next_scene_path: String = "res://NextScene.tscn"

func _ready():
	# Get the Camera2D node
	camera = $Camera2D
	camera.current = true  # Ensure this camera is active

# Called every frame
func _process(delta):
	# Handle camera panning
	if is_panning:
		# Smoothly move the camera to the right
		camera.position.x = lerp(camera.position.x, target_position.x, pan_speed * delta)

		# If the camera reaches the target position, stop panning and change the scene
		if abs(camera.position.x - target_position.x) < 1:
			is_panning = false
			change_scene()

# Detect mouse click to start panning
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_panning:
			start_panning()

# Start panning the camera to the right
func start_panning():
	target_position = camera.position + Vector2(pan_distance, 0)  # Move right by 'pan_distance'
	is_panning = true

# Change to the next scene after panning
func change_scene():
	get_tree().change_scene(next_scene_path)
