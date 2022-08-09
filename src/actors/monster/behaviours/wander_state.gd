class_name WanderState
extends "./_base_state.gd"

func _init(e, s).(e, s, "walk"):
    pass

func update(_delta):
    if entity.can_see_player():
        entity.player_last_known = entity.player.position
        entity.change_state("investigate")

func pathfind():
    entity.level.dec_alert(entity.position)
    entity.current_path = entity.pathfind(entity.position, entity.level.grid_to_world((entity.level.get_weighted_grid())))
    entity.emotion = max(entity.emotion-1, 0)
