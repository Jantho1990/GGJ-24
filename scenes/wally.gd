extends CharacterBody2D


const SPEED = 480.0
const JUMP_VELOCITY = -400.0
@onready var sprite = $sprite;
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum states{WAIT,BARK,WALK,FINAL,APPROACH}
@export var state = states.WAIT
var times_player_caught_up_to_wally = 0
signal wally_found
var wally_walks_to_play
func _ready():
    sprite.play('walk');

func _physics_process(delta):
    
    match state:
        states.WALK:
            velocity.x = SPEED;
        states.WAIT:
            velocity.x = 0;
            sprite.flip_h = false
            sprite.play("wait");
        states.BARK:
            velocity.x = 0;
            sprite.play('bark')
        states.FINAL:
            velocity.x = 0;
            sprite.play("wait");
        states.APPROACH:
            velocity.x = 0;
            sprite.flip_h = true;
            sprite.play('walk');
            
        
            

    move_and_slide()


func _on_player_detector_body_entered(body):

    if body.name == 'player':
        if times_player_caught_up_to_wally == 0:
            state = states.FINAL
            wally_found.emit()
        else:
            state = states.BARK
        
        
    pass # Replace with function body.


func _on_sprite_animation_finished():
    if sprite.animation == 'bark':
        times_player_caught_up_to_wally += 1
        state = states.WALK
        sprite.play('walk')
    pass # Replace with function body.
