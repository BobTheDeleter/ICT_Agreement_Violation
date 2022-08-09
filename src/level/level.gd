extends Node

export var tileX = 0
export var tileY = 0
export var tiles_per_grid = 0

onready var real_tile_size =  $Navigation2D/TileMap.cell_size.x*$Navigation2D/TileMap.scale.x 
onready var gridX  = tileX/tiles_per_grid
onready var gridY = tileY/tiles_per_grid

var alert_levels = PoolIntArray()
func _ready():
    for x in gridX:
        for y in gridY:
            alert_levels.append(0)

func get_random_grid():
    return Vector2( randi()%gridX, randi()%gridY )

var menace = 9
func get_weighted_grid():
    #use menace value to calculate distance from player
    var range_ = gridX if gridX>gridY else gridY
    var distance = range_/9 * menace
    #get random direction
    var theta = randf()*2*PI
    #get raw pos
    var pos= Vector2(
        distance * cos(theta),
        distance * sin(theta)
    )
    #cap to world size
    pos.x = min(gridX, max(0, pos.x))
    pos.y = min(gridX, max(0, pos.y))
    return pos

func player():
    return $player

func nav2D():
    return $Navigation2D

func world_to_grid(world: Vector2):
    var tr = world/tiles_per_grid/real_tile_size
    return Vector2(int(tr.x), int(tr.y))
func grid_to_world(grid: Vector2):
    return grid*tiles_per_grid*real_tile_size
    
func get_alert(pos: Vector2):
    pos = world_to_grid(pos)
    return alert_levels[pos.x*gridY + pos.y]
func set_alert(pos: Vector2, level: int):
    pos = world_to_grid(pos)
    alert_levels[pos.x*gridY + pos.y] = level
func inc_alert(pos: Vector2):
    pos = world_to_grid(pos)
    alert_levels[pos.x*gridY + pos.y] = min(alert_levels[pos.x*gridY + pos.y]+1, 3)
func dec_alert(pos: Vector2):
    pos = world_to_grid(pos)
    alert_levels[pos.x*gridY + pos.y] = max(alert_levels[pos.x*gridY + pos.y]-1, 0)

func goals():
    return $goals.get_children()

func monster():
    return $monster
