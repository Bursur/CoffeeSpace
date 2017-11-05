
extends Node2D

var popup = preload("res://radial.scn");
var platform = null;
var childMenu = null;

var levelManager;

func _ready():
	levelManager = get_node("/root/levelManager");
	set_process_input(true);

func _input(event):
	var local = make_input_local(event);
	if(event.type == InputEvent.MOUSE_BUTTON && event.is_pressed() == true):
		var mousePos = local.pos;
		var nodePos = get_node("texture").get_pos();
		
		if(nodePos.distance_to(mousePos) < get_node("texture").get_texture().get_width() * 0.75):
			onPressed(event.pos);

func onMouseDown():
	onPressed(get_viewport().get_mouse_pos());

func onPressed(mousePos):
	if(platform == null && childMenu == null):
		var menu = popup.instance();
		menu.set_pos(mousePos);
		menu.parentNode = self;
		childMenu = menu;
		
		levelManager.placementShown = true;
		levelManager.currentLevel.get_node("placementLayer").add_child(menu);
	elif(childMenu == null):
		levelManager.availablePlatforms[platform.colour] += 1;
		platform.queue_free();
		platform = null;