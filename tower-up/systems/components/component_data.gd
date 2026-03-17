@abstract
class_name Component
extends Node

@export var template_as_data: bool = false


func initialize_data(data_template: Resource) -> Resource:
	assert(data_template != null)

	if template_as_data:
		return data_template
	
	return data_template.duplicate(true)
	
