extends Resource
class_name ProjectileInfo

var projectile_packed_scene : PackedScene
var cooldown : float 
var speed : float 
var damage : float
var max_pierce : int
var lifetime : float 
var rotation : float 
var start_delay : float

func _init(pps: PackedScene, 
		cd : float, spd : float, dmg : float, 
		max_p : int, lt : float, rot : float, 
		sd: float) -> void:
	projectile_packed_scene = pps
	cooldown = cd
	speed = spd
	damage = dmg
	max_pierce = max_p
	lifetime = lt
	rotation = lt
	start_delay = sd
