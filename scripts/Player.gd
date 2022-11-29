extends KinematicBody2D

onready var collision: CollisionShape2D = get_node("AttackArea/Collision")
onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite: Sprite = get_node("Sprite")

var velocity: Vector2

#Flags
var can_die: bool = false
var can_attack: bool = false

#Direção em que o Player esta voltado
var facingDirection: String = ""

#Velocidade de movimentação
export (int) var speed

#Vida
export (int) var health = 6
signal life_change(health)

var max_hearts: int = 3;
var hearts: float = max_hearts

func _ready() -> void:
	connect("life_change", get_parent().get_node("UI/Life"),"on_player_life_changed")
	emit_signal("life_change", max_hearts)

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
		$death.play()
		set_physics_process(false)
	elif can_attack:
		#Direção do ataque
		$sword.play()
		if facingDirection == "right":
			animation.play("AttackRight")
		elif facingDirection == "left":
			animation.play("AttackLeft")
		elif facingDirection == "up":
			animation.play("AttackUp")
		elif facingDirection == "down":
			animation.play("AttackDown")
		else:
			animation.play("AttackRight")
		set_physics_process(false)
	elif velocity.x > 0:
		animation.play("RunRight")
	elif velocity.x < 0:
		animation.play("RunLeft")
	elif velocity.y > 0:
		animation.play("RunDown")
	elif velocity.y < 0:
		animation.play("RunUp")
	else:
		#Direção em que o Player esta voltado
		if facingDirection == "right":
			animation.play("IdleRight")
		elif facingDirection == "left":
			animation.play("IdleLeft")
		elif facingDirection == "up":
			animation.play("IdleUp")
		elif facingDirection == "down":
			animation.play("IdleDown")
		else:
			animation.play("IdleDown")
			

func verify_direction() -> void:
	if velocity.x > 0:
		#Mover hitbox
		collision.rotation = 0
		collision.position = Vector2(22.5,-7.5)
		#Olhar para direita
		facingDirection = "right"
	elif velocity.x < 0:
		#Mover hitbox
		collision.rotation = 0
		collision.position = Vector2(-22.5,-7.5)
		#Olhar para esquerda
		facingDirection = "left"
	elif velocity.y > 0:
		#Mover hitbox
		collision.position = Vector2(-1,26)
		collision.rotation = 29.845
		#Olhar para baixo
		facingDirection = "down"
	elif velocity.y < 0:
		#Mover hitbox
		collision.position = Vector2(1,-26)
		collision.rotation = 29.845
		#Olhar para cima
		facingDirection = "up"
		
func hit() -> void:
	print("Player levou hit!")
	health=health-1
	hearts=hearts-0.5
	emit_signal("life_change", hearts)
	if health<=0:
		kill()

func kill() -> void:
	can_die = true

#Quando terminar alguma animação
func on_animation_finished(anim_name):
	if anim_name == "Death":
		var _reload: bool = get_tree().reload_current_scene()
	elif anim_name == "AttackRight" || anim_name == "AttackLeft" || anim_name == "AttackUp" || anim_name == "AttackDown":
		can_attack = false
		set_physics_process(true)


func _on_AttackArea_body(body):
	if body.is_in_group("enemy"):
		body.hit()


func on_Hurtbox_area_entered(area:Area2D):
	if area.is_in_group("hurt"):
		$hurt.play()
		hit()
