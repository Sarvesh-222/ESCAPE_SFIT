extends Area3D
var init_positon_y:=0.0
var init_positon_x:=0.0

@export_group("MODES(Select Only One)")
@export var up_down:=true
@export var left_right:=false
@export var rotate:=false

@export_group("ATTRIBUTES")
@export var range:=50
@export var moveSpeed:=10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_positon_y=position.y
	init_positon_x=position.x
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(up_down):
		UpDown(delta)
	elif left_right:
		LeftRight(delta)
	pass

var isMovingUp:=true
func UpDown(delta:float):
	
	if(isMovingUp):   #Up movement
		if(position.y< init_positon_y+range):
			position.y+=moveSpeed*delta
		elif(position.y>= init_positon_y+range):
			isMovingUp=false
			init_positon_y=position.y
	else:			#Down MOvement
		if(position.y> init_positon_y-range):
			position.y-= moveSpeed*delta
		elif(position.y<= init_positon_y-range):
			isMovingUp=true
			init_positon_y=position.y
			
var isMovingLeft:=false
func LeftRight(delta:float):
		if !isMovingLeft:  #Right Movement
			if position.x<init_positon_x+range:
				position.x+=moveSpeed*delta
			elif position.x>= init_positon_x+range:
				isMovingLeft=true
				init_positon_x=position.x
		else:               #lEFT Movement
			if position.x>init_positon_x-range:
				position.x-=moveSpeed*delta
			elif position.x<= init_positon_x-range:
				isMovingLeft=false
				init_positon_x=position.x
			





func _on_body_entered(body: Node3D) -> void:
	print(body.name)
