extends Button

func _on_Play_pressed():
	get_tree().change_scene("res://scenes/Levels/TestLevel.tscn")

func _on_Quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
