extends KinematicBody2D

onready var signal_bus = get_node('/root/SignalBus')
onready var player = get_node('../Player')
var FishGeneration

var rng = RandomNumberGenerator.new()

var fish_json

var fish_name: String
var price: int
var pictureLocation: String
var rarity: String
var strength: float

var speed: int = 20
var mass: int
var velocity: Vector2
var swim_dir: Vector2

var swim_dir_timer

func init_stats(fish):
    fish_json = fish
    fish_name = fish.Name
    price = fish.Coins
    pictureLocation = fish.PictureLocation
    rarity = fish.RarityWeight
    strength = fish.Strength
    mass = fish.Mass

func _ready():
    FishGeneration = get_parent().get_node("RandomGeneration")
    var fish = FishGeneration._item_generation()
    init_stats(fish)
    swim_dir_timer = Timer.new()
    add_child(swim_dir_timer);

    rng.randomize()
    swim_dir_timer.wait_time = rng.randf_range(1, 3)
    swim_dir_timer.start()

    swim_dir_timer.connect('timeout', self, "change_swim_dir")
    swim_dir = random_swim_dir()
    velocity = swim_dir

func random_swim_dir():
    rng.randomize()
    var x = rng.randf_range(0.2, 1)
    var y = rng.randi_range(-1, 1)

    return Vector2(x, y)

func change_swim_dir():
    swim_dir = random_swim_dir()


func _physics_process(delta):
    var dir_to_mouse = position.direction_to(get_global_mouse_position())
    var dot = swim_dir.normalized().dot(dir_to_mouse)


    velocity += swim_dir

    velocity = velocity.normalized() * strength

    if Input.is_action_pressed("cast"):
        velocity += dir_to_mouse * 40

    velocity = move_and_slide(velocity, Vector2.UP)


    if dot < 0.0:
        var _cur_dps = lerp(0, player.strength_ps, abs(dot))
        strength -= lerp(0, player.strength_ps, abs(dot)) * delta

    pass
