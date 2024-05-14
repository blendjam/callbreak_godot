extends TextureRect

class_name Card

var selected = false
var card_value = "0X"
var target_parent
var target_position = Vector2.ZERO
var target_scale = Vector2.ONE * 0.2
var selectable = false
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

func throw():
	var target_parent = get_tree().root.get_node("GameScene/ui_canvas/card_holder")
	var card_instance = self
	if find_child(card_instance.get_name()) != null || target_parent.find_child(card_instance.get_name()) != null: return

	add_child(card_instance)
	card_instance.scale= Vector2.ONE * 0.2
	card_instance.target_position = get_viewport_rect().size/2 - (card_instance.size / 2 * card_instance.scale.x / 2)
	card_instance.target_scale = Vector2.ONE * 0.1
	card_instance.target_parent = target_parent
	if card_instance.global_position.distance_to(card_instance.target_position) <= 0.01 && scale.x <=card_instance.target_scale.x + 0.01:
		card_thrown.emit(card_instance)

# func _draw():
# 	var diff = global_position - get_global_mouse_position()
# 	var target_rotation = rad_to_deg(diff.angle())
# 	draw_line(position, get_local_mouse_position(), Color.RED, 10)
# 	print(target_rotation)

func _physics_process(delta):

	if selected && game_controller.turn == 0:
		var touch_offset = Vector2(0, size.y * scale.y)
		global_position = lerp(global_position, get_global_mouse_position() - touch_offset, 10 * delta)
		z_index = 100
		card_dragged.emit(self)

	elif target_position != Vector2.ZERO:
		global_position = lerp(global_position, target_position, 10 * delta)
		scale = lerp(scale,target_scale, 10 * delta )
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

	if global_position.distance_to(target_position) <= 0.01 && scale.x <=target_scale.x + 0.01:
		card_thrown.emit(self)
		# if position.length() >= 0.01:
			# position = lerp(position, Vector2.ZERO, 10 * delta )
		# else:
			# position = Vector2.ZERO

func _gui_input(event):
	if event is InputEventScreenTouch  && selectable:
		selected = true

	if event is InputEventScreenTouch && !event.is_pressed():
		selected = false


