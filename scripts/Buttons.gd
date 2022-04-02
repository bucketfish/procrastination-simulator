extends Control
var data_file

func _ready():
	var file = File.new()
	file.open("res://data/actions.json", File.READ)
	data_file = file.get_as_text()
	file.close()
	print(choose_random())
	draw_buttons(choose_random())

func choose_random():
	var actions_json = JSON.parse(data_file)
	var actions = actions_json.result
	var actions_array = actions.values()
	var output_array = []
	for i in 3:
		randomize()
		var random_num = randi() % actions_array.size()
		var chosen_action = actions_array[random_num]
		actions_array.remove(random_num)
		output_array.append(chosen_action)
	return(output_array)

func draw_buttons(data: Array):
	$ActionButtonLeft.self_modulate = data[0].colour
	$ActionButtonLeft/ActionButtonLabel.text = data[0].text
	$ActionButtonCenter.self_modulate = data[1].colour
	$ActionButtonCenter/ActionButtonLabel.text = data[1].text
	$ActionButtonRight.self_modulate = data[2].colour
	$ActionButtonRight/ActionButtonLabel.text = data[2].text
	visible = true
	
