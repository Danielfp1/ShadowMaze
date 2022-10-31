extends KinematicBody2D

onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite: Sprite = get_node("Sprite")

var velocity: Vector2
var can_die: bool = false

export (int) var speed

func _physics_process(_delta: float) -> void:
	move()
	verify_direction()
	animate()
	

func move() -> void:
	var direction_vector: Vector2 = Vector2(
	Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
	Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	velocity = direction_vector * speed
	velocity = move_and_slide(velocity)

func animate() -> void:
	if can_die:
		animation.play("Death")
		set_physics_process(false)
	elif velocity != Vector2.ZERO:
		animation.play("Run")
	else:
		animation.play("Idle")

func verify_direction() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		
func kill() -> void:
	can_die = true


func on_animation_finished(anim_name):
	if anim_name == "Death":
		var _reload: bool = get_tree().reload_current_scene()
