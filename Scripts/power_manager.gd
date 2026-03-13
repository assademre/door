extends Node

signal power_cut
var is_power_cut := false

func cut_power():
	if is_power_cut:
		return
	is_power_cut = true
	emit_signal("power_cut")
