extends Spatial


onready var character = $Character
onready var char_anim = $Character/AnimationPlayer

onready var buttons = $CanvasLayer/Buttons
# Called when the node enters the scene tree for the first time.
func _ready():
	buttons.draw_buttons()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
