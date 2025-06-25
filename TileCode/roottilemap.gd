extends TileMap

const DIRECTION_MARKER_LAYER : int = 1
const atlas_coord_2_direction : Dictionary = {
	Vector2i(0,3): "left",
	Vector2i(1,3): "right",
	Vector2i(0,4): "up",
	Vector2i(1,4): "down",
	Vector2i(0,2): "bush",
}

@export var exclude_direction_main_path : String = ""
var last_room_main_path : Room

func get_direction_marker_local_coords(room: TileMap, direction: String) -> Array:
	var all_coords : Array = []
	for coords in room.get_used_cells(DIRECTION_MARKER_LAYER):
		var atlas_coords : Vector2i = room.get_cell_atlas_coords(DIRECTION_MARKER_LAYER, coords)
		var curr_direction : String = atlas_coord_2_direction[atlas_coords]
		if curr_direction[0] == direction[0]:
			all_coords.append(room.map_to_local(coords))
	if !(len(all_coords)):
		push_warning("get_direction_marker_local_coords() cannot find markers for specified direction.")
	return all_coords

func _ready() -> void:
	#move_room_a_relative_of_room_b($R_RD, $SR_U,"up")
	#move_room_a_relative_of_room_b($R_LRU,$R_RD,"right")
	#move_room_a_relative_of_room_b($R_D,$R_LRU,"up")
	#move_room_a_relative_of_room_b($R_L,$R_LRU,"right")
	var skeleton_out : Dictionary = generate_map_skeleton(10,10)
	var map_skeleton : Array = skeleton_out['map_skeleton']
	#var all_rooms_coords : Array[Vector2i] = skeleton_out['all_rooms_coords']
	#var spawn_coords : Vector2i = skeleton_out['spawn_coords']
	print(get_perimeter_rooms_coords(map_skeleton))
	for row in map_skeleton:
		print(row)
	
	#TODO: Place rooms given skeleton
	# place rooms starting from spawn?
	
	# Placing additional branches
	# -- we have:
	# -- map_skeleton
	# -- all_rooms_coords AND nodes
	# -- idea 1: (total_rooms, num_expansions_per_loop (ne)
	# -- loop()
	# -- get perimeter rooms
	# -- choose (ne) room to be expansion
	# ---- find neighbor rooms to chosen rooms
	# ---- if > 1 neighbor room (n) eg. l, r, u
	# ------ choose branches (1, n), eg. 2
	# ------ choose branch directions eg. l, r / l, u / r, u
func add_branches(
	map_skeleton: Array, 
	num_loops: int = 10, num_expansions_per_loop: int = 1):
		for i in range(num_loops):
			var perimeter_rooms_coords : Array[Vector2i] = get_perimeter_rooms_coords(map_skeleton)
			perimeter_rooms_coords.shuffle()
			for j in range(num_expansions_per_loop):
				var room_coords : Vector2i = perimeter_rooms_coords[j]
				# Find neighbor rooms
					# ---- if > 1 neighbor room (n) eg. l, r, u
					# ------ choose branches (1, n), eg. 2
					# ------ choose branch directions eg. l, r / l, u / r, u

func get_perimeter_rooms_coords(map_skeleton: Array) -> Array[Vector2i]:
	var perimeter_rooms_coords : Array[Vector2i] = []
	for i in range(len(map_skeleton)):
		var row : Array[String] = map_skeleton[i]
		for j in range(len(row)):
			var cell : String = row[j]
			if (!cell and #up,down,left,right has something
				(i != 0 and map_skeleton[i-1][j])
				or (i < len(map_skeleton)-1 and map_skeleton[i+1][j])
				or (j != 0 and map_skeleton[i][j-1])
				or (j < len(row)-1 and map_skeleton[i][j+1])
			):
				perimeter_rooms_coords.append(Vector2i(j,i))
	return perimeter_rooms_coords

func get_available_directions(curr: Vector2i, map_skeleton: Array) -> Array:
	var available_directions : Array = ["l","r","u","d"]
	if (curr.x >= len(map_skeleton[0])-1 
		or map_skeleton[curr.y][curr.x+1]):
		available_directions.erase("r")
	if (curr.y >= len(map_skeleton)-1 
		or map_skeleton[curr.y+1][curr.x]):
		available_directions.erase("d")
	if (curr.x <= 0
		or map_skeleton[curr.y][curr.x-1]):
		available_directions.erase("l")
	if (curr.y <= 0
		or map_skeleton[curr.y-1][curr.x]):
		available_directions.erase("u")
	return available_directions

