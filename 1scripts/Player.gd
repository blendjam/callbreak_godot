extends TextureRect

class_name Player

var hand:Array[Card]
var bid
signal card_thrown

func throw_card():
  hand[0].throw()
  # if card_instance.global_position.distance_to(target_position) <= 0.01 && scale.x <=target_scale.x + 0.001:
		# var new_parent = get_tree().root.get_node("GameScene/card_layer/card_holder")
		# reparent(new_parent)
		# old_parent.hide()
		# z_index = 0



