extends Node

onready var api_file = load("silent_wolf_api_key.gd")
var api_key := ""
var is_online := false
var username = "username"
var chars = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789"
var username_length = 16


var x = []
var y = []
var dir = []
var data = {}
var top_score = 1

func _ready():
	is_online = api_file is Script
	if !is_online: return
	
	make_username()
	print("Leaderboard username: ", username)
	
	api_key = api_file.source_code.strip_edges().replace('"', "")
	SilentWolf.configure({
		"api_key": api_key,
		"game_id": "rota",
		"game_version": "1.0.0",
		"log_level": 1})
	
	
	yield(get_tree(), "idle_frame")
	SilentWolf.Scores.persist_score(username, 1, "main")
	for i in ["scene_before", "scene_changed"]:
		Shared.connect(i, self, i)

func make_username():
	username = ""
	for i in username_length:
		username += chars[randi() % (chars.length())]


func scene_before():
	var f = Shared.map_name
	if f != "" and Shared.is_multiplayer:
		var style = "-"
		for i in data["style"]:
			style += str(i)
		#print("PRINTYYY: ", style)
		SilentWolf.Scores.persist_score(username + style, top_score + 1, f, data)
		#SilentWolf.Scores.wipe_leaderboard(f)
		data = {}


func scene_changed():
	var f = Shared.map_name
	if f != "" and Shared.is_multiplayer:
		yield(SilentWolf.Scores.get_high_scores(1000, f), "sw_scores_received")
		
		var s = SilentWolf.Scores.scores
		var z = min(Shared.replayers.size(), s.size())
		for i in z:
			var m = s[i].metadata
			var t = int(s[i].score)
			if t > top_score:
				top_score = t
			
			
			#print("Scores: ", m , " score : ", s[i].score)
			Shared.replayers[i].metadata = m
