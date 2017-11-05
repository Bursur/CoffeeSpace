
extends Node2D

var  mapScene = preload("res://map.scn");

func _ready():
	var newGame = get_node("menu/container/newGame");
	newGame.connect("pressed", self, "onNewGame");
	
	var quit = get_node("menu/container/quit");
	quit.connect("pressed", self, "onQuit");
	
	var root = get_node("/root");
	onResize();
	root.connect("size_changed", self, "onResize");
	
	get_tree().set_auto_accept_quit(true);
	
	if(get_node("/root/levelManager").music == null):
		var music = get_node("music");
		music.set_stream(load("res://music1.ogg"));
		music.play();

func onResize():
	var root = get_node("/root");
	var screenSize = root.get_rect();
	var sizer = get_node("menu/sizer");
	var scale = screenSize.size.height / sizer.get_size().height;
	
	if(sizer.get_size().width * scale > screenSize.size.width):
		scale = screenSize.size.width / sizer.get_size().width;
	
	get_node("menu/container").set_scale(Vector2(scale, scale));
	var pos = Vector2(screenSize.size.width * 0.5, screenSize.size.height * 0.5);
	get_node("menu").set_pos(pos);

func onNewGame():
	var node = mapScene.instance();
	get_tree().get_root().add_child(node);
	
	var music = get_node("music");
	remove_child(music);
	levelManager.playMusic(music);
	
	self.queue_free();
	
	levelManager.currentLevel = null;
	
	if(OS.get_name() == "Android"):
		get_tree().set_auto_accept_quit(false);

func onQuit():
	get_tree().quit();