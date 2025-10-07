extends Control


@onready var freq_slider: HSlider = $ColorRect/VBoxContainer/HBoxContainer/VBoxContainer/freq_slider

@onready var gain_slider: HSlider = $ColorRect/VBoxContainer/HBoxContainer/VBoxContainer3/gain_slider

@onready var graph: Control = $ColorRect/Graph
@onready var feedback: Label = $ColorRect/Label
#@onready var camera: Camera2D = $Camera2D


var shake_strength := 0.0
var shake_decay := 3.0
var noise := 0.0


var target_wave = {}
var player_wave = {}

# parameters
var target_freq := 2.0
var target_phase := 0.0
var target_gain := 1.0

var phase:float
#var diff 
var missAlignTimer:=0.0
var miss_alligned=false;

func _ready():
	randomize()
	# randomize target wave
	target_freq = int(randf_range(1.0, 25.0))
	target_phase = randf_range(0, TAU)
	target_gain = int(randf_range(0.5, 10))
	update_player()
	graph.queue_redraw()

func _process(_delta):
	update_player()
	graph.queue_redraw()
	var diff=give_feedback()
	phase=_updatePhase(_delta)
	
	# Update camera shake based on diff
	#shake_strength = lerp(shake_strength, diff * 2.0, 0.1)  # smoother transitions
	#_apply_camera_shake(_delta,diff)
	
	# Update noise intensity for graph
	noise = lerp(noise, diff * 0.1, 0.1)

	
	#Wave reset logic:
	if(miss_alligned):
		missAlignTimer+=1*_delta
		if(missAlignTimer>=10):
			resetWave()
	else:
		missAlignTimer=0
	
	

func update_player():
	player_wave = {
		"freq": freq_slider.value,
		"phase": phase,
		"gain": gain_slider.value
	}

func give_feedback():
	var diff = abs(target_wave_diff())
	if diff < 0.05:
		feedback.text = "Aligned! Phase out to destroy."
		feedback.modulate = Color.GREEN
		miss_alligned=false
	elif diff < 0.2:
		feedback.text = "Almost there..."
		feedback.modulate = Color.YELLOW
		miss_alligned=false
	else:
		feedback.text = "Misaligned..."
		feedback.modulate = Color.RED
		miss_alligned=true
	return diff

func target_wave_diff() -> float:
	# compute normalized diff between player and target
	var f_diff = abs(target_freq - player_wave.freq) / 5.0
	#var p_diff = abs(wrapf(target_phase - player_wave.phase, -PI, PI)) / PI
	var g_diff = abs(target_gain - player_wave.gain) / 2.0
	#return (f_diff + p_diff + g_diff) / 3.0
	return (f_diff + g_diff) / 2.0

func _updatePhase(delta):
	if(player_wave.phase>=-100):
		player_wave.phase-= 2* delta
	else:
		player_wave.phase=0
	
	return float(player_wave.phase)

func resetWave():
	missAlignTimer = 0
	# Randomize new AI (target) wave instead of player wave
	target_freq = randi_range(1.0, 25.0)
	target_phase = randi_range(0, TAU)
	target_gain = randi_range(0.5, 10.0)
	
	# Optionally, also scramble player sliders
	freq_slider.value = randi_range(1.0, 25.0)
	gain_slider.value = randi_range(0.5, 10.0)
	
	# reset phase
	phase = 0
	
	feedback.text = "AI scrambled console!"
	feedback.modulate = Color.ORANGE

#func _apply_camera_shake(delta):
	#if camera:
		#if shake_strength > 0.01:
			#var offset = Vector2(
				#randf_range(-shake_strength, shake_strength),
				#randf_range(-shake_strength, shake_strength)
			#)
			#camera.offset = offset
			#shake_strength = max(shake_strength - shake_decay * delta, 0)
		#else:
			#camera.offset = Vector2.ZERO
#func _apply_camera_shake(delta, diff):
	#if camera:
		## Scale target shake intensity based on diff
		#var target_shake = clamp(diff * 10.0, 0.0, 8.0)
#
		## Smoothly move current shake strength toward target
		#shake_strength = lerp(shake_strength, target_shake, delta * 3.0)
#
		## Apply shake offset
		#if shake_strength > 0.01:
			#var offset = Vector2(
				#randf_range(-shake_strength, shake_strength),
				#randf_range(-shake_strength, shake_strength)
			#)
			#camera.offset = offset
		#else:
			#camera.offset = Vector2.ZERO
