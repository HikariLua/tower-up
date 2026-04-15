extends CanvasLayer

@export var player: CharacterBody3D
@export var score_label: Label 

var score: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = 0;
	assert(player)
	assert(score_label)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.velocity.y > 0: 
		update_score(5);
	if player.velocity.y < 0: 
		update_score(-5);
	score_label.text = "Score: %d" % score
	pass

func update_score(value: int) -> void:
	score += value;
	score = max(score,0)
