extends Node


const SCREENS_DIR = 'res://screens'

var _currentScreen : Screen


func change_screen(new_screen_name: String) -> void:
  if not screen_exists(new_screen_name):
    push_error('ScreenManager.change_screen(): Screen does not exist at path, aborting. (%s)' % [get_screen_path(new_screen_name)])
    return
    
  if _currentScreen:
    _currentScreen.made_inactive.emit()
    get_tree().root.remove_child(_currentScreen)
    _currentScreen.queue_free()
  
  _currentScreen = load_screen(new_screen_name)
  if not _currentScreen:
    return
  get_tree().root.add_child(_currentScreen)
  _currentScreen.made_active.emit()
  print('changed screen to %s' % [_currentScreen])


func get_screen_path(screen_name: String) -> String:
  return '%s/%s/%s.tscn' % [SCREENS_DIR, screen_name, screen_name]


func load_screen(screen_name: String) -> Screen:
  var packedScreen = load(get_screen_path(screen_name))
  if not packedScreen:
    push_error('ScreenManager.load_screen(): Failed to load screen at path, aborting. (%s)' % [get_screen_path(screen_name)])
    return
  var loadedScreen = packedScreen.instantiate()
  if not loadedScreen is Screen:
    push_error('ScreenManager.load_screen(): Loaded file is not a Screen node, aborting. (%s)' % [loadedScreen])
    return
  return loadedScreen


func screen_exists(screen_name: String) -> bool:
  if FileAccess.file_exists(get_screen_path(screen_name)):
    return true
  return false
