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

func _ready():
	randomize()
	# randomize target wave
	target_freq = randf_range(1.0, 5.0)
	target_phase = randf_range(0, TAU)
	target_gain = randf_range(0.5, 1.5)
	update_player()
	graph.queue_redraw()

func _process(_delta):
	update_player()
	graph.queue_redraw()
	give_feedback()

func update_player():
	player_wave = {
		"freq": freq_slider.value,
		"phase": phase_slider.value,
		"gain": gain_slider.value
	}

func give_feedback():
	var diff = abs(target_wave_diff())
	if diff < 0.05:
		feedback.text = "Aligned! Phase out to destroy."
		feedback.modulate = Color.GREEN
	elif diff < 0.2:
		feedback.text = "Almost there..."
		feedback.modulate = Color.YELLOW
	else:
		feedback.text = "Misaligned..."
		feedback.modulate = Color.RED

func target_wave_diff() -> float:
	# compute normalized diff between player and target
	var f_diff = abs(target_freq - player_wave.freq) / 5.0
	var p_diff = abs(wrapf(target_phase - player_wave.phase, -PI, PI)) / PI
	var g_diff = abs(target_gain - player_wave.gain) / 2.0
	return (f_diff + p_diff + g_diff) / 3.0
