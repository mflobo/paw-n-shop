extends Label

func add_coin(money_to_add: int):
	var current_value = int($Label.text)  # Läs nuvarande heltal från labeln
	current_value += money_to_add         # Lägg till värdet
	$Label.text = str(current_value)      # Uppdatera labeln med nya värdet
