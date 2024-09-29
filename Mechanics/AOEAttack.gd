extends Area2D
class_name AOEAttack

@onready var warning_as2d : AnimatedSprite2D = $WarningAreaAnimation
@onready var explosion_as2d : AnimatedSprite2D = $ExplosionAnimation

const WARN_ANIMATION_NAME : String = "warn"
const EXPLODE_ANIMATION_NAME : String = "explode"

@export var damage : float
@export var warning_duration : float
var explode_duration : float

@export var explode_when_ready : bool = true
@export var queue_free_when_exploded : bool = true

var initialised : bool = false

var timer = 0.0
func _ready() -> void:
	
	set_warning_as2d_fps()
	initialised = true
	
	explosion_as2d.animation_finished.connect(on_explosion_as2d_animation_finished)
	
	explosion_as2d.hide()
	warning_as2d.hide()
	
	if explode_when_ready:
		start_explosion()

func set_warning_as2d_fps():
	var num_frames: int = warning_as2d.sprite_frames.get_frame_count(WARN_ANIMATION_NAME)
	warning_as2d.sprite_frames.set_animation_speed(
		WARN_ANIMATION_NAME,
		float(num_frames)/warning_duration
	)

func start_explosion():
	if initialised:
		# Wait for Warning Duration
		get_tree().create_timer(warning_duration).timeout.connect(on_warning_duration_timeout)
		warning_as2d.show()
		warning_as2d.play("warn")
		
	else:
		push_warning("explode() for AOEAttack called but not initialised is false.")

func on_warning_duration_timeout():
	warning_as2d.hide()
	explosion_as2d.show()
	explosion_as2d.play("explode")
	#deal damage
	
	for ar in get_overlapping_areas():
		if ar is Hurtbox:
			var attack := Attack.new()
			attack.damage = damage
			# function take_damage emits "damaged" signal
			ar.take_damage(attack)


func on_explosion_as2d_animation_finished():
	explosion_as2d.hide()
	
	if queue_free_when_exploded:
		queue_free()

	

