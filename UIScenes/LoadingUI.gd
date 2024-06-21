extends Control

@export var target_scene_path = "res://main.tscn"

var loading_status : int
var progress : Array[float]

@onready var progress_bar : TextureProgressBar = $LoadingProgressBar
var loading = false

signal pause_world
signal unpause_world

func _ready() -> void:
	visible = false
	
	var width = get_viewport_rect().size[0]
	var height = get_viewport_rect().size[1]
	
	position.x += width/2
	position.y += height/2
	
func _process(_delta: float) -> void:
	if loading:
		loading_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
		print(target_scene_path)
		match loading_status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				progress_bar.value = progress[0] * 100 # Change the ProgressBar value
			ResourceLoader.THREAD_LOAD_FAILED:
				print("Error. Could not load Resource")
			ResourceLoader.THREAD_LOAD_LOADED:
				unpause_world.emit()
				visible = false
				loading = false
				progress[0] = 0
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				loading = false
		


func start_loading_ui(destination_scene_path: String):
	target_scene_path = destination_scene_path
	pause_world.emit()
	visible = true
	loading = true
	


