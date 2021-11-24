extends KinematicBody2D

export var speed = 100
var screen_size
var is_casting
var velocity = Vector2()
var dir
var is_float_cast = false

enum Direction {LEFT, RIGHT, UP, DOWN}

onready var _animation_player = $AnimationPlayer
onready var _float = get_parent().get_node("Float")


func _ready():
	screen_size = get_viewport_rect().size
	_animation_player.connect("animation_finished", self, "_casting_finished")

func _casting_finished(anim_name):
	if anim_name == "CastThrow":
		_animation_player.play("Idle")
	pass

func _cast_animation():
	if Input.is_action_just_pressed("cast"):
		is_casting = true
	else:
		is_casting = false
	
	if Input.is_action_just_released("cast"):
		_animation_player.play("CastThrow")
		_float.position = Vector2(position.x + 30, position.y + 10)
		is_float_cast = true
	if is_casting:
		_animation_player.play("CastStart")
	pass
	

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		dir = Direction.RIGHT
		is_float_cast = false
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		dir = Direction.LEFT
		is_float_cast = false
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		dir = Direction.DOWN
		is_float_cast = false
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		dir = Direction.UP
		is_float_cast = false
	velocity = velocity.normalized() * speed

func _check_float():
	if is_float_cast:
		_float.visible = true
	else:
		_float.visible = false

func _process(delta):
	_check_float()
	_cast_animation()
	
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
