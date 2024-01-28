extends CharacterBody2D


const SPEED = 160.0
const JUMP_VELOCITY = -320.0
var SPEED_OFFSET = 53.0;
@export var health : int = 1000;

@onready var sprite = $sprite;
@onready var hitbox = $shape;
@onready var hearts = $Camera2D/heart_container
var is_throwing : bool = false;
var max_jumps : int = 1;
var jumps_remaining : int = 1;
var is_hurting : bool = false;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var projectile_scale = 1.0;
var gravity_modifier = 1.0;
var SINE_WAVES_TO_ADD = 0;

signal health_changed(gained : bool);

func _ready():
  sprite.play('run');

func _input(event):
  if is_hurting:
    return;
  if event.is_action_pressed('jump') && jumps_remaining > 0:
    jumps_remaining -= 1;
    #velocity.y = JUMP_VELOCITY;
    velocity.y += JUMP_VELOCITY;
  if event.is_action_pressed('fire'):
    pass
    ## Let the world know player is aiming
  if event.is_action_released("fire") && !is_throwing:
    is_throwing = true;
    match sprite.animation:
      'slide_and_prepare_to_throw':
        sprite.animation = 'slide_and_throw'
      _:
        sprite.animation = 'throw'
    pass
    ## Let the world know player throws

func get_input():
  if Input.is_action_pressed('jump') && Input.is_action_pressed('fire'):
    sprite.animation = 'jump_and_prepare_to_throw';
  elif Input.is_action_pressed('jump'):
    sprite.animation = 'jump';
  elif Input.is_action_pressed('fire'):
    sprite.animation = 'prepare_to_throw';
    
  if Input.is_action_pressed('slide') && Input.is_action_pressed('fire'):
    sprite.animation = 'slide_and_prepare_to_throw';
  elif Input.is_action_pressed('slide'):
    sprite.animation = 'slide';
  elif Input.is_action_pressed('fire'):
    sprite.animation = 'prepare_to_throw';
    
  
  else:
    sprite.animation = 'run';
    
  return Input.get_axis("slow_down","speed_up");

func _physics_process(delta):

  # Add the gravity.
  if not is_on_floor():
    velocity.y += gravity * delta
  
  var direction = 0.0;
  if !is_throwing && !is_hurting:
    direction = get_input();

  velocity.x = SPEED + direction * SPEED_OFFSET;

  if !sprite.is_playing():
    sprite.play(sprite.animation);

  if sprite.animation == 'slide' || sprite.animation == 'slide_and_prepare_to_throw':
    hitbox.rotation = PI / 2;
    hitbox.position.y = 10
  else:
    hitbox.rotation = 0;
    hitbox.position.y = 0;
  move_and_slide();
  
  if is_on_floor():
    jumps_remaining = max_jumps
  
  for i in get_slide_collision_count():
    var collision = get_slide_collision(i);
    if collision.get_collider().has_method('explode'):
      collision.get_collider().explode();
      get_hit();
  
func get_hit():
  health -= 1;
  health_changed.emit(false);
  if health <= 0:
    pass
    ## DIE
  else:
    is_hurting = true;
    sprite.play('tumble');


    
func consume_bone(buff,debuff):
    print(buff);
    print(debuff);
    match buff:
        'health':
            health += 1
            health_changed.emit(true);
        'speed':
            SPEED_OFFSET += 27;
        'projectile_size':
            projectile_scale += 0.5;
    match debuff:
        'speed':
            SPEED_OFFSET -= 27;
        'low_gravity': 
            gravity_modifier += 0.33
        'sine':
            SINE_WAVES_TO_ADD += 1;
        


func _on_sprite_animation_finished():
    match sprite.animation:
        'tumble':
            is_hurting = false;
            sprite.play('run');
        'slide_and_throw':
            is_throwing = false;
        'throw':
            is_throwing = false;
    pass # Replace with function body.
