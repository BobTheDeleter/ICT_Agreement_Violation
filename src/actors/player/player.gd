extends KinematicBody2D

export var walk_speed = 1
export var sprint_time = 3

export var sprint_multiplier = 1.5 
export var sprint_accel_time = 2

var STATES
var _state
func _ready():
    var csf = funcref(self, "change_state")
    STATES = {
        "walk": WalkState.new(csf, self, sprint_time, walk_speed),
        "sprint": SprintState.new(csf, self, sprint_accel_time, walk_speed, sprint_multiplier),
    }
    _state = STATES["walk"]
    _state._on_enter()

func _process(delta):
    _state.update(delta)

func _physics_process(delta):
    _state.physics_update(delta)

func change_state(state):
    _state._on_exit()
    _state = STATES[state]
    _state._on_enter()
