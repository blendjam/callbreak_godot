extends TextureRect

class_name Player

var hand:Array[Card]
var bid

func can_throw_card(round_card:Card, card:Card):
	var rc_number = round_card.card_value[0]
	var rc_suit = round_card.card_value[1]
	var has_round_suit = false
	var has_bigger_number = false

	for c in hand:
		if c.card_value.contains(rc_suit):
			has_round_suit = true
			break

	if !has_round_suit: return true

	for c in hand:
		if c.card_value[0] > rc_number and c.card_value.contains(rc_suit):
			has_bigger_number = true
			break

	if has_bigger_number:	
		if card.card_value.contains(rc_suit) and card.card_value[0] > rc_number:
			return true
	elif card.card_value.contains(rc_suit):
		return true

	return false
	
	

func throw_card(round_card, target_rotation = 0):
	var card_container = Control.new()
	var rand_card = get_rand_from_hand()
	if round_card != null:
		while(!can_throw_card(round_card, rand_card)):
			rand_card = get_rand_from_hand()

	remove_from_hand(rand_card)
	card_container.add_child(rand_card)
	add_child(card_container)
	rand_card.scale= Vector2.ONE * 0.2
	rand_card.throw_to_center(target_rotation)
	return rand_card

func throw_random_card(round_card):
	var rand_card:Card = get_rand_from_hand() 
	remove_from_hand(rand_card)
	if(can_throw_card(round_card, rand_card)):
		rand_card.throw_to_center()
	return rand_card

func get_rand_from_hand():
	var random_index = randi() % hand.size()
	var rand_card = hand[random_index]
	return rand_card

func remove_from_hand(card_to_remove):
	var r_index = 0
	for i in hand.size():
		if hand[i] == card_to_remove:
			r_index = i

	hand.remove_at(r_index)




