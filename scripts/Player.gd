extends KinematicBody2D

onready var collision: CollisionShape2D = get_node("AttackArea/Collision")
onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite: Sprite = get_node("Sprite")

var velocity: Vector2
var can_die: bool = false
var can_attack: bool = false
var RunDownUp: bool = false

export (int) var speed

func _physics_process(_delta: float) -> void:
	move()
	attack()
	verify_direction()
	animate()
	

func move() -> void:
	var direction_vector: Vector2 = Vector2(
	Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
	Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	velocity = direction_vector * speed
	velocity = move_and_slide(velocity)


func attack() -> void:
	if Input.is_action_just_pressed("Attack") and not can_attack:
		can_attack = true


func animate() -> void:
	if can_die:
		animation.play("Death")
		set_physics_process(false)
	elif can_attack:
		animation.play("Attack")
		set_physics_process(false)
	elif velocity.x != 0:
		animation.play("Run")
	elif velocity.y > 0:
		animation.play("RunDown")
	elif velocity.y < 0:
		animation.play("RunUp")
	else:
		animation.play("Idle")

func verify_direction() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		collision.position = Vector2(22.5,-7.5)
	elif velocity.x < 0:
		sprite.flip_h = true
		collision.position = Vector2(-22.5,-7.5)
	elif velocity.y > 0:
		RunDownUp = true
	else:
		RunDownUp = false
		
func kill() -> void:
	can_die = true


func on_animation_finished(anim_name):
	if anim_name == "Death":
		var _reload: bool = get_tree().reload_current_scene()
	elif anim_name == "Attack":
		can_attack = false
		set_physics_process(true)
