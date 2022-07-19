extends KinematicBody2D

export var speed = 100

export var search_speed = 350

export var sight_range = 0

export var emotion_recognition_times = PoolIntArray()
export var distance_recognition_multipliers = PoolRealArray()
export var distance_recognition_ranges = PoolIntArray()

export var attack_range = 0
export var drag_time = 0
export var run_speed = 0

export var search_points = 0
export var search_radius = 0

onready var waypoints = get_parent().get_node("waypoints").get_children()
onready var player = get_parent().player()
onready var wp_radius = $CollisionShape2D.shape.radius + 10

#debug
onready var wpdebug = get_parent().get_node("waypoint_debug")
onready var vdebug = get_parent().get_node("vision_debug")

onready var space_state = get_world_2d().direct_space_state
onready var nav2D = get_parent().get_node("Navigation2D")

var STATES
var _state

func _ready():
	STATES = {
		"wander": WanderState.new(self, speed, waypoints),
		"investigate": InvestigateState.new(self, search_speed, emotion_recognition_times, distance_recognition_multipliers, distance_recognition_ranges, attack_range),
		"chase": ChaseState.new(self, run_speed, attack_range),
		"search": SearchState.new(self, search_points, search_radius, search_speed),
		"attack": AttackState.new(self),
	}
	_state = STATES["wander"]
	_state.on_enter()

var emotion = 0
var player_last_known = Vector2()

func _process(delta):
	_state.update(delta)

var current_path = PoolVector2Array()
func _physics_process(delta):
	if current_path.size() > 0:
		position += position.direction_to(current_path[0])*_state.speed*delta
		move_and_slide(Vector2.ZERO)
		  
		if position.distance_to(current_path[0]) < wp_radius:
			current_path.remove(0)
	else:
		_state.pathfind()

func change_state(state):
	_state.on_exit()
	_state = STATES[state]
	_state.on_enter()

func can_see_player():
	var result = space_state.intersect_ray(position, player.position, [self])
	if result:
		if result.collider == player && position.distance_to(result.position) < sight_range:
			return true
		vdebug.points = [result.position, position]
		
	return false

func raycast(p1, p2):
	return space_state.intersect_ray(p1, p2)

func pathfind(p1, p2):
	wpdebug.points = nav2D.get_simple_path(p1, p2, false)
	return nav2D.get_simple_path(p1, p2, false)

#TODO add handler for tenseness(?) level, possibly external, probably internal
