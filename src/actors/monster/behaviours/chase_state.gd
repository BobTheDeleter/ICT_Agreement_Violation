class_name ChaseState
extends "./_base_state.gd"

func _init(e, rs, ar).(e, rs, "run"):
    attack_radius = ar

func on_enter():
    player_last = entity.player_last_known

func on_exit():
    entity.player_last_known = entity.player.position

var attack_radius
var player_last
func update(_delta):    
    if entity.can_see_player():
        if  entity.position.distance_to(entity.player.position) < attack_radius:
            entity.change_state("attack")
        # entity.current_path = entity.pathfind(entity.position, entity.player.position)
    else:
        entity.change_state("investigate")

func pathfind():
    entity.current_path = entity.pathfind(entity.position, entity.player.position)