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
onready var attack_radius = $CollisionShape2D.shape.radius + 10 + player.get_node("CollisionShape2D").shape.radius + attack_range

#debug
onready var wpdebug = get_parent().get_node("waypoint_debug")
onready var vdebug = get_parent().get_node("vision_debug")

onready var space_state = get_world_2d().direct_space_state

var STATES
var _state

func _ready():
	var csf = funcref(self, "change_state")
	var ss = get_world_2d().direct_space_state
	STATES = {
		"wander": WanderState.new(csf, self, wp_radius, waypoints, speed, player, ss),
		"investigate": InvestigateState.new(csf, self, search_speed, emotion_recognition_times, distance_recognition_multipliers, distance_recognition_ranges, wp_radius, attack_radius),
		"chase": ChaseState.new(csf, self, run_speed, attack_radius),
		"search": SearchState.new(csf, self, search_points, search_radius, search_speed, wp_radius),
		"attack": AttackState.new(csf, self),
	}
	_state = STATES["wander"]
	_state.on_enter()

var emotion = 0
var player_last_known = Vector2()

func _process(delta):
	_state.update(delta)

func _physics_process(delta):
	_state.physics_update(delta)

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
