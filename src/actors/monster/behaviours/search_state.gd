class_name SearchState    
extends "./_base_state.gd"

func _init(e, spn, sr, ss).(e):
    search_point_num = spn
    search_radius = sr
    speed = ss

var player_last
var search_radius
var points_searched = 0
func on_enter():
    player_last = entity.player_last_known
    while search_points.size() < search_point_num:
        var point = get_random_circle_point(search_radius, player_last)
        if !entity.raycast(entity.position, point):
            search_points.append(point)
        
func update(_delta):
    if entity.can_see_player():
        entity.change_state("chase")

var search_point_num
var search_points = PoolVector2Array()
func pathfind():
    if points_searched > search_point_num/2:
        entity.change_state("wander")
    points_searched += 1
    entity.current_path = entity.pathfind(entity.position, search_points[ randi()%(search_points.size()) ])

func get_random_circle_point(r, p):
    var R = r*sqrt(randf())
    var theta = 2*PI*randf()
    var offest = Vector2(
        R*cos(theta),
        R*sin(theta)
    )
    return p+offest
#randomly go to soem points in a radius around it, if it can see the points
#if it sees player, enter chase
#else go back to wander
