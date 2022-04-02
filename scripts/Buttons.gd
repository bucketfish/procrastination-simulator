extends Control
var data_file

onready var action_left = $ActionButtonLeft
onready var action_center = $ActionButtonCenter
onready var action_right = $ActionButtonRight

func _ready():
	var file = File.new()
	file.open("res://data/actions.json", File.READ)
	data_file = file.get_as_text()
	file.close()
	


func choose_random():
	var actions_json = JSON.parse(data_file)
	var actions = actions_json.result
	var actions_array = actions.keys()
	var output_array = []
	for i in 3:
		randomize()
		var random_num = randi() % actions_array.size()
		var chosen_action = actions_array[random_num]
		actions_array.remove(random_num)
		output_array.append({chosen_action: actions[chosen_action]})
	return(output_array)

func draw_buttons():

	var data = choose_random()
	print(data)
	
	action_left.set_label(data[0])
	action_center.set_label(data[1])
	action_right.set_label(data[2])
	
	visible = true
	
