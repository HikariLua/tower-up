extends Area3D

const BRICK_SIZE : int = 2;
const TOWER_HEIGHT: int = 40
const PLAYER_HEIGHT: int = 2;

const BrickScene : PackedScene = preload("res://entities/blocks/bricks/bricks.tscn")
@export var collision_shape : CollisionShape3D

func insert_brick(brick: Node3D, i: int , k: int) -> void:
	add_child(brick)
	brick.position = Vector3(i * BRICK_SIZE, 
			PLAYER_HEIGHT, k * BRICK_SIZE)

func _ready() -> void:
	assert(collision_shape != null)
	var shape: BoxShape3D = collision_shape.shape 
	var count_x : int = floor(shape.size.x / BRICK_SIZE)
	var count_z : int = floor(shape.size.z / BRICK_SIZE)
	var count_of_blocks: Vector2 = Vector2(count_x, count_z)
	#var count_of_bricks_x : int = floor(shape.size.x / BRICK_SIZE)
	#var count_of_bricks_z : int = floor(shape.size.z / BRICK_SIZE)
	
	print(
		'size.x:', shape.size.x, '\n',
		'size.z:', shape.size.z, '\n',
		'position', position, '\n',
	)
	

	#var start_pos_x : int = floor(position.x - shape.size.x/2)
	#var start_pos_z : int = floor(position.z - shape.size.z/2)
	
	for i : int in count_of_blocks.x:
		
		for k : int in count_of_blocks.y:
			var brick: Node3D = BrickScene.instantiate();
			
			if brick: 
				var minimal : int = 2;
				
				if i < minimal:
					if k >= minimal:
						insert_brick(brick, i, k)

				elif k < minimal:
					insert_brick(brick, i, k)
							
				elif i >= (count_x - minimal):
					if k < (count_z - minimal):
						insert_brick(brick, i, k)
								
				elif k >= (count_z - minimal):
						add_child(brick)
						brick.position = Vector3(i * BRICK_SIZE, 
								PLAYER_HEIGHT, k * BRICK_SIZE)

					
			else:
				print("no bricks")
