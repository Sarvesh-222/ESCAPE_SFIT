extends Control

#@onready var freq_slider: HSlider = $VBoxContainer/freq_slider
#@onready var phase_slider: HSlider = $VBoxContainer/phase_slider
#@onready var gain_slider: HSlider = $VBoxContainer/gain_slider
@onready var freq_slider: HSlider = $VBoxContainer/HBoxContainer/VBoxContainer/freq_slider
@onready var phase_slider: HSlider = $VBoxContainer/HBoxContainer/VBoxContainer2/phase_slider
@onready var gain_slider: HSlider = $VBoxContainer/HBoxContainer/VBoxContainer3/gain_slider

@onready var graph: Control = $VBoxContainer/Graph
@onready var feedback: Label = $VBoxContainer/Label


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
	
	#Wave reset logic:
	if(miss_alligned):
		missAlignTimer+=1*_delta
		print(missAlignTimer)
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
