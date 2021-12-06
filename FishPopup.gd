extends Node2D

onready var signal_bus = get_node("/root/SignalBus")
onready var fish_pic_sprite = get_node("FishPic")
onready var fish_name = get_node("Fish_name")
onready var fish_weight = get_node("Fish_weight")
onready var keep_fish_button = get_node("keep_fish")
onready var release_fish_button = get_node("release_fish")

var local_fish 

func _ready():
	signal_bus.connect("fish_popup", self, "on_fish_popup")
	pass

func on_fish_popup(fish):
	print("fish popup should appear")
	visible = true
	fish_name.text = fish.Name
	fish_weight.text = fish.RarityWeight
	local_fish = fish
	fish_pic_sprite.texture = load(fish.PictureLocation)
		

func _process(delta):
	if visible:
		if Input.is_action_pressed("ui_accept"):
			if local_fish.Name == "Roach":
				signal_bus.roach_counter += 1
			elif local_fish.Name == "Pike":
				signal_bus.pike_counter += 1
			elif local_fish.Name == "Brown Trout":
				signal_bus.trout_counter += 1
			visible = false
		if Input.is_action_pressed("ui_cancel"):
			visible = false
			