func generate_map_skeleton(
	size_x: int, size_y: int, 
	main_path_length: int = 5,
	#place_rooms: bool = true
	) -> Dictionary:
	var map_skeleton : Array = []
	var all_rooms_coords : Array[Vector2i] = []
	var all_rooms : Array[Room] = []
	var directions_array : Array[String] = []
	
	for i in range(size_y):
		var row_arr : Array[String] = []
		row_arr.resize(size_x)
		row_arr.fill("")
		map_skeleton.append(row_arr)
		
	var spawn : Vector2i = Vector2i(randi_range(0,size_x-1), randi_range(0,size_y-1))
	var curr_last_mainpath : Vector2i = spawn
	all_rooms_coords.append(spawn)
	for i in range(main_path_length+1):
		var available_directions : Array
		available_directions = get_available_directions(curr_last_mainpath, map_skeleton)
		
		if len(available_directions):
			var chosen_direction: String = available_directions.pick_random()
			
			if i < main_path_length:
				map_skeleton[curr_last_mainpath.y][curr_last_mainpath.x] += chosen_direction
			
			var room_to_be_placed: Room
			if len(all_rooms): # Not first room
				print(map_skeleton[curr_last_mainpath.y][curr_last_mainpath.x])
				if i < main_path_length:
					room_to_be_placed = get_room(2,2, map_skeleton[curr_last_mainpath.y][curr_last_mainpath.x])
				else:
					room_to_be_placed = get_room(1,1, map_skeleton[curr_last_mainpath.y][curr_last_mainpath.x])
				add_child(room_to_be_placed)
				move_room_a_relative_of_room_b(room_to_be_placed, all_rooms[-1], directions_array[-1])
			
			else:
				room_to_be_placed = get_room(1,1, map_skeleton[curr_last_mainpath.y][curr_last_mainpath.x])
				add_child(room_to_be_placed)
			
			all_rooms.append(room_to_be_placed)
			available_directions.erase(chosen_direction)
			
			if i == main_path_length:
				break
			match chosen_direction:
				"l":
					curr_last_mainpath.x -= 1
				"r":
					curr_last_mainpath.x += 1
				"u":
					curr_last_mainpath.y -= 1
				"d":
					curr_last_mainpath.y += 1
			
			map_skeleton[curr_last_mainpath.y][curr_last_mainpath.x] = inverse_direction_dict[chosen_direction]
			all_rooms_coords.append(curr_last_mainpath)
			directions_array.append(chosen_direction)
		else:
			push_warning("Dead end found before finishing building main path. (roottilemap.gd)")
	
	return {
		"map_skeleton": map_skeleton,
		"all_rooms_coords": all_rooms_coords,
		"all_rooms": all_rooms,
		"spawn_coords": spawn,
		"directions_array": directions_array
	}

var inverse_direction_dict : Dictionary = {
	"up": "down",
	"down": "up",
	"left": "right",
	"right": "left",
	"u": "d",
	"d": "u",
	"l": "r",
	"r": "l"
}

func grow_main_path(end : bool = false): #does not incorporate forbidden directions
	var selected_direction : String = last_room_main_path.get_available_branches().pick_random()
	var selected_room : Room
	if end:
		selected_room = get_room(1,1,inverse_direction_dict[selected_direction])
	else:
		selected_room = get_room(2,maximum_branches-current_branches,inverse_direction_dict[selected_direction])
		
	current_branches += len(selected_room.get_available_branches()) - 1
	add_child(selected_room)
	move_room_a_relative_of_room_b(selected_room,last_room_main_path,selected_direction)
	last_room_main_path = selected_room
	
	#while curr_path_length < path_length:
		#var picked_room : Room = get_room(1,maximum_branches-current_branches)
		#print("hello")
		
@export var maximum_branches : int = 10
var current_branches : int = 0
#func generate_map(path_length: int) -> void:
	## place starting room min 1 branch maximum 4 branches
	#var starting_room : Room = get_room(1, maximum_branches-current_branches)
	#current_branches += len(starting_room.get_available_branches()) - 1
	#add_child(starting_room)
	#
	#last_room_main_path = starting_room
	#
	#for i in range(2):
		#grow_main_path(false)
	#grow_main_path(true)
	
	
	# randomly build main path
	# Try: main path can discards one direction, eg. only LeftRightUp
	
	
	# use tilemap.get_used_rect()
	# and Rect2.intersects(another_rect) to see if potential room can be placed

