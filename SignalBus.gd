extends Node

#Float thingies
enum FloatState {BOBBING, TAKE, IDLE}
signal float_state_change(new_state)

signal fish_caught
signal fish_sell(fish)
signal shop_visible(state)

var gold_amount = 0

signal fish_popup(fish)
signal send_caught_fish(fishes)

signal fish_hooked(fish)


func _ready():
	pass


