extends CharacterBody2D


const SPEED = 160.0
const JUMP_VELOCITY = -400.0
const SPEED_OFFSET = 100.0;
@export var health : int = 1000;

@onready var sprite = $sprite;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	sprite.play('run');

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		##velocity.y = JUMP_VELOCITY
		get_hit();

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("slow_down", "speed_up")
	print(direction)
	
	velocity.x = SPEED + direction * SPEED_OFFSET;


	move_and_slide()
	
func get_hit():
	health -= 1;
	if health <= 0:
		pass
		## DIE
	else:
		sprite.play('tumble');


func _on_sprite_animation_finished():
	match sprite.animation:
		'tumble':
			sprite.play('run');
	pass # Replace with function body.
