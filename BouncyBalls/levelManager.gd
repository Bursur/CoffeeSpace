
extends Node2D

const fileName = "res://levels/";
const reqsFile = "res://level.cfg";

var targetOutput = [10, 0, 0];
var currentOutput = [0, 0, 0];
var availablePlatforms = [0, 0, 0];
var time = 0;
var deathPoint = 0;
var minBounds = Vector2(0, 0);
var maxBounds = Vector2(0, 0);
var currentLevel = null;
var levelNum = 6;
var music = null;
var initialGravity = null;
var initialAngularDamping = null;
var initialLinearDamping = null;
var currentLevelName = "";

var placementShown = false;
var profile = null;

# Requirements info
const worlds = ["earth", "space"];
var requirements = {};

func _ready():
	profile = get_node("/root/saveData");
	loadLevelRequirements();
	pass

func loadLevel(name):
	print("Loading Level: " + name);
	
	var levelName = fileName + name + ".scn";
	print("Filename " + levelName);
	var fileCheck = File.new();
	if(fileCheck.file_exists(levelName) == true):
		if(currentLevel != null):
			currentLevel.queue_free();
		
		var scene = ResourceLoader.load(fileName + name + ".scn");
		var level = scene.instance();
		
		get_tree().get_root().add_child(level);
		
		currentLevelName = name;
		
		return true;
	else:
		return false;
		#levelNum = 0;
		#goToMainMenu();

func goToMainMenu():
	var scene = ResourceLoader.load("res://map.scn");
	get_tree().get_root().add_child(scene.instance());
	
	if(currentLevel != null):
		currentLevel.queue_free();
	currentLevel = null;

func isLevelComplete():
	if(currentOutput[0] < targetOutput[0]):
		return false;
	
	if(currentOutput[1] < targetOutput[1]):
		return false;
	
	if(currentOutput[2] < targetOutput[2]):
		return false;
	
	profile.levelComplete(currentLevelName);
	return true;

func playMusic(stream):
	if(music != null):
		return;
	
	music = stream;
	add_child(music);

func loadLevelRequirements():
	print("figure this from an external file on mobile stuffs");
	
	#Earth
	requirements["earth1"] = [];
	requirements["earth2"] = ["earth1"];
	requirements["earth3"] = ["earth2"];
	requirements["earth4"] = ["space2"];
	requirements["earth5"] = ["earth4"];
	requirements["earth6"] = ["earth5"];
	requirements["earth7"] = ["earth6"];
	
	#Space
	requirements["space1"] = ["earth3"];
	requirements["space2"] = ["space1"];
	requirements["space3"] = ["space2"];
	requirements["space7"] = ["space3"];

func isLevelUnlocked(name):
	if(requirements.has(name) == false):
		return false;
	
	return true;
	
	for i in range(requirements[name].size()):
		if(profile.isLevelComplete(requirements[name][i]) == false):
			return false;
	
	return true;

func isLevelNew(name):
	if(profile.isLevelComplete(name) == true):
		return false;
	
	return true;