extends Spatial


onready var character = $Character
onready var char_anim = $Character/AnimationPlayer

onready var buttons = $CanvasLayer/Buttons
onready var game_timer = $game_timer
onready var action_timer = $action_timer

onready var homeworkbar = $CanvasLayer/HomeWorkBar
onready var actionbar = $CanvasLayer/ActivityProgress

var data_file
var actions_json
var actions

var gametime = 30

var curactiontime
# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://data/actions.json", File.READ)
	data_file = file.get_as_text()
	file.close()
	actions_json = JSON.parse(data_file)
	actions = actions_json.result
	
	buttons.draw_buttons()
	
	game_timer.wait_time = gametime
	homeworkbar.max_value = gametime
	
	game_timer.start()
	


func do_action(actionname):
	print(actionname)
	buttons.visible = false
	action_timer.wait_time = actions[actionname].time
	actionbar.max_value = actions[actionname].time
	char_anim.play(actionname)
	
	action_timer.start()
	game_timer.paused = true
	
	yield(action_timer, "timeout")
	game_timer.paused = false

	char_anim.play("idle")
	buttons.draw_buttons()


func _process(delta):
	homeworkbar.value = homeworkbar.max_value - game_timer.time_left
	actionbar.value = actionbar.max_value - action_timer.time_left
	
