extends CharacterBody2D

var sensitivity = 180
var gravity = 1000
var max_rotation = 55

@export var collisionpath: NodePath
@onready var collision := get_node(collisionpath)

@export var spritepath: NodePath
@onready var sprite = get_node(spritepath)

@export var camerapath: NodePath
@onready var camera = get_node(camerapath)

@onready var width = collision.shape.size.x

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#gravity
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("p1left") and not Input.is_action_pressed("p1right"):
		rotation_degrees += -sensitivity * delta
	
	if Input.is_action_pressed("p1right") and not Input.is_action_pressed("p1left"):
		rotation_degrees += sensitivity * delta
		
	rotation_degrees = clamp(rotation_degrees, -max_rotation, max_rotation)
	
	if rotation_degrees < 0:
		change_pivot_point("left")
	else:
		change_pivot_point("right")
	
	if Input.is_action_just_pressed("p1use"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_released("p1right") or Input.is_action_just_released("p1left"):
		#velocity += -transform.y.normalized() * 500
		pass
	
	move_and_slide()


func change_pivot_point(left_or_right):
	var before = collision.position.x
	if left_or_right == "left" and collision.position.x != width/2:
		collision.position.x = width/2
		camera.position.x = width/2
	if left_or_right == "right" and collision.position.x != -width/2:
		collision.position.x = -width/2
		camera.position.x = -width/2
	position -= transform.x.normalized() * (collision.position.x - before)
