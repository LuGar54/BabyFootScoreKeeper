extends Node


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
	#var body = '{
		#"blue_goalie": %s,
		#"blue_attack": %s,
		#"red_goalie": %s,
		#"red_attack": %s,
		#"blue_score": %s,
		#"red_score": %s
	#}' % [blue_goalie, blue_attack, red_goalie, red_attack, blue_score, red_score]
	var body = JSON.stringify({"blue_goalie": blue_goalie, "blue_attack": blue_attack, "red_goalie": red_goalie, "red_attack": red_attack, "blue_score": blue_score, "red_score": red_score})
	http.request(FIREBASE_URL, headers, HTTPClient.METHOD_POST, body)
	http.request_completed.connect(Callable(self, "_on_submit_completed"))
	#http.connect("request_completed", self, "_on_submit_completed")

func _on_submit_completed(result, response_code, headers, body):
	print("Submit response:", body.get_string_from_utf8())
	$VBoxContainer/HBoxContainer/BlueGoalie.text = ""
	$VBoxContainer/HBoxContainer/BlueAttack.text = ""
	$VBoxContainer/HBoxContainer3/RedGoalie.text = ""
	$VBoxContainer/HBoxContainer3/RedAttack.text = ""
	$VBoxContainer/HBoxContainer2/BlueScore.text = ""
	$VBoxContainer/HBoxContainer2/RedScore.text = ""
	$Panel/PanelContents/Message.text = body.get_string_from_utf8()
	if response_code == 200:
		$Panel/PanelContents/Message.text = "Score submitted successfully"
	else:
		$Panel/PanelContents/Message.text = str("Error submitting score: ", response_code)
		
	$Panel/PanelContents.visible = true

func fetch_scores() -> void:
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(Callable(self, "_on_scores_received"))
	http.request(FIREBASE_URL)
	#http.connect("request_completed", self, "_on_scores_received")

func _on_scores_received(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json.error == OK:
		var scores = json.result
		print(scores)


func _on_touch_screen_button_released() -> void:
	print("Touched")
	var blue_goalie = $VBoxContainer/HBoxContainer/BlueGoalie.text
	var blue_attack = $VBoxContainer/HBoxContainer/BlueAttack.text
	var red_goalie = $VBoxContainer/HBoxContainer3/RedGoalie.text
	var red_attack = $VBoxContainer/HBoxContainer3/RedAttack.text
	var blue_score = int($VBoxContainer/HBoxContainer2/BlueScore.text)
	var red_score = int($VBoxContainer/HBoxContainer2/RedScore.text)
	submit_score(blue_goalie, blue_attack, red_goalie, red_attack, blue_score, red_score)
	$Panel.visible = true
	$Panel/PanelContents.visible = false
	


func _on_panel_button() -> void:
	$Panel.visible = false
