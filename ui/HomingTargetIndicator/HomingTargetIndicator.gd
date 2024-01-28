extends Control


@export var targetNode: Node2D :
  set = _set_targetNode


func _ready() -> void:
  if not targetNode:
    hide()
  GlobalSignal.add_listener('homing_target_identified', self, '_on_GlobalSignal_homing_target_identified')


func _physics_process(delta: float) -> void:
  if not targetNode:
    return
  elif not Global.object_exists(targetNode):
    _set_targetNode(null)
  position = targetNode.global_position


func _on_GlobalSignal_homing_target_identified(homingTarget: Node2D) -> void:
  _set_targetNode(homingTarget)


func _set_targetNode(value: Node2D) -> void:
  targetNode = value
  if not targetNode:
    hide()
    return
    
  if not $Crosshair:
    await self.ready
  
  show()