const ROOMS_W_1BRANCH : String = "res://Rooms/W1_Fields/0/"
const ROOMS_W_2BRANCH : String = "res://Rooms/W1_Fields/1/"
const ROOMS_W_3BRANCH : String = "res://Rooms/W1_Fields/2/"
const ROOMS_W_4BRANCH : String = "res://Rooms/W1_Fields/3/"
const NUMROOMS_TO_DIR : Dictionary = {
	1: ROOMS_W_1BRANCH,
	2: ROOMS_W_2BRANCH,
	3: ROOMS_W_3BRANCH,
	4: ROOMS_W_4BRANCH,
}

func get_room(
	min_branches: int = 1,
	max_branches: int = 4,
	includes_direction: String = "",
	#excludes_direction: String = ""
	) -> Room:

	var num_branches : int = randi_range(
		min_branches,
		min(max_branches, 4),
	)
	
	#TODO: need to pick from rooms containing "include_direction"
	var files : Array = DirAccess.open(NUMROOMS_TO_DIR[num_branches]).get_files()
	if not len(files):
		push_error("selected dir in NUMROOMS_TO_DIR (roottilemap.gd) has no rooms.")
	
	if includes_direction:
		# remove rooms without specified direction
		for i in range(len(files)-1,-1,-1):
			var room_directions : String = files[i].get_slice(".",0).to_lower()
			for j in range(len(includes_direction)):
				if not(includes_direction[j].to_lower() in room_directions):
					files.pop_at(i)
					break
	print(files)
	
	var file_path : String = NUMROOMS_TO_DIR[num_branches] + files.pick_random()
	var room : Room = load(file_path).instantiate()
	room.initialise_available()
	return room

func move_room_a_relative_of_room_b(room_a: Room, room_b: Room, direction: String) -> void:
	var marker_a_direction : String
	var marker_b_direction : String
	match direction:
		"r":
			marker_a_direction = "l"
			marker_b_direction = "r"
		"l":
			marker_a_direction = "r"
			marker_b_direction = "l"
		"u":
			marker_a_direction = "d"
			marker_b_direction = "u"
		"d":
			marker_a_direction = "u"
			marker_b_direction = "d"
	var room_a_marker_coords : Array = get_direction_marker_local_coords(room_a, marker_a_direction)
	var room_b_marker_coords : Array = get_direction_marker_local_coords(room_b, marker_b_direction)
	print("move a_b:"+direction)
	print(marker_a_direction,room_a_marker_coords)
	print(marker_b_direction,room_b_marker_coords)
	var global_difference : Vector2 = room_a.to_global(room_a_marker_coords[0])-room_b.to_global(room_b_marker_coords[0])
	if len(room_a_marker_coords)>0 and len(room_b_marker_coords)>0:
		room_a.global_position -= global_difference
		match direction:
			"r":
				room_a.left_available = false
				room_b.right_available = false
			"l":
				room_a.right_available = false
				room_b.left_available = false
			"u":
				room_a.down_available = false
				room_b.up_available = false
			"d":
				room_a.up_available = false
				room_b.down_available = false
	else:
		push_warning("Cannot move room_a, cannot find matching direction markers.")
	
#func get_min_max_coords(used_cells: Array):
	#var min_atlas_x : int = used_cells[0][0]
	#var max_atlas_x : int = used_cells[0][0]
	#var min_atlas_y : int = used_cells[0][1]
	#var max_atlas_y : int = used_cells[0][1]
	#for i in range(1,len(used_cells)):
		#var cell_x : int = used_cells[i][0]
		#var cell_y : int = used_cells[i][1]
		#
		#if cell_x > max_atlas_x:
			#max_atlas_x = cell_x
		#elif cell_x < min_atlas_x:
			#min_atlas_x = cell_x
		#if cell_y > max_atlas_y:
			#max_atlas_y = cell_y
		#elif cell_y < min_atlas_y:
			#min_atlas_y = cell_y
	#
	#return {
		#"min_x": min_atlas_x,
		#"min_y": min_atlas_y,
		#"max_x": max_atlas_x,
		#"max_y": max_atlas_y,
	#}
