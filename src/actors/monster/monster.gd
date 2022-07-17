extends KinematicBody2D

export var speed = 100

export var run_speed = 350

export var emotion_recognition_times = PoolIntArray()
export var distance_recognition_multipliers = PoolRealArray()
export var distance_recognition_ranges = PoolIntArray()

export var attack_range = 0
export var drag_time = 0

onready var waypoints = get_parent().get_node("waypoints").get_children()
onready var player = get_parent().player()
onready var wp_radius = $CollisionShape2D.shape.radius + 5
onready var attack_radius = $CollisionShape2D.shape.radius + 5 + player.get_node("CollisionShape2D").shape.radius + attack_range

#debug
onready var wpdebug = get_parent().get_node("waypoint_debug")
onready var vdebug = get_parent().get_node("vision_debug")

var STATES
var _state

func _ready():
	var csf = funcref(self, "change_state")
	var ss = get_world_2d().direct_space_state
	STATES = {
		"wander": WanderState.new(csf, self, wp_radius, waypoints, speed, player, ss),
		"investigate": InvestigateState.new(csf, self, run_speed, ss, player, emotion_recognition_times, distance_recognition_multipliers, distance_recognition_ranges, wp_radius, attack_radius),
		"attack": AttackState.new(csf, self),
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
