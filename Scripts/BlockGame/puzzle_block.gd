extends Node3D

@onready var block: CSGBox3D = $CSGBox3D

var rotating := false
var target_angle := 0.0
var rotation_speed := 180.0 # degrees per second

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left") and not rotating:
		# Start rotation
		rotating = true
		target_angle = block.rotation_degrees.z - 90.0
	elif Input.is_action_just_pressed("right") and not rotating:
		# Start rotation
		rotating = true
		target_angle = block.rotation_degrees.z + 90.0
		
	if rotating:
		# Rotate smoothly towards the target
		block.rotation_degrees.z = move_toward(block.rotation_degrees.z, target_angle, rotation_speed * delta)

		# Stop when we reach the target
		if is_equal_approx(block.rotation_degrees.z, target_angle):
			block.rotation_degrees.z = target_angle
			rotating = false
