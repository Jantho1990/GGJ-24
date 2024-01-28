extends Area2D

const buffs = ['health','speed','projectile_size'];
const debuffs = ['speed','low_gravity','sine'];

@export var buff : String;
@export var debuff : String;
var rng = RandomNumberGenerator.new()
var rotate_t = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
    buff = buffs[rng.randi_range(0,2)];
    debuff = debuffs[rng.randi_range(0,2)];
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    rotate_t += delta
    $sprite.rotation = (PI/6)*sin(rotate_t);
    pass


func _on_body_entered(body):
    if body.has_method('consume_bone'):
        body.consume_bone(buff,debuff);
        
    pass # Replace with function body.
