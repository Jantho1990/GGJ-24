extends Node2D

var heart_texture  = load("res://sprites/player/heart.png")
@export var difficulty = 1;

@onready var jump_hazard_scene = load("res://scenes/hazards/jump_me.tscn");
@onready var breakable_hazard_scene = load("res://scenes/hazards/break_me.tscn");
@onready var slide_hazard_scene = load("res://scenes/hazards/slide_me.tscn");

var rng = RandomNumberGenerator.new()
@onready var hazards = [jump_hazard_scene,slide_hazard_scene,breakable_hazard_scene];

# Called when the node enters the scene tree for the first time.
func _ready():
    spawn_hazards()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func spawn_hazards():
    var spawn_points = generate_spawn_points();
    var spawn_pattern = []
    var easy_count = 0;
    var med_count = 0;
    var hard_count = 0;
    var last_spawn_pattern;
    for x_pos in spawn_points:
        var pattern_difficulty = 'easy';
        if rng.randf() < 0.25*difficulty:
            pattern_difficulty = 'medium';
        if rng.randf() < 0.25*difficulty && last_spawn_pattern != 'hard':
            pattern_difficulty = 'hard';
        match pattern_difficulty:
            'easy':
                spawn_pattern = [hazards[rng.randi_range(0,2)]];
                easy_count += 1
            'medium':
                spawn_pattern = [hazards[rng.randi_range(0,2)],hazards[rng.randi_range(0,1)]]
                med_count += 1
            'hard':
                spawn_pattern = [hazards[rng.randi_range(0,2)],hazards[rng.randi_range(0,1)],hazards[rng.randi_range(0,1)]]
                hard_count += 1
        last_spawn_pattern = pattern_difficulty;
        var hazard_idx = 1
        for hazard in spawn_pattern:
            var hazard_instance = hazard.instantiate();
            hazard_instance.position.x = x_pos + 96*hazard_idx;
            hazard_instance.position.y = hazard_instance.y_position;
            add_child(hazard_instance);
            hazard_idx += 1
        
    print('stage: ' + str(difficulty) + ' | ' + 'easy: ' + str(easy_count)+ ' | ' + 'med: ' + str(med_count)+ ' | ' + 'hard: ' + str(hard_count))
    pass

func generate_spawn_points():
    var spawn_points = [];
    for i in range(1,30):
        spawn_points.append(i*320)


    return spawn_points
    pass
