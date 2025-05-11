extends Node2D

var camera: Camera2D
var target_position: Vector2
var is_panning: bool = false
var pan_speed: float = 200 
var pan_distance: float = 500

var next_scene_path: String = "res://NextScene.tscn"

func _ready():
	camera = $Camera2D
	camera.current = true

func _process(delta):
	if is_panning:
		camera.position.x = lerp(camera.position.x, target_position.x, pan_speed * delta)

		if abs(camera.position.x - target_position.x) < 1:
			is_panning = false
			change_scene()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_panning:
			start_panning()

func start_panning():
	target_position = camera.position + Vector2(pan_distance, 0)
	is_panning = true

func change_scene():
	get_tree().change_scene(next_scene_path)
