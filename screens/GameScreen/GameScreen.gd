extends Screen

@onready var player_hearts = $UI/player_hearts
@onready var progress_bar = $UI/progress_bar
@onready var player = $player
@onready var item_popup = $CursedItem/ItemPopover
var heart_texture  = load("res://sprites/player/heart.png")
func _enter_tree() -> void:
  GlobalSignal.add_listener('dead', self, '_on_GlobalSignal_dead')



func _ready():
    for i in 5:
        var heart = TextureRect.new();
        heart.texture = heart_texture;

        player_hearts.add_child(heart)
  

func _process(delta):
    if progress_bar != null:
       progress_bar.value = 100*( player.position.x / (9600*3))
  
func _on_GlobalSignal_dead(deadNode: Node) -> void:
  if deadNode.is_in_group('player'):
    ScreenManager.change_screen('EndgameScreen')
    
func _on_player_health_changed(gained):
    if gained:
        var heart = TextureRect.new();
        heart.texture = heart_texture;
        player_hearts.add_child(heart)
    else:
        if player_hearts.get_children().size() > 0:
            player_hearts.remove_child(player_hearts.get_children()[0])


func _on_player_item_obtained(buff, debuff, throwable_name):
    item_popup.pause_game()
    item_popup.get_node('Margin/VBox/Attributes/Buff').text = buff;
    item_popup.get_node('Margin/VBox/Attributes/Debuff').text = debuff;
    item_popup.get_node('Margin/VBox/Attributes/Weapon').text = 'New Weapon: ' + throwable_name
    item_popup.show();
    pass # Replace with function body.


func _on_wally_detector_body_entered(body):
    if body.name == 'wally':
        body.state = body.states.WAIT
    pass # Replace with function body.


func _on_wally_wally_found():
    player.found_wally = true;
    progress_bar.hide();
    #$AnimationPlayer.play('RESET');
    $AnimationPlayer.play('reunite_with_wally')
    pass # Replace with function body.
