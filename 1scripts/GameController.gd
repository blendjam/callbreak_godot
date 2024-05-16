extends Node2D

class_name GameController

var turn = 0
var players:Array[Player]
var round_card:Card;
var round_card_list:Array[Dictionary]
var rounds = 0
var card_rotation = -45
var round_completed = false
var is_game_completed = false
var round_winner_list: Array[Player]
var selected_card:Card;
var center_card_holder

@export var timer: Timer
@export var turn_panel:Panel
@export var card_container:Card_Container
@export var player_container:CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	center_card_holder = get_tree().root.get_node("GameScene/ui_canvas/card_holder")
	timer.connect("timeout", onTimeOut.bind());
	for player in player_container.get_children():
		players.append(player) 
	instantiate_cards()



# Throw and start time or throw on timer end?
# First one is the right flow

# func onTimeOut():
# 	# if turn == 0: return
# 	var rand_card
# 	if turn == 0:
# 		rand_card = players[0].throw_random_card(round_card)
# 	else:
# 		rand_card = players[turn].throw_card(round_card)

# 	round_card_list.append({
# 		"card": rand_card,
# 		"player_index": turn
# 	})

# 	if (turn + 1) % 4 == 0:
# 		turn_panel.show()

# 	if round_card_list.size() == 3:
# 		timer.stop()
# 		await get_tree().create_timer(timer.wait_time).timeout		
# 		timer.start()

# 	if round_card_list.size() == 4:
# 		round_completed = true
# 	else:
# 		change_turn()

func on_player_card_throw(card_):
	var round_dict = {
		"card": card_,
		"player_index" : turn,
	}
	round_card_list.append(round_dict)
	if round_card_list.size() == 4:
		round_completed = true
	round_card = card_
	turn_panel.hide()
	timer.start()
	print("timer Started")

func bot_throw_card():
	var rand_card = players[turn].throw_card(round_card, card_rotation)
	round_card_list.append({
		"card":rand_card,
		"player_index":turn
	})
	if round_card_list.size() == 4:
		round_completed = true
	timer.start()


func onTimeOut():
	if round_completed:
		var winner_index = find_round_winner_index()
		for  card in round_card_list:
			var temp_card = card["card"]
			temp_card.go_to_target(players[winner_index].global_position + (temp_card.size * temp_card.scale) / 2, 0 )
		turn = winner_index
		round_completed = false
		round_card_list.clear()
		card_rotation = -45
		await get_tree().create_timer(timer.wait_time).timeout		
	else:
		change_turn()
	
	if rounds == 13:
		is_game_completed = true
	
	if is_game_completed: return
		
	if turn != 0:
		bot_throw_card()
	else:
		turn_panel.show()
	




# func _physics_process(delta):
# 	if round_completed:
# 		var winner_index = find_round_winner_index()
# 		for card in round_card_list:
# 			var temp_card = card["card"]
# 			temp_card.go_to_target(players[winner_index].global_position + (temp_card.size * temp_card.scale) / 2 )
# 		turn = winner_index
# 		round_completed = false
# 		round_card_list.clear()

# 		for card:Card in center_card_holder.get_children():
# 			card.connect("card_thrown", on_card_reached_player_position.bind() )


func on_card_reached_player_position(card_):
	card_.queue_free()
	timer.start()


func find_round_winner_index():
	var winner_index = 0
	var max_card = round_card_list[0]["card"]
	for card in round_card_list:
		if card["card"].is_greater(max_card):
			max_card = card["card"]
			winner_index = card["player_index"]

	return winner_index


func get_max_card():
	var max_card = round_card_list[0]
	for card in round_card_list:
		if card.card_value[1] > max_card.card_value[1]:
			max_card = card

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
	card_rotation += 45
	return turn


func can_throw_card(card):
	if card.value.contains(round_card.card_value[0]):
		return true
	return false


func _on_area_2d_input_event(viewport, event, shape_idx):
	if selected_card != null && selected_card.selected && event.is_released():
		selected_card.throw_to_center(card_rotation)		
