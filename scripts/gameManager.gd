extends Node


@export var blueGoalieLine: LineEdit
@export var blueAttackLine: LineEdit
@export var redGoalieLine: LineEdit
@export var redAttackLine: LineEdit
@export var blueScoreLine: LineEdit
@export var redScoreLine: LineEdit
@export var messagePanelText: Label
@export var panel: Panel
@export var panelContents: Node

var currentPlayerText = ''


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


const API_URL = "https://babyfootscorebackend.onrender.com/scores"
const FIREBASE_URL = "https://babyfootscorekeeperbackend-default-rtdb.firebaseio.com/scores.json"


func submit_score(blue_goalie: String, blue_attack: String, red_goalie: String, red_attack: String, blue_score: int, red_score: int) -> void:
	var http = HTTPRequest.new()
	add_child(http)
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({"blue_goalie": blue_goalie, "blue_attack": blue_attack, "red_goalie": red_goalie, "red_attack": red_attack, "blue_score": blue_score, "red_score": red_score})
	http.request_completed.connect(Callable(self, "_on_submit_completed"))
	http.request(FIREBASE_URL, headers, HTTPClient.METHOD_POST, body)


func _on_submit_completed(result, response_code, headers, body):
	print("Submit response:", body.get_string_from_utf8())
	blueGoalieLine.text = ""
	blueAttackLine.text = ""
	redGoalieLine.text = ""
	redAttackLine.text = ""
	blueScoreLine.text = ""
	redScoreLine.text = ""
	if response_code == 200:
		messagePanelText.text = "Score submitted successfully"
	else:
		messagePanelText.text = str("Error submitting score: ", response_code)
		
	panelContents.visible = true


func fetch_scores() -> void:
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(Callable(self, "_on_scores_received"))
	http.request(FIREBASE_URL)


func _on_scores_received(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json.error == OK:
		var scores = json.result
		print(scores)


func _on_touch_screen_button_released() -> void:
	print("Touched")
	var blue_goalie = blueGoalieLine.text
	var blue_attack = blueAttackLine.text
	var red_goalie = redGoalieLine.text
	var red_attack = redAttackLine.text
	var blue_score = int(blueScoreLine.text)
	var red_score = int(redScoreLine.text)
	submit_score(blue_goalie, blue_attack, red_goalie, red_attack, blue_score, red_score)
	panel.visible = true
	panelContents.visible = false


func _on_panel_button() -> void:
	$Panel.visible = false
