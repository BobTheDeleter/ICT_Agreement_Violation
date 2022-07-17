class_name AttackState
extends "res://src/actors/_base_state.gd"

signal caught_player(dv)
func _init(csf, e).(csf, e):
	var _c = connect("caught_player", entity.player, "die")
	line = entity.get_node("Line2D")

var player_caught = false
func _on_enter():
	emit_signal("caught_player", (entity.position-entity.player.position)/entity.drag_time)
	entity.get_node("AnimationPlayer").play("attack")

var line
func update(_delta):
	line.points = [Vector2.ZERO, entity.to_local(entity.player.position)]
