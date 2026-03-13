extends Node

signal power_cut

func cut_power():
	emit_signal("power_cut")
