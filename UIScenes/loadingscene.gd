extends Control
class_name LoadingScene

var target_scene_path = "res://main.tscn"

var loading_status : int
var progress : Array[float]

@onready var progress_bar : TextureProgressBar = $LoadingProgressBar

func _ready() -> void:
	if ScenesManager.target_scene_path:
		target_scene_path = ScenesManager.target_scene_path
		ScenesManager.target_scene_path = null
		
	ResourceLoader.load_threaded_request(target_scene_path)
	if get_tree().paused:
		get_tree().paused = false
	
func _process(_delta: float) -> void:
	print("HELLOOOO")
	loading_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100 # Change the ProgressBar value
		ResourceLoader.THREAD_LOAD_LOADED:
			# When done loading, change to the target scene:
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene_path))
		ResourceLoader.THREAD_LOAD_FAILED:
			# Well some error happend:
			print("Error. Could not load Resource")
