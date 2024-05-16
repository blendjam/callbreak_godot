extends TextureRect

class_name Card

var selected = false
var card_value = "0X"
var target_parent
var target_position = Vector2.ZERO
var target_rotation =0  
var target_scale = Vector2.ONE * 0.2
var selectable = true
var moveable = true
var old_parent
signal card_dragged
signal card_thrown
signal reached_target
var game_controller:GameController

func set_card(number_):
	card_value = number_
	var card_image = Image.load_from_file("res://sprites/cards/"+ card_value +".png")
	texture = ImageTexture.create_from_image(card_image)
	return self

func _ready():
	old_parent = get_parent()
	game_controller = get_node("/root/GameScene/GameController")


func _physics_process(delta):
	if !moveable: return

	if selected && game_controller.turn == 0:
		var touch_offset = Vector2(0, size.y * scale.y)
		global_position = lerp(global_position, get_global_mouse_position() - touch_offset, 10 * delta)
		z_index = 100
		card_dragged.emit(self)

	elif target_position != Vector2.ZERO:
		global_position = lerp(global_position, target_position - pivot_offset, 10 * delta)
		scale = lerp(scale,target_scale, 10 * delta )
		rotation = lerp_angle(rotation, target_rotation, 10 * delta)

		selectable = false
		if target_parent.find_child(name) == null:
			reparent(target_parent)
		if old_parent != target_parent && game_controller.turn == 0:
			old_parent.hide()
		z_index = 100

	else:
		position = lerp(position, Vector2.ZERO, 10* delta)
		rotation = lerp_angle(rotation, 0, 10*delta)
		z_index = 0

	if has_reached_target():
		reached_target.emit(self)
		moveable = false

func has_reached_target():
	return global_position.distance_to(target_position) <= 0.01 && scale.x <=target_scale.x + 0.01

func _gui_input(event):
	if event is InputEventScreenTouch  && selectable:
		selected = true

	if event is InputEventScreenTouch && !event.is_pressed():
		selected = false
		if target_position != Vector2.ZERO:
			card_thrown.emit(self)

# static func is_greater(c1, c2):
# 	var i1 = get_value_index(c1.card_value[0])
# 	var i2 = get_value_index(c2.card_value[0])
# 	return i1 > i2

func is_greater(card_):
	var i1 = get_value_index(card_value[0])
	var i2 = get_value_index(card_.card_value[0])
	return i1 > i2

func get_value_index(value_):
	var values = ["2", "3", "4", "5", "6", "7","8", "9","T","J", "Q", "K", "1"]
	var index = 0
	for i in values.size():
		if value_ == values[i] :
			index = i
			break

	return index

func throw_to_center(target_rotation_ = 0):
	target_parent = get_tree().root.get_node("GameScene/ui_canvas/card_holder")
	target_position = get_viewport_rect().size/2 - (size / 2 * scale.x / 2)
	# pivot_offset = size/ 2
	target_scale = Vector2.ONE* 0.1
	target_rotation = target_rotation_

func go_to_target(target_, rotation_):
	target_position = target_
	target_rotation = rotation_
	moveable = true

