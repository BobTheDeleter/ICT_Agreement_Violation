class_name AttackState
extends "./_base_state.gd"

func _init(e, s).(e, s, "attack"):
    line = entity.get_node("Line2D")

var line

func update(_delta):
    line.points = [0, entity.to_local(entity.player.position)]

func pathfind():
    return [entity.position]
