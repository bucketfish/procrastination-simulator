extends Spatial


onready var character = $RoomGroup/CharacterGroup/Character
onready var char_anim = $RoomGroup/CharacterGroup/Character/AnimationPlayer

onready var buttons = $GUILayer/Buttons
onready var game_timer = $GameObjects/game_timer
onready var homework_timer = $GameObjects/homework_timer
onready var action_timer = $GameObjects/action_timer

onready var homeworkbar = $GUILayer/HomeWorkBar
onready var actionbar = $GUILayer/ActivityProgress

onready var clock_min = $RoomGroup/ClockGroup/minute
onready var clock_hour = $RoomGroup/ClockGroup/hour

onready var parent_anim = $RoomGroup/DoorGroup/DoorOpenPlayer

onready var text_bubble = $MumTalkSprite
onready var text_bubble_sprite = $MumTalkViewport/Bubble
onready var text_bubble_label = $MumTalkViewport/Label

onready var play_button = $MenuLayer/Menu/Play


onready var tutorial = $TutorialLayer/Tutorial
onready var winscreen = $end/win
onready var losescreen = $end/lose
onready var menu = $MenuLayer/Menu


onready var sounds = [$Audio/disjoint, $Audio/outside, $Audio/snack, $Audio/hydrate, $Audio/themtube]

var data_file
var actions_json
var actions

var homeworktime = 30
var gametime = 10 # how often parent comes in
var gametimemax = 6 # how many times until game over
var gametimecount = 0

var doingaction = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://data/actions.json", File.READ)
	data_file = file.get_as_text()
	file.close()
	actions_json = JSON.parse(data_file)
	actions = actions_json.result
	play_button.connect("pressed", self, "_on_Play_pressed")
	setup_menu()
	
func setup_menu():
	# basically reset everything
	stop_action()
	parent_anim.play("RESET")
	char_anim.play("RESET")
	gametimecount = 0
	doingaction = false
	menu.visible = true
	tutorial.visible = false
	game_timer.wait_time = gametime
	text_bubble.visible = false
	homework_timer.wait_time = homeworktime
	homeworkbar.max_value = homeworktime
	clock_hour.rotation_degrees.z = 30
	clock_min.rotation_degrees.z = -180
	winscreen.visible = false
	losescreen.visible = false
	
	get_tree().paused = true
	
	
func start_game():
	# start timer
	get_tree().paused = false
	game_timer.start()
	homework_timer.start()
	

func _on_Play_pressed():
	show_tutorial()
	
func show_tutorial():
	buttons.draw_buttons()
	tutorial.visible = true
	
func _on_TutorialButton_pressed():
	tutorial.visible = false
	start_game()


func do_action(actionname):
	for i in sounds:
		i.playing = false
	get_node("Audio/" + actionname).playing = true
	# well, do the action
	# set up action doing and timer
	buttons.hide_buttons()
	action_timer.wait_time = actions[actionname].time
	actionbar.max_value = actions[actionname].time
	char_anim.play(actionname)
	
	doingaction = true
	action_timer.start()
	homework_timer.paused = true
	
	yield(action_timer, "timeout")
	stop_action()
	
func stop_action():
	for i in sounds:
		i.playing = false
	# prevent stoppping it twice or something
	if doingaction:
		homework_timer.paused = false
		doingaction = false

		char_anim.play("idle")
		buttons.draw_buttons()


func _process(delta):
	homeworkbar.value = homeworkbar.max_value - homework_timer.time_left
	actionbar.value = actionbar.max_value - action_timer.time_left
	
	clock_min.rotation_degrees.z = -180 + 360 * -((gametime * gametimecount + (gametime - game_timer.time_left)) / (gametime * gametimemax)) # sorry for this kinda convoluted equation i don't know how it got here but hey it works ?? ?? 
	


func _on_game_timer_timeout():
	# every time the parent comes in
	
	gametimecount += 1
	
	if gametimecount >= gametimemax:
		end_game(true)
	
	buttons.hide_buttons()
	
	text_bubble.visible = true
	
	if doingaction:
		text_bubble_sprite.modulate = "#D23842"
		text_bubble_label.text = "WHY YOU NO DO WORK!!"
		parent_anim.play("door_open_bad")
		stop_action()
	else:
		
		text_bubble_sprite.modulate = "#fefefa"
		text_bubble_label.text = "good!"
		parent_anim.play("door_open")
		
	yield(parent_anim, "animation_finished")
	text_bubble.visible = false
	buttons.draw_buttons()
	
	
func go_fast(value):
	if value:
		buttons.hide_buttons()
		Engine.time_scale = 2
	else:
		buttons.draw_buttons()
		Engine.time_scale = 1.0
		
		
func end_game(val):
	# stop everything
	get_tree().paused = true
	if val: # if ya winning
		winscreen.visible = true
	else: # lost the game
		losescreen.visible = true

func play_sound(id:String, play:bool):
	get_node("Audio/" + id).playing = play

func _on_homework_timer_timeout():
	end_game(false)

