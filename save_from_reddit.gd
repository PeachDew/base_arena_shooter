extends Node

var midrun_save_array : Dictionary 
var MIDRUN_SAVE_FILE = "user://savegame.save" #I assume you are using this from the docs.

func mid_run_save(): 
	midrun_save_array.clear() 
	
	var root_level = get_node("/root/RootLevel") 
	var map_node = get_node("/root/RootLevel/GameLevel") 
	var save_object_nodes = get_tree().get_nodes_in_group("PersistObject") 
	var save_ui_nodes = get_tree().get_nodes_in_group("PersistUI")

	for save_node in save_object_nodes:
		if save_node.is_inside_tree() == false:
			save_node.queue_free()
		else:
			#I'm setting "map_node" as the owner of all of these nodes I want to 
			#persist, because this is the top of the tree that I'm going to be 
			#converting into my packed scene

			if save_node != map_node:
				save_node.owner = map_node

			#Now we're going to iterate through all the nodes I've said need to 
			# persist, and check if any of them have scripts attached. If they do, 
			# then we want to copy the variables inside of that script - not just 
			# the exported ones - into a dictionary we can save and load later
			var node_script: GDScript = save_node.get_script()
			if node_script != null:
				var node_variables = node_script.get_script_property_list()
				var save_name = "path_" + str(save_node.get_path())
				midrun_save_array[save_name] = {}
				
				#I've used the node path as a way to generate unique keys for the 
				#dictionary I'm storing all this data in, and a way to know how to 
				# get it back out of the dictionary when we load it all
				for variable in node_variables:
					var variable_name = str(variable.name)
					
					#We're going to tell it not to save any variables that are nodes
					# themselves - this avoids recursion within the dictionary, 
					# which breaks the var2str method we're going to use, 
					# and also allows the nodes to correctly set up their various onready 
					# var references to other nodes when they're reinstantiated upon load
					#I don't have any so this is not an issue for me, keeping it anyway
					if save_node.get(variable_name) is Node:
						pass
					else:
						midrun_save_array[save_name][variable_name] = var_to_str(save_node.get(variable_name))
	# Okay, now we've got our big chunky dictionary containing both the global 
	# variables and the (non-node) variables of every single node we intend to pack 
	# up that has a script attached to it, we're going to save it to a file
	var file = FileAccess.open(MIDRUN_SAVE_FILE, FileAccess.WRITE)
	file.store_var(midrun_save_array)
	file.close()
	# Next is just to pack up the node at the top of it all that will retain 
	# things for us like position, visibility, etc, of our nodes, and save 
	# that as well, creating a snapshot of our scene
	var packed_scene = PackedScene.new()
	packed_scene.pack(map_node)
	ResourceSaver.save(packed_scene, "res://Saves/saved_run.tscn") #They flipped these in Godot 4??
	
func load_saved_run():
	# The first part of the loading is pretty standard, we open up our save file
	#  as long as there's one to open, and we update the global game data 
	# script's global variables with what we saved previously
	if not FileAccess.file_exists(MIDRUN_SAVE_FILE):
		return
	var save_game = FileAccess.open(MIDRUN_SAVE_FILE, FileAccess.READ)
	midrun_save_array = save_game.get_var()
	#removed the global data as I do not have that

	# Now we load the PackedScene resource, creating, if you will, the skeleton 
	#of the scene we created a snapshot of, and laying it out on our scene tree first

	var packed_scene = load("res://saved_run.tscn")
	# Instance the scene
	var loaded_scene = packed_scene.instance()
	get_node("/root/RootLevel").add_child(loaded_scene)

	#And now that we've got the skeleton, we're going to flesh it all out with 
	#those many custom variables we wanted to stay the same. We're going to open
	# up their various scripts, referencing their dictionary entries by using 
	# their node path to determine what the key is in the dictionary.

	var save_object_nodes = get_tree().get_nodes_in_group("PersistObject")

	for save_node in save_object_nodes:

		var node_script: GDScript = save_node.get_script()
		if node_script != null:
			var node_name = "path_" + str(save_node.get_path())
			var node_data = midrun_save_array[node_name]
			for variable in node_data.keys():
				save_node.set(variable, str_to_var(node_data[variable]))
