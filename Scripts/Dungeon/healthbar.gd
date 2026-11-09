
extends ProgressBar

@onready var damage_bar = $Damagebar
@onready var timer = $Timer
@onready var label = $Label

var health: float = 0.0
var target_health: float = 0.0

@export var health_speed: float = 3.0
@export var damage_speed: float = 3.0


func _process(delta: float) -> void:

	# Smoothly animate the main healthbar.
	value = lerp(value, target_health, health_speed * max_value * delta)

	# Only animate the damage bar after the timer finishes.
	if !timer.is_stopped():
		return

	damage_bar.value = move_toward(
		damage_bar.value,
		target_health,
		damage_speed * max_value * delta
	)


func set_health(new_health: float) -> void:

	var previous_health = target_health

	target_health = clampf(new_health, 0.0, max_value)

	# If taking damage, delay the damage bar.
	if target_health < previous_health:
		timer.start()
	else:
		# Healing: immediately set the damage bar's target.
		damage_bar.value = target_health
	
	if target_health <= 0.0:
		queue_free()
	
	label.text = (str(target_health))

func init_health(_health: float) -> void:
	
	health = _health
	target_health = _health

	max_value = _health
	value = _health

	damage_bar.max_value = _health
	damage_bar.value = _health
	
	label.text = (str(health)) 

func _on_timer_timeout() -> void:
	pass
