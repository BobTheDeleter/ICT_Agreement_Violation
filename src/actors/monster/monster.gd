extends KinematicBody2D

export var speed = 100

export var run_speed = 350

export var emotion_recognition_times = PoolIntArray()
export var distance_recognition_multipliers = PoolRealArray()
export var distance_recognition_ranges = PoolIntArray()

onready var waypoints = get_parent().get_node("waypoints").get_children()
onready var player = get_parent().player()

#debug
onready var wpdebug = get_parent().get_node("waypoint_debug")
onready var vdebug = get_parent().get_node("vision_debug")
onready var point_radius = $CollisionShape2D.shape.radius + 10

var STATES
var _state

func _ready():
	var csf = funcref(self, "change_state")
	var ss = get_world_2d().direct_space_state
	STATES = {
		"wander": WanderState.new(csf, self, point_radius, waypoints, speed, player, ss),
		"investigate": InvestigateState.new(csf, self, run_speed, ss, player, emotion_recognition_times, distance_recognition_multipliers, distance_recognition_ranges, point_radius),
	}
	_state = STATES["wander"]
	_state._on_enter()

var emotion = 0
var player_last_known = Vector2()

func _process(delta):
	_state.update(delta)

func _physics_process(delta):
	_state.physics_update(delta)

func change_state(state):
	_state._on_exit()
	_state = STATES[state]
	_state._on_enter()
