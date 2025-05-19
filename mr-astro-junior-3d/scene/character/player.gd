extends CharacterBody3D
class_name PlayerCharacter

#jump
@export var jump_height : float = 2.25
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3
@onready var skin = $MrAstroJnr


@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
# source: https://youtu.be/IOe1aGY6hXA?feature=shared

var action_jump = "jump"
var action_idle = "idle"
var action_run = "running"
var action_attack = "attack"

@export var base_speed := 5.0
@export var run_speed := 10
@export var defend_speed := 2.0
var speed_modifier := 1.0

@onready var camera = $CameraController/Camera3D

var movement_input := Vector2.ZERO
var last_movement_input := Vector2(0,1)

func _physics_process(delta: float) -> void:
	move_logic(delta)
	jump_logic(delta)
	attack_logic()
	move_and_slide()
	

func move_logic(delta) -> void:
	movement_input = Input.get_vector("left","right","forward","backward").rotated(-camera.global_rotation.y)
	var vel_2d = Vector2(velocity.x, velocity.z)
	
	if movement_input != Vector2.ZERO:
		var speed = base_speed
		
		vel_2d += movement_input * speed * delta * 8.0
		vel_2d = vel_2d.limit_length(speed) * speed_modifier
		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		skin.set_move_state(action_run)
		var target_angle = -movement_input.angle() + PI/2
		skin.rotation.y = rotate_toward(skin.rotation.y, target_angle, 6.0 * delta)
	else:
		vel_2d = vel_2d.move_toward(Vector2.ZERO, base_speed * 4.0 * delta)
		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		skin.set_move_state(action_idle)

	if movement_input:
		last_movement_input = movement_input.normalized()

func attack_logic() -> void:
	if Input.is_action_just_pressed("attack"):
		skin.attack()

func jump_logic(delta) -> void:
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_velocity
	else:
		skin.set_move_state(action_jump)
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta
