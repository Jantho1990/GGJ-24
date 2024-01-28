extends Node


const song_names = {
  'gameplay': null
}

var _currentSong: AudioStreamPlayer


func play(song_name: String) -> void:
  var songNode = find_child(song_name)
  if not songNode:
    push_error('MusicManager.play(): Could not find song with name "%s", aborting.' % [song_name])
    return
  if _currentSong == songNode:
    return
  _currentSong = songNode
  _currentSong.play()


func restart_current_song() -> void:
  if not _currentSong:
    return
    
  _currentSong.play()
