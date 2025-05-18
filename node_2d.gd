extends Node2D

signal minigame_finished(successful: bool)

func finish_minigame():
	# Call this when the player completes the puzzle
	emit_signal("minigame_finished", true)
