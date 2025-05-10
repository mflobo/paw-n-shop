extends Sprite2D

func _ready():
	# Centrerar bakgrunden i förhållande till skärmen
	var screen_center = get_viewport().get_visible_rect().size / 2
	position = screen_center
	scale = global_scale
	
