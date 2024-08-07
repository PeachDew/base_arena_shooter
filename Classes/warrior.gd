extends Node2D

@onready var ultimate : Ultimate = $Ultimate

func _ready() -> void:
	
	ultimate.buff_time= 15.0
	ultimate.buffs = [["vigor", 5],["might", 20]] # IMPLEMENT MULTIPLIERS eg. might = (might + 20) * 1.5
	ultimate.has_buffs_misc_particles = [preload(PATHS.PARTICLES_CONVERGINGSTRIPS_WHITE2RED)]
	ultimate.buff_projectile_particles = [preload(PATHS.PARTICLES_PROJECTILE_TRAIL_ORANGE2RED)]
