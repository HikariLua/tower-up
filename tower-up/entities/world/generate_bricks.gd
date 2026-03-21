extends Area3D

const BRICK_SIZE : int = 2;
const TOWER_HEIGHT: int = 40
const PLAYER_HEIGHT: float = 2;

const BrickScene : PackedScene = preload("res://entities/blocks/bricks/bricks.tscn")
@export var collision_shape : CollisionShape3D

func insert_brick(brick: Node3D, x: float, y: float, z: float) -> void:
	add_child(brick)
	brick.position = Vector3(x * BRICK_SIZE, 
			y, z * BRICK_SIZE)

func _ready() -> void:
	assert(collision_shape != null)
	var shape: BoxShape3D = collision_shape.shape 
	var count: Vector3 = Vector3(
			floorf(shape.size.x / BRICK_SIZE),
			floorf(shape.size.y / BRICK_SIZE),
			floorf(shape.size.z / BRICK_SIZE))
			
	
	#var start_pos_x : int = floor(position.x - shape.size.x/2)
	#var start_pos_z : int = floor(position.z - shape.size.z/2)
		
	var current: Vector3 = Vector3(0,0,0);
	
	# Direita, Cima, Esquerda, Baixo
	const DIRECTIONS : Array[Vector2i] = [
			Vector2i(1,0), 
			Vector2i(0,1), 
			Vector2i(-1, 0), 
			Vector2i(0, -1)]
	
	var dir_index : int = 0
	
	var min_x : float = 0
	var max_x : float = ceil(count.x - 1)
	var min_z : float = 0
	var max_z : float = ceil(count.z - 1)
	
	var total_steps: float = shape.size.y * shape.size.x
	for step: int in range(total_steps):
		var brick: Node3D = BrickScene.instantiate()
		insert_brick(brick, current.x, current.y, current.z)
		
		current.y += 1
		
		var next_x: float = current.x + DIRECTIONS[dir_index].x
		var next_z: float = current.z + DIRECTIONS[dir_index].y
		
		if next_x > max_x or next_x < min_x or next_z > max_z or next_z < min_z:
			dir_index = (dir_index + 1) % 4
			
			#next_dir = directions[dir_index]
			current.x += DIRECTIONS[dir_index].x
			current.z += DIRECTIONS[dir_index].y
		else:
			current.x = next_x
			current.z = next_z
		
		
		
		
