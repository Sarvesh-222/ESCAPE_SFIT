extends Control  # instead of Node2D

@onready var parent = get_parent().get_parent()
@onready var console = get_parent().get_parent()
func _draw():
	var width = size.x
	var height = size.y
	var center_y = height / 2

	# Target (AI) waveform
	var prev_t = Vector2(0, center_y)
	for x in range(width):
		var t = x / 100.0
		var y = center_y - sin(t * parent.target_freq + parent.target_phase) * parent.target_gain * 50
		draw_line(prev_t, Vector2(x, y), Color.RED, 2)
		prev_t = Vector2(x, y)

	# Player waveform
	prev_t = Vector2(0, center_y)
	for x in range(width):
		var t = x / 100.0
		var noise_offset = randf_range(-console.noise * 20.0, console.noise * 20.0)
		var y = center_y - sin(t * console.player_wave.freq + console.player_wave.phase) * console.player_wave.gain * 50 + noise_offset
		draw_line(prev_t, Vector2(x, y), Color.YELLOW, 2)
		prev_t = Vector2(x, y)


	
