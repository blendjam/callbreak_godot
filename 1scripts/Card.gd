extends TextureRect

class_name Card

var selected = false
var card_value = "0X"
var target_parent
var target_position = Vector2.ZERO
var target_scale = Vector2.ONE * 0.2
var selectable = true
var old_parent
signal card_dragged
signal card_thrown
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
	if !selectable: return

	if selected && game_controller.turn == 0:
		var touch_offset = Vector2(0, size.y * scale.y)
		global_position = lerp(global_position, get_global_mouse_position() - touch_offset, 10 * delta)
		z_index = 100
		card_dragged.emit(self)

	elif target_position != Vector2.ZERO:
		global_position = lerp(global_position, target_position, 10 * delta)
		scale = lerp(scale,target_scale, 10 * delta )
		if target_parent.find_child(name) == null:
			reparent(target_parent)
		if old_parent != target_parent && game_controller.turn == 0:
			old_parent.hide()
		z_index = 100

	else:
		position = lerp(position, Vector2.ZERO, 10* delta)
		rotation = lerp_angle(rotation, 0, 10*delta)
		z_index = 0

	if global_position.distance_to(target_position) <= 0.01 && scale.x <=target_scale.x + 0.01:
		card_thrown.emit(self)
		selectable = false


func _gui_input(event):
	if event is InputEventScreenTouch  && selectable:
		selected = true

	if event is InputEventScreenTouch && !event.is_pressed():
		selected = false


func throw_to_center():
	target_parent = get_tree().root.get_node("GameScene/ui_canvas/card_holder")
	target_position = get_viewport_rect().size/2 - (size / 2 * scale.x / 2)
	target_scale = Vector2.ONE* 0.1
