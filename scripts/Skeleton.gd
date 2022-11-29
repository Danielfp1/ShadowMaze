 extends KinematicBody2D

onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite: Sprite = get_node("Sprite")

var player_ref = null
var velocity: Vector2

#Flags
var can_die: bool = false
var can_attack: bool = false

export (int) var speed

#Vida
export (int) var health = 6

#Knockback
export (bool) var receives_knockback: bool = true
export (float) var knockback_modifier: float = 30

func _physics_process(_delta: float) -> void:
	move()
	animate()
	verify_direction()
	
func move() ->void:
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction: Vector2 = distance.normalized()
		var distance_length: float = distance.length()
		if distance_length <= 28:
			velocity = Vector2.ZERO
			can_attack = true
		else:
			velocity = speed * direction
			can_attack = false
	else:
		velocity = Vector2.ZERO
	velocity = move_and_slide(velocity)

func animate() -> void:
	if can_die:
		animation.play("Death")
		set_physics_process(false)
	elif velocity != Vector2.ZERO:
		animation.play("Walk")
	elif receives_knockback==false:
		animation.play("Hit")
	elif can_attack:
		animation.play("Attack")
		$attack.play()
	else:
		animation.play("Idle")

func verify_direction() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func on_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body

func on_body_exited(body):
	if body.is_in_group("player"):
		player_ref = null
 
func hit() -> void:
	receive_knockback(player_ref.global_position)
	health=health-1
	if health<0:
		kill()

func kill() -> void:
	can_die = true

func receive_knockback(damage_source_pos: Vector2):
	if receives_knockback:
		var knockback_direction = damage_source_pos.direction_to(self.global_position)
		var knockback = knockback_direction * knockback_modifier
		global_position += knockback
		

func on_Animation_animation_finished(anim_name):
	if anim_name == "Death":
		queue_free()
