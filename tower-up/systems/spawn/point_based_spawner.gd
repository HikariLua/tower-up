@tool
class_name PathPointBasedSpawner
extends Path3D


@export var node_scene: PackedScene


func _ready() -> void:
	var parent: Node3D = get_parent() as Node3D

	for point_index: int in range(curve.point_count):
		var node_instance: Node3D = node_scene.instantiate()

		var point_position: Vector3 = curve.get_point_position(point_index) 
		var new_position: Vector3 = self.global_position + point_position
		_spawn_node.call_deferred(parent, node_instance, new_position)

	
func _spawn_node(parent: Node3D, instance: Node3D, new_position: Vector3) -> void:
	parent.add_child(instance)
	instance.global_position = new_position
