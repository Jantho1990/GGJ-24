extends Screen


func _enter_tree() -> void:
  GlobalSignal.add_listener('dead', self, '_on_GlobalSignal_dead')
  
  
func _on_GlobalSignal_dead(deadNode: Node) -> void:
  if deadNode.is_in_group('player'):
    ScreenManager.change_screen('EndgameScreen')
