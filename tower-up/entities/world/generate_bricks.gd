extends Area3D

const BRICK_SIZE : int = 2;
const TOWER_HEIGHT: int = 40
const PLAYER_HEIGHT: int = 2;

const BrickScene : PackedScene = preload("res://entities/blocks/bricks/bricks.tscn")
@export var collision_shape : CollisionShape3D

func _ready() -> void:
	assert(collision_shape != null)
	var shape: BoxShape3D = collision_shape.shape 
	var count_of_bricks_x : int = floor(shape.size.x / BRICK_SIZE)
	var count_of_bricks_z : int = floor(shape.size.z / BRICK_SIZE)
	
	print(
		'size.x =', shape.size.x, '\n',
		'size.z =', shape.size.z, '\n',
		'position', position, '\n',
	)
	
	var start_pos_x : int = floor(position.x - shape.size.x/2)
	var start_pos_z : int = floor(position.z - shape.size.z/2)
	
	for i : int in count_of_bricks_x:
		
		for j : int in count_of_bricks_z:
			var brick: Node3D = BrickScene.instantiate();
			
			if brick: 
				add_child(brick)
				brick.position = Vector3(start_pos_x + i * BRICK_SIZE, 
						PLAYER_HEIGHT, start_pos_z + j * BRICK_SIZE)
			else:
				print("no bricks")
