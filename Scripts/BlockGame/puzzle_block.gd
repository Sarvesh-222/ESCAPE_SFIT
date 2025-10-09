extends Node3D
@export_group("Block Properties( Degree= n*90)")
@export var correctRotationDegree:=0 

@onready var block: CSGBox3D = $Area3D/CSGBox3D
@onready var area3d: Area3D = $Area3D


var rotating := false
var target_angle := 0.0
var rotation_speed := 180.0 # degrees per second

var blockSelected:=false
@onready var label_3d: Label3D = $Area3D/CSGBox3D/Label3D
@onready var label_3d_2: Label3D = $Area3D/CSGBox3D/Label3D2

func _ready() -> void:
	area3d.input_event.connect(_on_area3d_input_event)
	block.rotation_degrees.z=[0,90,180,270,360].pick_random() #initial rotation (random)
	
func _process(delta: float) -> void:
	label_3d.text=str(blockSelected)
	
	if(blockSelected):
		rotateBlock(delta)
	
		
func rotateBlock(delta:float):
	if Input.is_action_just_pressed("left") and not rotating:
		# Start rotation
		rotating = true
		target_angle = block.rotation_degrees.z - 90.0
		label_3d_2.text=str(target_angle)
	elif Input.is_action_just_pressed("right") and not rotating:
		# Start rotation
		rotating = true
		target_angle = block.rotation_degrees.z + 90.0
		label_3d_2.text=str(target_angle)
		
	if rotating:
		# Rotate smoothly towards the target
		block.rotation_degrees.z = move_toward(block.rotation_degrees.z, target_angle, rotation_speed * delta)

		# Stop when we reach the target
		if is_equal_approx(block.rotation_degrees.z, target_angle):
			block.rotation_degrees.z = target_angle
			rotating = false


func _on_area3d_input_event(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	# Detect left mouse click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		blockSelected=true

		
# Called when you click anywhere else
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			blockSelected = false
