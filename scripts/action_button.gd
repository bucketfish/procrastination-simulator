extends TextureButton


export var action:String

onready var label = $ActionButtonLabel
onready var main = get_node("/root/Main")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_label(data):
	self_modulate = data[data.keys()[0]].colour
	label.text = data[data.keys()[0]].text
	action = data.keys()[0]


func _on_ActionButtonCenter_pressed():
	$Click.play()
	main.do_action(action)
