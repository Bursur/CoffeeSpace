extends Node2D

var pulse = null;
var button = null;
var tween = null;
var buttonStartPos = null;

var levelManager = null;

var isEnabled = true;

var parentMap = null;

export (int, "Blue", "Green", "Red", "Grey", "Yellow") var colour;

func _ready():
	levelManager = get_node("/root/levelManager");
	pulse = get_node("pulse");
	tween = get_node("tween");
	
	button = get_node("button");
	button.connect("pressed", self, "onLevelSelected", [button]);
	
	button.set_normal_texture(load("res://balls/" + objectManager.NAME_LUT[colour] + ".png"));

func onLevelSelected(target):
	if(isEnabled == false):
		return;
	
	if(levelManager.isLevelUnlocked(get_name()) == false):
		return;
	
	if(levelManager.loadLevel(get_name()) == false):
		return;
	
	isEnabled = false;
	parentMap.queue_free();
	print(target.get_name());

func bounceButton():
	buttonStartPos = get_pos();
	onSquashComplete(null, "");
	
func onSquashComplete(object, key):
	tween.interpolate_property(self, "transform/pos", buttonStartPos, Vector2(buttonStartPos.x, buttonStartPos.y - 50), 0.5, Tween.TRANS_SINE, Tween.EASE_OUT);
	tween.interpolate_property(self, "transform/scale", Vector2(2.4, 1.6), Vector2(2.0, 2.0), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT);
	if(tween.is_connected("tween_complete", self, "onExtendComplete") == false):
		tween.connect("tween_complete", self, "onExtendComplete");
	tween.start();
	
	pulse.activate();

func onExtendComplete(object, key):
	if(tween.is_connected("tween_complete", self, "onExtendComplete") == true):
		tween.disconnect("tween_complete", self, "onExtendComplete");
	tween.interpolate_property(self, "transform/pos", get_pos(), buttonStartPos, 0.5, Tween.TRANS_SINE, Tween.EASE_IN);
	tween.interpolate_property(self, "transform/scale", Vector2(2.0, 2.0), Vector2(2.4, 1.6), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4);
	tween.interpolate_callback(self, 0.51, "onSquashComplete", self, "");
	tween.start();