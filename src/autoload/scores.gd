extends Node

onready var api_file = load("silent_wolf_api_key.gd")
var api_key := ""
var is_online := false
var scores := {}
var username = "test"

signal new_score

func _ready():
	is_online = api_file is Script
	if !is_online: return
	
	print("Leaderboard Shared.username: ", username)
	
	api_key = api_file.source_code.strip_edges().replace('"', "")
	SilentWolf.configure({
		"api_key": api_key,
		"game_id": "rota",
		"game_version": "1.0.0",
		"log_level": 1})
	
	
	yield(get_tree(), "idle_frame")
	SilentWolf.Scores.persist_score(username, 1, "farticle")
