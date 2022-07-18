class_name AttackState
extends "res://src/actors/_base_state.gd"

signal caught_player(dv)

func _init(csf, e).(csf, e):
    var _c = connect("caught_player", entity.player, "die")
    line = entity.get_node("Line2D")

var line
func on_enter():
    emit_signal("caught_player", (entity.position-entity.player.position)/entity.drag_time)
    entity.get_node("AnimationPlayer").play("attack")

func update(_delta):
    line.points = [0, entity.to_local(entity.player.position)]