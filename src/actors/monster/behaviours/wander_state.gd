class_name WanderState
extends "./_base_state.gd"

func _init(e, s, wa).(e):
	waypoint_array = wa
	speed = s

var waypoint_array
var current_wp
func update(_delta):
	if entity.can_see_player():
		entity.player_last_known = entity.player.position
		entity.change_state("investigate")

func pathfind():
	entity.current_path = entity.pathfind(entity.position, waypoint_array[ randi()%(waypoint_array.size()) ].position)
	entity.emotion = max(entity.emotion-1, 0)
