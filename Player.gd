extends KinematicBody2D

enum PlayerState {
	STANDING,
	MOVING,
	FIGHTING
}

var fish_resource = load("res://Fish.tscn")

export var speed = 100
var screen_size
var is_casting
var gold_amount = 0
var velocity = Vector2()
var is_float_cast = false
var active_fish
var current_state = PlayerState.STANDING
var shop_is_visible = false

var strength_ps: float = 5

onready var _animation_player = $AnimationPlayer
onready var _float = get_parent().get_node("Float")
onready var signal_bus = get_node("/root/SignalBus")
onready var shop_pos = get_node("/root/Game/ShopNpc")
onready var fishing_line: Line2D = get_parent().get_node("Line2D")
onready var catch_area: Area2D = get_node("CatchArea")

var timer 
var bite_timer

func _ready():
	screen_size = get_viewport_rect().size

	timer = Timer.new()
	bite_timer = Timer.new()
	add_child(timer)
	add_child(bite_timer)

	_animation_player.connect("animation_finished", self, "_casting_finished")
	timer.connect("timeout", self, "fish_bite")
	bite_timer.connect("timeout", self, "missed_bite")
	catch_area.connect("body_entered", self, "fish_entered")
	signal_bus.connect("fish_caught", self, "fish_caught")

func fish_caught():
	fishing_line.clear_points()
	current_state = PlayerState.STANDING

func _casting_finished(anim_name):
	if anim_name == "CastThrow":
		_animation_player.play("Idle")
	pass

func _cast_animation():
	if !is_float_cast:
		if Input.is_action_just_pressed("cast"):
			is_casting = true
		else:
			is_casting = false
		
		if Input.is_action_just_released("cast"):
			_animation_player.play("CastThrow")
			after_cast()
		if is_casting:
			_animation_player.play("CastStart")

func fish_entered(body: Node):
	if body.name == "Fish":
		signal_bus.emit_signal("fish_popup", body)
	
func after_cast():
	_float.position = Vector2(position.x + 60, position.y + 10)
	is_float_cast = true
	signal_bus.emit_signal("float_state_change", signal_bus.FloatState.BOBBING)
	fishing_line.visible = true
	var rod_tip_pos = Vector2(position.x + 9, position.y - 14)
	draw_fishing_line(rod_tip_pos, _float.position)
	start_fishing()

func start_fishing():
	randomize()
	timer.wait_time = (randi() % 5)
	timer.start()
	pass

func fish_bite():
	#Emit rng function
	timer.stop()

	randomize()
	bite_timer.wait_time = (randi() % 1)
	signal_bus.emit_signal("float_state_change", signal_bus.FloatState.TAKE)
	bite_timer.start()


func missed_bite():
	bite_timer.stop()

func init_fish_fight():
	current_state = PlayerState.FIGHTING
	active_fish = fish_resource.instance()
	get_parent().add_child(active_fish)
	active_fish.position = _float.position
	pass

func hooking_check():
	if !bite_timer.is_stopped():
		if Input.is_action_just_pressed("cast"):
			bite_timer.stop()

			init_fish_fight()
			pass
			#Fish hooked - start fighting

func move_fishing_line():
	if current_state == PlayerState.FIGHTING:
		fishing_line.clear_points()
		fishing_line.add_point(Vector2(position.x + 9, position.y - 14))
		fishing_line.add_point(active_fish.position)

func draw_fishing_line(player_pos: Vector2, float_pos: Vector2):
	fishing_line.clear_points()
	var dy = 0
	for i in range(float_pos.x - player_pos.x):
		fishing_line.add_point(Vector2(player_pos.x + i, player_pos.y + dy))
		if dy < float_pos.y - player_pos.y:
			dy += 1

	pass

func get_input():
	if not current_state == PlayerState.FIGHTING:
		current_state = PlayerState.STANDING

		velocity = Vector2()
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

		if abs(velocity.x) > 0 or abs(velocity.y) > 0:
			is_float_cast = false
			current_state = PlayerState.MOVING

		velocity = velocity.normalized() * speed

func _check_float():
	if is_float_cast:
		_float.visible = true
	else:
		_float.visible = false
		fishing_line.visible = false

func _process(_delta):
	_check_float()
	if shop_is_visible == false:
		_cast_animation()
	hooking_check()
	move_fishing_line()
	
func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)

func _on_ShopNpc_body_entered(body):
	if body.name == "TileMap":
		return
	print(body.name)
	signal_bus.emit_signal("shop_visible", true)
	shop_is_visible = true

func _on_ShopNpc_body_exited(body):
	signal_bus.emit_signal("shop_visible", false)
	shop_is_visible = false
