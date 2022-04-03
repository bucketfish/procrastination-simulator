extends Camera

var normalized_pos = Vector2()
var viewport_size

func _input(event):
	if event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)
		viewport_size = get_viewport().get_visible_rect().size
		normalized_pos.x = event.position.x / viewport_size.x
		normalized_pos.y = event.position.y / viewport_size.y
	self.translation.x = 0.5 + normalized_pos.x / 5
	self.translation.y = 1.5 + (0 - normalized_pos.y) / 5
	
	#print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)
