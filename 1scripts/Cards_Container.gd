extends HBoxContainer

class_name  Card_Container

var start_time
func _ready():
	start_time = Time.get_ticks_msec()

func _process(delta):
	var	time_now = Time.get_ticks_msec()
	var elapsed_time = time_now - start_time
	if elapsed_time > 1000:
		scale.x = lerp(scale.x, 1.0, 10*delta)

	# if Input.is_action_just_released("reload"):
	# 	for i in get_child_count():
	# 		remove_child(get_child(i))
	# 	instantiate_card()




