
extends Node2D

var progress = {};

const fileName = "user://playerData.cfg";

func _ready():
	loadProfile();

func loadProfile():
	var file = ConfigFile.new();
	var result = file.load(fileName);
	
	print("Error Code: " + str(result));
	if(result == OK):
		var sections = file.get_sections();
		for i in range(sections.size()):
			progress[sections[i]] = file.get_value(sections[i], "complete", false);

func saveProfile():
	var file = ConfigFile.new();
	
	var keys = progress.keys();
	for i in range(keys.size()):
		file.set_value(keys[i], "complete", progress[keys[i]]);
	
	file.save(fileName);

func levelComplete(name):
	progress[name] = true;
	saveProfile();

func isLevelComplete(name):
	if(progress.has(name) == false):
		return false;
	
	return progress[name];