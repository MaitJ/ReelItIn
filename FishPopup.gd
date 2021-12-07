extends Node2D

onready var signal_bus = get_node("/root/SignalBus")
onready var global_variables = get_node("/root/GlobalVariables")
onready var fish_pic_sprite = get_node("FishPic")
onready var fish_name = get_node("Fish_name")
onready var fish_weight = get_node("Fish_weight")
onready var keep_fish_button = get_node("keep_fish")
onready var release_fish_button = get_node("release_fish")

var local_fish
var caught_fishes = []

func _ready():
	signal_bus.connect("fish_popup", self, "on_fish_popup")
	signal_bus.connect("send_caught_fish", self, "on_send_caught_fish")
	pass

func on_fish_popup(fish):
	visible = true
	fish_name.text = fish.fish_name
	fish_weight.text = fish.rarity
	local_fish = fish
	fish_pic_sprite.texture = load(fish.pictureLocation)
	signal_bus.emit_signal("fish_caught")
	pass

func _process(_delta):
	if visible:
		if Input.is_action_pressed("ui_accept"):
			caught_fishes.append(local_fish)
			if local_fish.fish_name == "Roach":
				global_variables.roaches.append(local_fish.fish_json)
			elif local_fish.fish_name == "Pike":
				global_variables.pikes.append(local_fish.fish_json)
				#signal_bus.pike_counter += 1
			elif local_fish.fish_name == "Brown Trout":
				global_variables.trouts.append(local_fish.fish_json)
				#signal_bus.trout_counter += 1
			signal_bus.emit_signal("send_caught_fish", caught_fishes)
			local_fish.queue_free()
			visible = false
		if Input.is_action_pressed("ui_cancel"):
			visible = false
			
