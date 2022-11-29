extends KinematicBody2D

export (float) var speed
var velocity: Vector2
var subir: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if subir:
		var direction_vector: Vector2 = Vector2.DOWN
		velocity = direction_vector * speed
		velocity = move_and_slide(velocity)
		print(velocity)


func _on_Ending_Sound_finished():
	$Music.play()
	subir = true
