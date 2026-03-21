extends Area3D

const BRICK_SIZE : int = 2;
const TOWER_HEIGHT: int = 40
const PLAYER_HEIGHT: float = 2;

const BrickScene : PackedScene = preload("res://entities/blocks/bricks/bricks.tscn")
@export var collision_shape : CollisionShape3D

func insert_brick(brick: Node3D, x: int, y: int, z: int) -> void:
	add_child(brick)
	brick.position = Vector3(x * BRICK_SIZE, 
			y, z * BRICK_SIZE)

func _ready() -> void:
	assert(collision_shape != null)
	var shape: BoxShape3D = collision_shape.shape 
	var count_x : int = floor(shape.size.x / BRICK_SIZE)
	var count_y : int = floor(shape.size.y / BRICK_SIZE)
	var count_z : int = floor(shape.size.z / BRICK_SIZE)
	#var count_of_bricks_x : int = floor(shape.size.x / BRICK_SIZE)
	#var count_of_bricks_z : int = floor(shape.size.z / BRICK_SIZE)
	
	print(
		'size.x:', shape.size.x, '\n',
		'size.z:', shape.size.z, '\n',
		'position', position, '\n',
	)
	
	#var start_pos_x : int = floor(position.x - shape.size.x/2)
	#var start_pos_z : int = floor(position.z - shape.size.z/2)
	
	for i : int in count_x:
		for j : int in count_y:
			for k : int in count_z:
				var brick: Node3D = BrickScene.instantiate();
				
				var step : float = ceil(PLAYER_HEIGHT/2)
				if brick: 
					if  j%ceili(PLAYER_HEIGHT * 4) == 0: 
						if k < PLAYER_HEIGHT:
							insert_brick(brick, i, j, k)
									
						elif i >= (count_x - PLAYER_HEIGHT):
							if k < (count_z - PLAYER_HEIGHT):
								insert_brick(brick, i, j, k)
					
					elif j%ceili(PLAYER_HEIGHT * 2) == 0:
						if i < PLAYER_HEIGHT:
							if k >= PLAYER_HEIGHT:
								insert_brick(brick, i, j, k)
						
					elif j%ceili(PLAYER_HEIGHT * 2) == 0:
						if i < PLAYER_HEIGHT:
							if k >= PLAYER_HEIGHT:
								insert_brick(brick, i, j, k)
						else:
							if k >= (count_z - PLAYER_HEIGHT):
								insert_brick(brick, i, j, k)
					elif j <= step:
						if i < PLAYER_HEIGHT  and k < PLAYER_HEIGHT:
							insert_brick(brick, i, j, k)
				else:
					print("no bricks")
