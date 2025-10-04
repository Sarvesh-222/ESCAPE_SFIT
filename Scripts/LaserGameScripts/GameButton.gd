extends Area3D

var playerInRange:=false;
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var main_button: MeshInstance3D = $MainButton



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(playerInRange and Input.is_key_pressed(KEY_E)):
		print("Lasers Disabled")
		playerInRange=false


func _on_body_entered(body: Node3D) -> void:
	playerInRange=true
	animation_player.play("ButtonGlow")
	#main_button.get_surface_override_material(0).e


func _on_body_exited(body: Node3D) -> void:
	animation_player.play("ButtonGlow_off")
	playerInRange=false
