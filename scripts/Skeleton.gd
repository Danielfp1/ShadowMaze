 extends KinematicBody2D

onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite: Sprite = get_node("Sprite")

var player_ref = null
var velocity: Vector2

#Flags
var can_die: bool = false

export (int) var speed

func _physics_process(_delta: float) -> void:
	move()
	animate()
	verify_direction()
	
func move() ->void:
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction: Vector2 = distance.normalized()
		var distance_length: float = distance.length()
		if distance_length <= 17:
			velocity = Vector2.ZERO
			player_ref.kill()
		else:
			velocity = speed * direction
		#print(distance_length)
	else:
		velocity = Vector2.ZERO
	velocity = move_and_slide(velocity)

func animate() -> void:
	if can_die:
		#print("morreu!")
		animation.play("Death")
		set_physics_process(false)
	elif velocity != Vector2.ZERO:
		animation.play("Walk")
	else:
		animation.play("Attack")

func verify_direction() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func on_body_entered(body):
	print("Entrou" + body.name)
	if body.is_in_group("player"):
		player_ref = body

func on_body_exited(body):
	if body.is_in_group("player"):
		player_ref = null
 
func kill() -> void:
	can_die = true
