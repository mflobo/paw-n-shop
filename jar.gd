extends Node2D  # Eller vilken nod du har för minigamet

signal puzzle_completed

var pieces := []  # Array med alla bitar (Area2D)
var snapped_pieces_count := 0

func _ready():
	# Hitta alla bitar (exempel: alla barn med script Area2D)
	pieces = get_children()  # Eller loopa genom nodes och hitta dina bitar

	for piece in pieces:
		if piece.has_signal("piece_snapped"):
			piece.connect("piece_snapped", self, "_on_piece_snapped")

func _on_piece_snapped(_piece):
	snapped_pieces_count += 1
	print("Piece snapped! Total snapped: ", snapped_pieces_count, "/", pieces.size())
	
	if snapped_pieces_count == pieces.size():
		_minigame_completed()

func _minigame_completed():
	print("Minigame klar!")
	emit_signal("puzzle_completed")
