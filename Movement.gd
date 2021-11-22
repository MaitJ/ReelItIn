extends KinematicBody2D

export var speed = 100
var screen_size
var is_casting

onready var _animation_player = $AnimationPlayer

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
	
	if is_casting:
		_animation_player.play("CastStart")
	pass
	
func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	_cast_animation()
