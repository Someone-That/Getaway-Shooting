extends RigidBody2D

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
var ground_torque = 3000
var air_torque = 300
var on_floor = false
var jump_force = 800
var torqueless_zone = 5 #degrees (same as getaway shootout)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("p1left") and not Input.is_action_pressed("p1right"):
		angular_velocity = -sensitivity * delta
	
	if Input.is_action_pressed("p1right") and not Input.is_action_pressed("p1left"):
		angular_velocity = sensitivity * delta
		
	#rotation_degrees = clamp(rotation_degrees, -max_rotation, max_rotation)
	
#	if rotation_degrees < 0:
#		change_pivot_point("left")
#	else:
#		change_pivot_point("right")
	
	if Input.is_action_just_pressed("p1use"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_released("p1right") or Input.is_action_just_released("p1left"):
		linear_velocity += -transform.y.normalized() * jump_force
		angular_velocity = 0
		pass
	
	#apply the bobble effect
	if rotation_degrees == 0:
		constant_torque = 0
	else:
		if on_floor: constant_torque = -pow(abs(rotation_degrees),1) * (abs(rotation_degrees)/rotation_degrees) * ground_torque
		else: 
			constant_torque = -pow(abs(rotation_degrees),1.2) * (abs(rotation_degrees)/rotation_degrees) * air_torque
			if rotation_degrees == clamp(rotation_degrees,-torqueless_zone,torqueless_zone): #rotation degrees is within torqueless zone degrees
				constant_torque = 0
				angular_velocity = 0


func change_pivot_point(left_or_right):
	var before = collision.position.x
	if left_or_right == "left" and collision.position.x != width/2:
		collision.position.x = width/2
		camera.position.x = width/2
	if left_or_right == "right" and collision.position.x != -width/2:
		collision.position.x = -width/2
		camera.position.x = -width/2
	position -= transform.x.normalized() * (collision.position.x - before)


func _on_body_entered(body):
	on_floor = true


func _on_body_exited(body):
	on_floor = false
