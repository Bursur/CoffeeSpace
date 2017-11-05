
extends Node2D

var parentNode = null;
var platformScene = preload("res://platform.scn");
var objectManager;
var levelManager;

var selectedColour = "";

func _ready():
	objectManager = get_node("/root/objectManager");
	levelManager = get_node("/root/levelManager");
	setSize();
	
	get_node("blue").set_hidden(true);
	get_node("green").set_hidden(true);
	get_node("red").set_hidden(true);
	
	get_node("buttons/blueNumbers").setText(str(levelManager.availablePlatforms[objectManager.NAME_LUT.find("blue")]));
	if(levelManager.availablePlatforms[objectManager.NAME_LUT.find("blue")] > 0):
		get_node("buttons/blueButton").connect("pressed", self, "onBlueSelected");
	
	get_node("buttons/greenNumbers").setText(str(levelManager.availablePlatforms[objectManager.NAME_LUT.find("green")]));
	if(levelManager.availablePlatforms[objectManager.NAME_LUT.find("green")] > 0):
		get_node("buttons/greenButton").connect("pressed", self, "onGreenSelected");
	
	get_node("buttons/redNumbers").setText(str(levelManager.availablePlatforms[objectManager.NAME_LUT.find("red")]));
	if(levelManager.availablePlatforms[objectManager.NAME_LUT.find("red")] > 0):
		get_node("buttons/redButton").connect("pressed", self, "onRedSelected");

func setSize():
	var screen = get_node("/root");
	var size = screen.get_rect().size;
	var maxHeight = size.y * 0.35;
	var menuHeight = get_node("buttons/background").get_texture().get_height();
	
	var newScale = maxHeight / menuHeight;
	if(newScale > 1.0):
		set_scale(Vector2(newScale, newScale));

func onBlueSelected():
	get_node("buttons").set_hidden(true);
	get_node("blue").set_hidden(false);
	setListeners("blue");

func onGreenSelected():
	get_node("buttons").set_hidden(true);
	get_node("green").set_hidden(false);
	setListeners("green");

func onRedSelected():
	get_node("buttons").set_hidden(true);
	get_node("red").set_hidden(false);
	setListeners("red");

func setListeners(colour):
	selectedColour = colour;
	
	var node = get_node(colour + "/vertical");
	node.connect("pressed", self, "onVertical");
	
	node = get_node(colour + "/horizontal");
	node.connect("pressed", self, "onHorizontal");
	
	node = get_node(colour + "/left");
	node.connect("pressed", self, "onLeft");
	
	node = get_node(colour + "/right");
	node.connect("pressed", self, "onRight");

func onVertical():
	placePlatform(objectManager.ANGLES[objectManager.VERTICAL]);

func onHorizontal():
	placePlatform(objectManager.ANGLES[objectManager.HORIZONTAL]);

func onLeft():
	placePlatform(objectManager.ANGLES[objectManager.LEFT]);

func onRight():
	placePlatform(objectManager.ANGLES[objectManager.RIGHT]);

func placePlatform(rot):
	self.queue_free();
	
	var platform = platformScene.instance();
	platform.colour = objectManager.NAME_LUT.find(selectedColour);
	platform.set_rotd(rot);
	platform.set_pos(parentNode.get_pos());
	
	parentNode.platform = platform;
	parentNode.childMenu = null;
	
	levelManager.currentLevel.add_child(platform);
	
	levelManager.availablePlatforms[objectManager.NAME_LUT.find(selectedColour)] -= 1;