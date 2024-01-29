extends CharacterBody2D


const SPEED = 160.0
const JUMP_VELOCITY = -320.0
var SPEED_OFFSET = 53.0
@export var health : int = 2;
@export var show_dialogue = false

@onready var sprite = $sprite;
@onready var hitbox = $shape;
@onready var hearts = $Camera2D/heart_container

@onready var paper_airplane = preload("res://game_objects/throwables/PaperAirplaneThrowableObject/PaperAirplaneThrowableObject.tscn");
@onready var tennis_ball = preload("res://game_objects/throwables/TennisBallThrowableObject/TennisBallThrowableObject.tscn");
@onready var dolphin = preload("res://game_objects/throwables/DolphinThrowableObject/DolphinThrowableObject.tscn")
@onready var homing_pigeon = preload("res://game_objects/throwables/HomingPigeonThrowableObject/HomingPigeonThrowableObject.tscn");
@onready var throwables = [tennis_ball,paper_airplane,dolphin,homing_pigeon]
@onready var current_throwable = tennis_ball
var is_throwing : bool = false;
var max_jumps : int = 1;
var jumps_remaining : int = 1;
var is_hurting : bool = false;
var is_dead := false
enum states{IN_GAME,KNEEL,PET}
@export var state = states.IN_GAME

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var projectile_scale = 1.0;
var gravity_modifier = 1.0;
var SINE_WAVES_TO_ADD = 0;

signal health_changed(gained : bool);
signal dead(selfNode)
signal item_obtained(buff,debuff,throwable_name)
var rng = RandomNumberGenerator.new()
var found_wally = false;
func _ready():

  sprite.play('run');
  

func _enter_tree() -> void:
  GlobalSignal.add_emitter('dead', self)
  
  
func _exit_tree() -> void:
  GlobalSignal.remove_emitter('dead', self)


func _input(event):
  if is_hurting || found_wally:
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

func get_input() -> float:
  if is_dead || found_wally:
    #sprite.animation = 'tumble'
    return 1.0
  
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
  if show_dialogue:
    $dialogue.show();
  else:
    $dialogue.hide()
  # Add the gravity.
  
  if not is_on_floor():
    velocity.y += gravity * delta * gravity_modifier
  
  var direction = 0.0;
  if !is_throwing && !is_hurting:
    direction = get_input();

  if is_dead:
    var new_vel = velocity.move_toward(Vector2.ZERO, SPEED / 46.0)
    velocity = new_vel
  else:
    velocity.x = SPEED + direction * SPEED_OFFSET;

  if !sprite.is_playing():
    sprite.play(sprite.animation);

  if sprite.animation == 'slide' || sprite.animation == 'slide_and_prepare_to_throw':
    hitbox.rotation = PI / 2;
    hitbox.position.y = 10
  else:
    hitbox.rotation = 0;
    hitbox.position.y = 0;

  if found_wally && (state != states.KNEEL || state == states.PET):
    velocity.x = 0;
    sprite.animation = 'idle'
  if state == states.KNEEL:
    sprite.animation = 'kneel';
  elif state == states.PET:
    sprite.animation = 'pet_wally'
    velocity = Vector2.ZERO
    if !sprite.is_playing():
        sprite.play('pet_wally')
  move_and_slide();
  
  if is_on_floor():
    jumps_remaining = max_jumps
  
  for i in get_slide_collision_count():
    var collision = get_slide_collision(i);
    if collision.get_collider().has_method('explode'):
      collision.get_collider().explode();
      get_hit();


func die() -> void:
  velocity.x = SPEED # NOTE: Without this, velocity resets to 0 on death. I couldn't figure out why, so this is my hack around it. :P
  is_hurting = true
  sprite.play('tumble')
  is_dead = true
  await get_tree().create_timer(1.0).timeout
  dead.emit(self)

  
func get_hit():
  health -= 1;
  health_changed.emit(false);
  if health <= 0:
    die()
  else:
    is_hurting = true;
    sprite.play('tumble');


    
func consume_bone(buff,debuff):
    var buff_flavor;
    match buff:
        'health':
            health += 1
            health_changed.emit(true);
            buff_flavor = 'Health up'
        'speed':
            SPEED_OFFSET += 27;
            buff_flavor = 'Speed up'
        'projectile_size':
            projectile_scale += 0.5;
            buff_flavor = 'Projectile size up'
        'jump':
            max_jumps += 1;
            jumps_remaining = max_jumps
            buff_flavor = "Jumps +1"
    var debuff_flavor;
    match debuff:
        'speed':
            SPEED_OFFSET -= 27;
            debuff_flavor = 'Speed down'
        'low_gravity': 
            gravity_modifier *= 0.667
            debuff_flavor = 'Low gravity'
        'sine':
            SINE_WAVES_TO_ADD += 1;
            debuff_flavor = 'Weird projectiles'
    
    var possible_throwables = [];
    for i in throwables:
        if i != current_throwable:
            possible_throwables.append(i);
    current_throwable = possible_throwables[rng.randi_range(0,2)];
    $Thrower.currentThrowable = current_throwable
    var throwable_instance = current_throwable.instantiate();
    var throwable_name = throwable_instance.name.replace('ThrowableObject','')
    item_obtained.emit(buff_flavor,debuff_flavor,throwable_name);
    
        


func _on_sprite_animation_finished():
    match sprite.animation:
        'die':
          sprite.animation = ''
        'tumble':
            is_hurting = false;
            is_throwing = false;
            if not is_dead:
              sprite.play('run');
            else:
              sprite.play('die')

        'slide_and_throw':
            is_throwing = false;
        'throw':
            is_throwing = false;
        'kneel':
            state = states.PET
    pass # Replace with function body.
