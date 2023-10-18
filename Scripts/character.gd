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
var ground_torque = 120000
var air_torque = 6000
var on_floor = false
var jump_force = 800
var torqueless_zone = 5 #degrees (same as getaway shootout)
var turning = false
@onready var default_bounce = physics_material_override.bounce

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	lock_rotation = false
	if Input.is_action_pressed("p1left") and not Input.is_action_pressed("p1right"):
		turn(-1, delta)
	
	if Input.is_action_pressed("p1right") and not Input.is_action_pressed("p1left"):
		turn(1, delta)
		
	#rotation_degrees = clamp(rotation_degrees, -max_rotation, max_rotation)
	
#	if rotation_degrees < 0:
#		change_pivot_point("left")
#	else:
#		change_pivot_point("right")
	
	if Input.is_action_just_pressed("p1use"):
		get_tree().reload_current_scene()
	
	if (Input.is_action_just_released("p1right") or Input.is_action_just_released("p1left")) and on_floor:
		linear_velocity += -transform.y.normalized() * jump_force
		turning = false
		physics_material_override.bounce = default_bounce
		angular_velocity = 0
		pass
	
	#apply the bobble effect
	if rotation_degrees == 0:
		constant_torque = 0
	else:
		if on_floor: 
			if not in_torqueless_zone(): apply_torque(-rotation_degrees * ground_torque * delta)
		else: 
			if not in_torqueless_zone(): apply_torque(-rotation_degrees * air_torque * delta)
			if rotation_degrees == clamp(rotation_degrees,-torqueless_zone,torqueless_zone) and 0: #rotation degrees is within torqueless zone degrees
				constant_torque = 0
				if not turning: angular_velocity = 0


func turn(direction, delta):
	if on_floor or turning:
		physics_material_override.bounce = 0
		lock_rotation = true
		if rotation_degrees == clamp(rotation_degrees, -max_rotation, max_rotation) or rotation_degrees/abs(rotation_degrees) != direction:
			angular_velocity = sensitivity * delta * direction
		turning = true


func in_torqueless_zone():
	if rotation_degrees == clamp(rotation_degrees,-torqueless_zone,torqueless_zone):
		return true
	return false


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
