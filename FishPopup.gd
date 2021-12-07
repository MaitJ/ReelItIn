extends Node2D

onready var signal_bus = get_node('/root/SignalBus')
onready var fish_pic_sprite = get_node('FishPic')
onready var popup_msg = get_node('Msg')

func _ready():
	signal_bus.connect("fish_popup", self, "on_fish_popup")
	pass

func on_fish_popup(fish):
	visible = true
	popup_msg.text = "You received: " + fish.fish_name
	fish_pic_sprite.texture = load(fish.pictureLocation)
	signal_bus.emit_signal("fish_caught")
	pass

func _process(delta):
	if visible:
		if Input.is_action_pressed("ui_accept"):
			visible = false
		if Input.is_action_pressed("ui_cancel"):
			visible = false
