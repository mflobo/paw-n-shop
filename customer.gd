extends Area2D

@export var move_speed: float = 100.0
@export var move_direction: Vector2 = Vector2.RIGHT
@export var move_distance: float = 200.0

var is_moving: bool = false
var start_position: Vector2
var distance_moved: float = 0.0

func _ready():
	start_position = global_position

func _process(delta):
	if is_moving:
		var step = move_direction * move_speed * delta
		global_position += step
		distance_moved += step.length()
		
		if distance_moved >= move_distance:
			is_moving = false
			distance_moved = 0.0
