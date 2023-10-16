extends CharacterBody2D

var sensitivity = 180
var gravity = 1000
var max_rotation = 55

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#gravity
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("p1left"):
		rotation_degrees += -sensitivity * delta
	if Input.is_action_pressed("p1right"):
		rotation_degrees += sensitivity * delta
		
	rotation_degrees = clamp(rotation_degrees, -max_rotation, max_rotation)
	
	if Input.is_action_just_pressed("p1use"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_released("p1right") or Input.is_action_just_released("p1left"):
		velocity += -transform.y.normalized() * 500
	
	move_and_slide()
