extends Node2D

class_name GameController

var turn = 0
var players:Array[Player]
var round_card:Card;
var round_winner_list: Array[Player]
var selected_card:Card;

@export var timer: Timer
@export var turn_panel:Panel
@export var card_container:Card_Container
@export var player_container:CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", onTimeOut.bind());
	for player in player_container.get_children():
		players.append(player) 
	instantiate_cards()

func onTimeOut():
	if turn != 0:
		players[turn].throw_card(round_card)
		var next_turn = change_turn()
		if next_turn == 0:
			turn_panel.show()
			timer.stop()

	elif turn == 0:
		players[0].throw_random_card(round_card)




# On player's hand
func instantiate_cards():
	var card_distirbutor = Card_Distributor.new()
	var distributed_card = card_distirbutor.distribute_card()
	for i in players.size() :
		players[i].hand.append_array(distributed_card[i])
	
	# while(!card_distirbutor.callbreak_rule(players_hand[0])):
		# card_distirbutor = card_distirbutor.distribute_card()

	var player_hand= []
	for i in 13:
		var card_slot = Control.new() 
		var card_instance = players[0].hand[i]
		card_slot.add_child(card_instance)
		card_container.add_child(card_slot)
		card_instance.scale= Vector2.ONE * 0.2
		player_hand.append(card_instance)
		card_instance.connect("card_dragged",on_drag.bind())
		card_instance.connect("card_thrown", on_player_card_throw.bind())
	

func on_drag(card_):
	selected_card = card_


func change_turn():
	turn = (turn + 1) % players.size()
	return turn

func on_player_card_throw(card_):
	change_turn()
	round_card = card_
	timer.start()
	turn_panel.hide()


func can_throw_card(card):
	if card.value.contains(round_card.card_value[0]):
		return true
	return false


func _on_area_2d_input_event(viewport, event, shape_idx):
	if selected_card != null && selected_card.selected && event.is_released():
		selected_card.throw_to_center()		
