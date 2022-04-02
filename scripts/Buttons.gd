extends Control
var data_file

onready var action_left = $ActionButtonLeft
onready var action_center = $ActionButtonCenter
onready var action_right = $ActionButtonRight
onready var main = get_node("/root/main")

func _ready():
	pass
	

func choose_random():
	
	var actions_array = main.actions.keys()
	var output_array = []
	for i in 3:
		randomize()
		var random_num = randi() % actions_array.size()
		var chosen_action = actions_array[random_num]
		actions_array.remove(random_num)
		output_array.append({chosen_action: main.actions[chosen_action]})
	return(output_array)

func draw_buttons():
	var data = choose_random()
	print(data)
	
	action_left.set_label(data[0])
	action_center.set_label(data[1])
	action_right.set_label(data[2])
	
	visible = true
	
func hide_buttons():
	visible = false
