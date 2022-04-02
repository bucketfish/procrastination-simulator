extends Spatial


onready var character = $Character
onready var char_anim = $Character/AnimationPlayer

onready var buttons = $CanvasLayer/Buttons
var data_file
var actions_json
var actions
# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://data/actions.json", File.READ)
	data_file = file.get_as_text()
	file.close()
	actions_json = JSON.parse(data_file)
	actions = actions_json.result
	
	buttons.draw_buttons()


func do_action(actionname):
	print(actionname)
	buttons.visible = false
	char_anim.play(actionname)
	yield(get_tree().create_timer(actions[actionname].time), "timeout")
	char_anim.play("idle")
	buttons.draw_buttons()

