extends Label

onready var signal_bus = get_node("/root/SignalBus")
onready var count = get_node("/root/Game/Fish_in_inventory_count")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	count.text = str(signal_bus.fish_in_inventory)
