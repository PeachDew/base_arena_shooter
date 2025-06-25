extends TileMap
#
#const POLYGON_AREA = 400.0
#const POLYGON_SIDES = 10
#
## Calculate polygon centroid
#func _calculate_centroid(polygon: Array):
	#var centroid = Vector2.ZERO
	#for point in polygon:
		#centroid += point
	#return centroid / polygon.size()
#
## Calculate the area of a polygon using the shoelace formula
#func _calculate_polygon_area(polygon: Array):
	#var n = polygon.size()
	#var area = 0.0
	#
	#for i in range(n):
		#var j = (i + 1) % n
		#area += polygon[i].x * polygon[j].y
		#area -= polygon[j].x * polygon[i].y
	#
	#return abs(area) * 0.5
#
#func _generate_constrained_polygon(sides: int):
	## Generate initial random points on a unit circle
	#var raw_points = []
	#for _i in range(sides):
		#var angle = randf() * 2 * PI
		#raw_points.append(Vector2(cos(angle), sin(angle)))
	#
	## Sort points by angle to create a consistent polygon shape
	#raw_points.sort_custom(func(a, b): 
		#return atan2(a.y, a.x) < atan2(b.y, b.x)
	#)
	#
	## Scale points to match desired area
	#var centroid = _calculate_centroid(raw_points)
	#var scaled_points = []
	#
	## Iterative scaling to approach target area
	#var scale_factor = 1.0
	#var max_iterations = 10
	#
	#for _iter in range(max_iterations):
		## Scale points from centroid
		#scaled_points.clear()
		#for point in raw_points:
			#scaled_points.append((point - centroid) * scale_factor + centroid)
		#
		#var current_area = _calculate_polygon_area(scaled_points)
		#var area_ratio = POLYGON_AREA / current_area
		#
		## Adjust scale factor
		#scale_factor *= sqrt(area_ratio)
		#
		## Stop if we're close enough
		#if abs(current_area - POLYGON_AREA) / POLYGON_AREA < 0.01:
			#break
	#
	#return scaled_points
#
##func generate_bush_polygon_outline():
	##var vertices = _generate_constrained_polygon(POLYGON_SIDES)
	### Place bushes along the polygon outline
	##for i in range(vertices.size()):
		##var start = vertices[i]
		##var end = vertices[(i + 1) % vertices.size()]
		##
		##var edge_length = start.distance_to(end)
		##var steps = max(floor(edge_length), 1)
		##
		##for j in range(steps + 1):
			##var t = float(j) / steps
			##var interpolated_point = start.lerp(end, t)
			##
			##var tile_pos = Vector2i(floor(interpolated_point.x), floor(interpolated_point.y))
			##
			##set_cell(
				##2,  # layer
				##tile_pos,
				##1,  # tile index
				##unbreakablebush_data['atlas_xy']
			##)
	##return vertices
#
#func generate_bush_polygon_outline():
	#var vertices = _generate_constrained_polygon(POLYGON_SIDES)
	## Increase density and reduce potential gaps
	#for i in range(vertices.size()):
		#var start = vertices[i]
		#var end = vertices[(i + 1) % vertices.size()]
		#var edge_length = start.distance_to(end)
		## Increase steps and add some randomness
		#var steps = max(ceil(edge_length * 1.5), 1)
		#
		#for j in range(steps + 1):
			#var t = float(j) / steps
			#var interpolated_point = start.lerp(end, t)
			## Add small random offset to break perfect linearity
			#var offset = Vector2(
				#randf_range(-0.3, 0.3), 
				#randf_range(-0.3, 0.3)
			#)
			#interpolated_point += offset
			#
			#var tile_pos = Vector2i(floor(interpolated_point.x), floor(interpolated_point.y))
			#
			#set_cell(
				#2,  # layer
				#tile_pos,
				#1,  # tile index
				#unbreakablebush_data['atlas_xy']
			#)
		#
		## Optional: Add extra density at vertices
		##set_cell(
			##2,
			##Vector2i(floor(start.x), floor(start.y)),
			##1,
			##unbreakablebush_data['atlas_xy']
		##)
	#return vertices
#
#var unbreakablebush_data : Dictionary = {
	#"atlas_xy": Vector2i(0,2),
	#"tile_id": 1
#}
#
#func pick_random_grass():
	#var pick : int = randi_range(1,100)
	#if pick >= 90:
		#return Vector2i(0,0)
	#elif pick >= 80:
		#return Vector2i(0,1)
	#elif pick >= 70:
		#return Vector2i(1,0)
	#elif pick >= 60:
		#return Vector2i(1,1)
	#else:
		#return Vector2i(2,0)
#
#func pick_random_bg():
	#var pick : int = randi_range(1,100)
	#if pick >= 95:
		#return Vector2i(3,0)
	#elif pick >= 90:
		#return Vector2i(5,0)
	#elif pick >= 85:
		#return Vector2i(3,2)
	#elif pick >= 80:
		#return Vector2i(5,2)
	#elif pick >= 75:
		#return Vector2i(3,4)
	#elif pick >= 70:
		#return Vector2i(5,4)
	#else:
		#return Vector2i(3,6)
#
#func _ready() -> void:
	#generate_bush_polygon_outline()
#
	#for i in range(-100,100):
		#for j in range(-100,100):
			#set_cell(
				#1, # layer
				#Vector2i(i,j), # coordinate
				#1, # tileset ID
				#pick_random_grass() # atlas coordinate
			#)
	#
	#for i in range(-100,100,2):
		#for j in range(-100,100,2):
			#var random_bg = pick_random_bg()
			#set_cell(
				#0, # layer
				#Vector2i(i,j), # coordinate
				#1, # tileset ID
				#random_bg
			#)
			#set_cell(
				#0, # layer
				#Vector2i(i,j) + Vector2i(0,1), # coordinate
				#1, # tileset ID
				#random_bg + Vector2i(0,1)
			#)
			#set_cell(
				#0, # layer
				#Vector2i(i,j) + Vector2i(1,0), # coordinate
				#1, # tileset ID
				#random_bg + Vector2i(1,0)
			#)
			#set_cell(
				#0, # layer
				#Vector2i(i,j) + Vector2i(1,1), # coordinate
				#1, # tileset ID
				#random_bg + Vector2i(1,1)
			#)
