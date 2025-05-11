extends RigidBody2D

var fall_time = 1.0  # Tiden för att objektet ska falla (i sekunder)
var timer = 0.0  # Tidsräknare för att hålla koll på när objektet ska sluta falla

func _ready():
	# Initialisera objektet (om det behövs)
	pass

func _process(delta):
	# Lägg till tidsdelta till timern
	timer += delta
	
	# Om timern har passerat den angivna tiden
	if timer >= fall_time:
		# Sätt objektet till Static så att det slutar falla
		freeze = true
		gravity_scale = 0
