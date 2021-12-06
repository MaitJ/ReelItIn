extends Area2D

onready var signal_bus = get_node("/root/SignalBus")
onready var animation_player = get_node("AnimationPlayer")
var float_state

func _ready():
	signal_bus.connect("float_state_change", self, "on_float_state_change")
	pass

func on_float_state_change(new_state):
	float_state = new_state
	if float_state == signal_bus.FloatState.TAKE:
		animation_player.play("Take")
	else:
		animation_player.play("Flying")

func _process(_delta):
	if float_state == signal_bus.FloatState.BOBBING:
		animation_player.play("Bobbing")


