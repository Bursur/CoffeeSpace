
extends Node2D

var objectManager = null;

var leftAngles = [1.13, 2.01];
var horizontalAngles = [(PI * 2) + 0.42, 5.83];
var rightAngles = [4.27, 5.14];
var verticalAngles = [2.72, 3.50];

var parentMenu = null;
var colour = "";

func _ready():
	if(objectManager == null):
		objectManager = get_node("/root/objectManager");
	
	var tween = get_node("tween");
	tween.interpolate_property(self, "visibility/opacity", 0.0, 1.0, 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tween.interpolate_property(self, "transform/scale", Vector2(0, 0), Vector2(1, 1), 0.15, Tween.TRANS_BACK, Tween.EASE_OUT);
	tween.start();
	
	var path = "res://platforms/" + colour + ".png";
	get_node("horizontal").set_texture(load(path));
	get_node("vertical").set_texture(load(path));
	get_node("left").set_texture(load(path));
	get_node("right").set_texture(load(path));
	
	set_process_input(true);

func setColour(newColour):
	print("Setting Colour " + newColour);
	colour = newColour;

func _input(event):
	if(event.type == InputEvent.MOUSE_BUTTON && event.is_pressed() == false):
		var mousePos = event.pos;
		var pos = get_global_pos();
		
		#var direction = pos - mousePos;
		#direction = direction.normalized();
		
		var angle = 0;#atan2(direction.x, direction.y);
		#if(angle < 0):
		#	angle = PI + (PI + angle);
		
		# Check if we need to place a platform or not
		var selectedAngle = -1
		if(buttonHighlighted(angle, leftAngles[0], leftAngles[1], "bg1", mousePos) == true):
			selectedAngle = objectManager.LEFT;
		elif(buttonHighlighted(angle, rightAngles[0], rightAngles[1], "bg2", mousePos) == true):
			selectedAngle = objectManager.RIGHT;
		elif(buttonHighlighted(angle, verticalAngles[0], verticalAngles[1], "bg4", mousePos) == true):
			selectedAngle = objectManager.VERTICAL;
		else:
			if(angle < PI):
				angle += PI * 2;
			if(buttonHighlighted(angle, horizontalAngles[1], horizontalAngles[0], "bg3", mousePos) == true):
				selectedAngle = objectManager.HORIZONTAL;
		
		if(selectedAngle != -1):
			parentMenu.placePlatform(objectManager.ANGLES[selectedAngle]);
		
		# All done
		parentMenu.closeMenu();
		parentMenu = null;
		tweenOff();
	else:
		get_tree().set_input_as_handled();

func buttonHighlighted(angle, minAngle, maxAngle, type, mousePos):
	var node = get_node(type);
	var pos = node.get_global_pos();
	var size = node.get_texture().get_width() * 0.5;
	size *= get_parent().get_scale().x;
	if(pos.distance_to(mousePos) <= size):
		#if(angle > minAngle && angle < maxAngle):
		return true;
	
	return false;

func tweenOff():
	var tween = get_node("tween");
	tween.interpolate_property(self, "transform/scale", Vector2(1, 1), Vector2(0, 0), 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tween.interpolate_property(self, "visibility/opacity", 1.0, 0.0, 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tween.start();