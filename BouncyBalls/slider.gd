
extends Node2D

var mouseDown = false;
var tween;
var levelManager;

func _ready():
	set_opacity(0.5);
	tween = get_node("alphaTween");
	
	set_process_input(true);
	setRatio(0.5);
	
	levelManager = get_node("/root/levelManager");

func onHandleGrabbed():
	tween.interpolate_property(self, "visibility/opacity", 0.5, 1.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
	tween.start();
	mouseDown = true;

func onHandleReleased():
	tween.interpolate_property(self, "visibility/opacity", 1.0, 0.5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
	tween.start();
	mouseDown = false;

func getRatio():
	var maxValue = get_node("track").get_texture().get_height() * 3;
	var value = get_node("handle").get_pos().y;
	
	var ratio = value / maxValue;
	return ratio;

func setRatio(ratio):
	var maxValue = get_node("track").get_texture().get_height() * 3;
	var value = maxValue * ratio;
	
	var pos = Vector2(0, value);
	get_node("handle").set_pos(pos);

func _input(event):
	var handle = get_node("handle");
	
	if(event.type == InputEvent.MOUSE_BUTTON):
		if(event.is_pressed() == true):
			var rect = handle.get_item_rect();
			rect.pos.y += handle.get_pos().y * get_scale().y;
			var target = event.pos;
			target.x -= get_pos().x;
			target.y -= get_pos().y;
			if(rect.has_point(target) == true):
				onHandleGrabbed();
				get_tree().set_input_as_handled();
		else:
			if(mouseDown == true):
				onHandleReleased();
				get_tree().set_input_as_handled();
	elif(event.type == InputEvent.MOUSE_MOTION && mouseDown == true):
		var mousePos = event.pos;
		mousePos.x -= get_pos().x;
		mousePos.y -= get_pos().y;
		
		var inverseScale = 1 / get_scale().y;
		var newPos = Vector2(0, 0);
		newPos.y = mousePos.y * inverseScale;
		newPos.x = handle.get_pos().x;
		
		if(newPos.y < 0):
			newPos.y = 0;
		elif(newPos.y > get_node("track").get_texture().get_height() * 3):
			newPos.y = get_node("track").get_texture().get_height() * 3
		
		handle.set_pos(newPos);
		get_tree().set_input_as_handled();
		
		levelManager.currentLevel.setZoom(getRatio());

func getHeight():
	var totalHeight = 0;
	
	totalHeight += get_node("top").get_texture().get_height();
	totalHeight += get_node("bottom").get_texture().get_height();
	totalHeight += get_node("track").get_texture().get_height();
	totalHeight += get_node("track1").get_texture().get_height();
	totalHeight += get_node("track2").get_texture().get_height();
	
	return totalHeight;


