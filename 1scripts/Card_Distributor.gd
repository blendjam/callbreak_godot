extends Control

class_name Card_Distributor

var suits = ["C", "S", "D", "H"]
var cards = ["1", "2", "3", "4", "5", "6", "7","8", "9","T","J", "Q", "K"]
var deck: Array;
var start_time = 0
var turn = 0
var temp_card_array:Array[TextureRect]
@export var card_sprite:Texture
@export var players_container:CanvasLayer
var players_list:Array[Player]


func callbreak_rule(player_deck:Array[Card]):
	# Facecard and spades hunu paryo
	for i in player_deck.size():
		if player_deck[i].card_value.contains("S") || player_deck[i].card_value.contains("J") || player_deck[i].card_value.contains("Q") || player_deck[i].card_value.contains("K"):
			return true

	return false


func distribute_card():
	for i in 13:
		for j in  4:
			deck.append(str(cards[i] + suits[j]))

	var players_hand = [[], [], [], []]
	var players_count = 4
	for i in players_count:
		players_hand.append([])

	while(!deck.is_empty()):
		for i in players_count:
			var random_index = randi() % deck.size()
			var new_card = Card.new()
			new_card.set_card(deck[random_index])
			players_hand[i].append(new_card)
			deck.remove_at(random_index)
	return players_hand


# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = Time.get_ticks_msec()
	for player in players_container.get_children():
		print(player)
		players_list.append(player)
	for i in 4:
		var temp_card = TextureRect.new()
		temp_card.texture= card_sprite
		temp_card.scale= Vector2.ONE* 0.09
		add_child(temp_card)
		temp_card_array.append(temp_card)



func _process(delta):
	var	time_now = Time.get_ticks_msec()
	var elapsed_time = time_now- start_time
	if elapsed_time > 1000:
		for i in temp_card_array.size():
			var child = temp_card_array[i]
			child.global_position = lerp(child.global_position,  players_list[i].global_position +(child.size * child.scale) /2, 10 *delta)
	if elapsed_time > 2000:
		queue_free()

	# if(can_throw && i <= 52):
	# 	var child = temp_card_array[i]
	# 	child.global_position = lerp(child.global_position, player_locations[turn].global_position, 20 *delta)
	# 	print(player_locations[turn].global_position)
	# if i > 52:
	# 	stop()

