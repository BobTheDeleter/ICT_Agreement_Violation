class_name SearchState    
extends "res://src/actors/_base_state.gd"

func _init(csf, e, sp, sr, ss, pd).(csf, e):
	search_point_num = sp
	serach_radius = sr
	search_speed = ss
	point_distance = pd
	nav2d = entity.get_parent().get_node("Navigation2D")

var player_last
var serach_radius
var points_searched = 0
func on_enter():
	player_last = entity.player_last_known
	while search_points.size() < search_point_num:
		var point = get_random_circle_point(serach_radius, player_last)
		if !entity.raycast(entity.position, point):
			search_points.append(point)
		
var nav2d
var current_p
var current_path = PoolVector2Array()
func update(_delta):
	if entity.can_see_player():
		change_state_func.call_func("chase")
	
	if current_path.size() < 1:
		if points_searched > search_point_num:
			change_state_func.call_func("wander")
		get_path()
		points_searched += 1

var search_point_num
var search_points = PoolVector2Array()
var search_speed
var point_distance
func physics_update(delta):
	if current_path.size() > 0:
		entity.position += entity.position.direction_to(current_path[0])*search_speed*delta
		entity.move_and_slide(Vector2.ZERO)
		  
		if entity.position.distance_to(current_path[0]) < point_distance:
			current_path.remove(0)

func get_random_circle_point(r, p):
	var R = r*sqrt(randf())
	var theta = 2*PI*randf()
	var offest = Vector2(
		R*cos(theta),
		R*sin(theta)
	)
	return p+offest

func get_path():
	current_p = search_points[ randi()%(search_points.size()) ]
	current_path = nav2d.get_simple_path(entity.position, current_p, false)
#randomly go to soem points in a radius around it, if it can see the points
#if it sees player, enter chase
#else go back to wander
