extends Control

onready var main = get_node("/root/Main")
onready var world_environment = main.get_node("GameObjects/WorldEnvironment")
onready var fancyenv = $PostProcSwitch


func _on_Quit_pressed():
	$Click.play()
	get_tree().quit()

func _on_Play_pressed():
	$Click.play()
	if fancyenv.pressed:
		world_environment.environment = load("res://other_resources/FancyEnvironment.tres")
	else:
		world_environment.environment = load("res://other_resources/PotatoEnvironment.tres")
	visible = false


func _on_PostProcSwitch_pressed():
	$Click.play()
