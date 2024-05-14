extends Node2D

class_name GameController

var turn = 0
var players:Array[Player]
var timer: Timer
var round_card:Card;
var selected_card:Card;
var prev_turn

@export var turn_panel:Panel
@export var card_container:Card_Container
@export var player_container:CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.connect("timeout", onTimeOut.bind());
	for player in player_container.get_children():
		players.append(player) 
		player.connect("card_thrown", on_card_throw.bind())
	instantiate_cards()

func onTimeOut():
	if turn != 0:
		players[turn].throw_card()
	if turn == 0:
		turn_panel.show()
		for card in players[0].hand:
			card.selectable = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):

	# if elapsed_time > 500 && turn != 0:
	# 	players[turn].throw_card()
	# 	start_time = Time.get_ticks_msec()

	# if elapsed_time > 1500 && turn == 0:
	# 	start_time = Time.get_ticks_msec()
	# 	turn_panel.show()
	# 	for card in players[0].hand:
	# 		card.selectable = true

func instantiate_cards():
	var card_distirbutor = Card_Distributor.new()
	var distributed_card =card_distirbutor.distribute_card()
	for i in players.size() :
		players[i].hand.append_array(distributed_card[i])

	# while(!card_distirbutor.callbreak_rule(players_hand[0])):
		# card_distirbutor = card_distirbutor.distribute_card()
	var player_hand= []

	for i in 13:
		var card_slot = Control.new() 
		var card_instance = players[0].hand[i]
		card_instance.scale= Vector2.ONE * 0.2
		card_slot.add_child(card_instance)
		card_container.add_child(card_slot)
		player_hand.append(card_instance)
		card_instance.connect("card_dragged",on_drag.bind())
		card_instance.connect("card_thrown", on_card_throw.bind())
	

func on_drag(card_):
	selected_card = card_

func on_card_throw(card_):
	turn = (turn + 1) % players.size()
	round_card = card_
	if turn != 0:
		turn_panel.hide()
	card_.selectable = false


func can_throw_card(card):
	if card.value.contains(round_card.card_value[0]):
		return true
	return false


func _on_area_2d_input_event(viewport, event, shape_idx):
	if selected_card != null && selected_card.selected && event.is_released():
		selected_card.target_parent = get_tree().root.get_node("GameScene/ui_canvas/card_holder")
		selected_card.target_position = get_viewport_rect().size/2 - (selected_card.size / 2 * selected_card.scale.x / 2)
		selected_card.target_scale = Vector2.ONE* 0.1
# Replace with function body.
