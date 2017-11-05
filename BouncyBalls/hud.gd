
extends Node2D

var levelManager;
const blueRatio = 0.2;
const redRatio = 0.45;
const greenRatio = 0.7;

var baseHeight;
var baseSliderWidth;
var baseSliderHeight;
var baseFastForwardHeight;

func _ready():
	levelManager = get_node("/root/levelManager");
	setTextLayout("red");
	setTextLayout("green");
	setTextLayout("blue");
	
	baseHeight = get_node("blue/icon").get_texture().get_height();
	baseSliderWidth = get_node("slider").get_node("top").get_texture().get_width();
	baseSliderHeight = get_node("slider").getHeight();
	baseFastForwardHeight = get_node("fastForward").get_normal_texture().get_height();
	
	var button = get_node("fastForward");
	#button.connect("pressed", self, "onFastForward");
	
	var root = get_node("/root");
	root.connect("size_changed", self, "onResize");
	updateSize();

func onFastForward():
	if(OS.get_time_scale() == 1.0):
		OS.set_time_scale(2.0);
	else:
		OS.set_time_scale(1.0);

func onResize():
	updateSize();

func updateSize():
	var root = get_node("/root");
	var screenSize = root.get_rect();
	
	var newScale = (screenSize.size.height * 0.10) / baseHeight;
	
	var height = get_node("blue/icon").get_texture().get_height() * newScale;
	height *= 0.75;
	var pos = Vector2(0, screenSize.size.height - height);
	
	var node = get_node("blue");
	node.set_scale(Vector2(newScale, newScale));
	pos.x = screenSize.size.width * blueRatio;
	node.set_pos(pos);
	
	node = get_node("red");
	node.set_scale(Vector2(newScale, newScale));
	pos.x = screenSize.size.width * redRatio;
	node.set_pos(pos);
	
	node = get_node("green");
	node.set_scale(Vector2(newScale, newScale));
	pos.x = screenSize.size.width * greenRatio;
	node.set_pos(pos);
	
	newScale = (screenSize.size.height * 0.10) / baseFastForwardHeight;
	node = get_node("fastForward");
	node.set_scale(Vector2(newScale, newScale));
	pos.x = screenSize.size.width * 0.03;
	pos.y = screenSize.size.height * 0.88;
	node.set_pos(pos);
	
	newScale = (screenSize.size.width * 0.08) / baseSliderWidth;
	node = get_node("slider");
	node.set_scale(Vector2(newScale, newScale));
	var newHeight = baseSliderHeight * newScale;
	pos.y = (screenSize.size.height - newHeight) * 0.5;
	pos.x = screenSize.size.width - ((baseSliderWidth * newScale) * 0.4);
	node.set_pos(pos);

func setTextLayout(colour):
	var index = objectManager.NAME_LUT.find(colour);
	var node = get_node(colour);
	var text = node.get_node("text");
	
	if(levelManager.targetOutput[index] == 0):
		node.set_opacity(0.0);
		return;
	else:
		node.set_opacity(1.0);
	
	var remaining = levelManager.targetOutput[index] - levelManager.currentOutput[index];
	if(remaining <= 0):
		remaining = 0;
		node.startBouncing();
	else:
		node.stopBouncing();
	
	text.setText("x" + str(remaining));
	
	var pos = node.get_node("icon").get_texture().get_width();
	text.set_pos(Vector2(pos, 0));

func update():
	setTextLayout("red");
	setTextLayout("green");
	setTextLayout("blue");