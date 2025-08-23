extends LineEdit


@export var gameManager: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_focus_entered() -> void:
	if gameManager.currentPlayerText != '':
		text = gameManager.currentPlayerText
		gameManager.currentPlayerText = ''
