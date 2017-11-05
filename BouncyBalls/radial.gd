
extends Node2D

var greenAngles = [4.33, 5.1];
var redAngles = [(PI * 2) + 0.4, 5.88];
var blueAngles = [1.16, 1.97];

var targetScale = 1.0;

var selectedColour = "";

var parentNode = null;
var platformScene = preload("res://platform.scn");
var selectionScene = preload("res://selection.scn");

var levelManager;
var objectManager;

func _ready():
	levelManager = get_node("/root/levelManager");
	objectManager = get_node("/root/objectManager");
	
	set_process_input(true);
	setSize();
	tweenOn();
	
	# Set the text
	var available = levelManager.availablePlatforms[objectManager.NAME_LUT.find("green")];
	get_node("container/green/numbers").setText(str(available));
	if(available == 0):
		get_node("container/green").set_opacity(0.5);
	
	available = levelManager.availablePlatforms[objectManager.NAME_LUT.find("blue")];
	get_node("container/blue/numbers").setText(str(available));
	if(available == 0):
		get_node("container/blue").set_opacity(0.5);
	
	available = levelManager.availablePlatforms[objectManager.NAME_LUT.find("red")];
	get_node("container/red/numbers").setText(str(available));
	if(available == 0):
		get_node("container/red").set_opacity(0.5);

func setSize():
	var screen = get_node("/root");
	var size = screen.get_rect().size;
	var maxHeight = size.y * 0.4;
	var menuHeight = get_node("scaler").get_size().height;
	
	var newScale = maxHeight / menuHeight;
	targetScale = newScale;

func _input(event):
	if(event.type == InputEvent.MOUSE_BUTTON):
		if(event.is_pressed() == false):
			set_process_input(false);
			tweenOff();
	elif(event.type == InputEvent.MOUSE_MOTION):
		var mousePos = event.pos;
		var pos = get_global_pos();
		
		#var direction = pos - mousePos;
		#direction = direction.normalized();
		
		var angle = 0;#atan2(direction.x, direction.y);
		#if(angle < 0):
		#	angle = PI + (PI + angle);
		
		# work out what button the mouse is over
		if(buttonHighlighted(angle, blueAngles[0], blueAngles[1], "blue", mousePos) == true):
			selectedColour = "blue";
		elif(buttonHighlighted(angle, greenAngles[0], greenAngles[1], "green", mousePos) == true):
			selectedColour = "green";
		else:
			if(angle < PI):
				angle += PI * 2;
			if(buttonHighlighted(angle, redAngles[1], redAngles[0], "red", mousePos) == true):
				selectedColour = "red";
			else:
				selectedColour = "";
		
		if(selectedColour != ""):
			fade();
			set_process_input(false);
			var selection = selectionScene.instance();
			selection.setColour(selectedColour);
			selection.parentMenu = self;
			selection.set_pos(get_node("container/" + selectedColour).get_pos());
			get_node("container").add_child(selection);
		
		get_tree().set_input_as_handled();

func buttonHighlighted(angle, minAngle, maxAngle, colour, mousePos):
	if(levelManager.availablePlatforms[objectManager.NAME_LUT.find(colour)] == 0):
		return false
		
	var node = get_node("container/" + colour);
	var pos = node.get_global_pos();
	var size = node.get_node("texture").get_texture().get_width() * 0.5;
	size *= get_node("container").get_scale().x;
	if(pos.distance_to(mousePos) <= size):
		#if(angle > minAngle && angle < maxAngle):
		return true;
	
	return false;

func placePlatform(rot):
	var platform = platformScene.instance();
	platform.colour = objectManager.NAME_LUT.find(selectedColour);
	platform.set_rotd(rot);
	platform.set_pos(parentNode.get_pos());
	
	parentNode.platform = platform;
	levelManager.currentLevel.add_child(platform);
	
	levelManager.availablePlatforms[objectManager.NAME_LUT.find(selectedColour)] -= 1;

func closeMenu():
	tweenOff();

func fade():
	var tween = get_node("tween");
	var startAlpha = get_node("container").get_opacity();
	tween.interpolate_property(get_node("container/blue"), "visibility/opacity", startAlpha, startAlpha - 0.25, 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tween.interpolate_property(get_node("container/green"), "visibility/opacity", startAlpha, startAlpha - 0.25, 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tween.interpolate_property(get_node("container/red"), "visibility/opacity", startAlpha, startAlpha - 0.25, 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tween.start();

func tweenOn():
	var tween = get_node("tween");
	tween.interpolate_property(get_node("container"), "visibility/opacity", 0.0, 1.0, 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tween.interpolate_property(get_node("container"), "transform/scale", Vector2(0, 0), Vector2(targetScale, targetScale), 0.15, Tween.TRANS_BACK, Tween.EASE_OUT);
	tween.start();

func tweenOff():
	parentNode.childMenu = null;
	parentNode = null;
	
	var tween = get_node("tween");
	tween.interpolate_property(get_node("container"), "visibility/opacity", get_node("container").get_opacity(), 0.0, 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tween.interpolate_property(get_node("container"), "transform/scale", Vector2(targetScale, targetScale), Vector2(0, 0), 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tween.connect("tween_complete", self, "onTweenOffComplete");
	tween.start();

func onTweenOffComplete(object, key):
	levelManager.placementShown = false;
	queue_free();