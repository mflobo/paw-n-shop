extends Area2D

signal piece_snapped(piece)

var dragging = false
var drag_offset = Vector2.ZERO

@export var goal_position := Vector2.ZERO  # Sätts i editor eller i kod
var snapped = false  # Är biten "fast"

const SNAP_DISTANCE = 20  # Max avstånd för att "snap" (låsa)

func _input_event(viewport, event, shape_idx):
	if snapped:
		return  # Lås biten, ignorera input

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			dragging = false

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset
	
	if not snapped:
		if global_position.distance_to(goal_position) < SNAP_DISTANCE:
			global_position = goal_position
			snapped = true
			dragging = false
			emit_signal("piece_snapped", self)
