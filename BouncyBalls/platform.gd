
extends Node2D

export (int, "Blue", "Green", "Red", "Grey", "Yellow") var colour;

const BOUNCE_DISTANCE = 5;
const BOUNCE_TIME = 0.1;

var objectManager;

func _ready():
	objectManager = get_node("/root/objectManager");
	
	var body = get_node("staticBody");
	body.set_collision_mask(objectManager.MASK_LUT[colour]);
	body.set_layer_mask(objectManager.MASK_LUT[colour]);
	
	get_node("texture").set_texture(load("res://platforms/" + objectManager.NAME_LUT[colour] + ".png"));

func bounce(body):
	if(colour == objectManager.YELLOW):
		if(body.has_method("nextColour") == true):
			body.nextColour();
	
	var tween = get_node("bounceTween");
	if(tween.is_connected("tween_complete", self, "onTweenComplete") == true):
		return;
	tween.connect("tween_complete", self, "onTweenComplete");
	tween.interpolate_property(get_node("texture"), "transform/pos", Vector2(0, 0), Vector2(0, BOUNCE_DISTANCE), BOUNCE_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0);
	tween.start();
	
	var sounds = get_node("sounds");
	sounds.play("bounce");

func onTweenComplete(object, key):
	var tween = get_node("bounceTween");
	tween.disconnect("tween_complete", self, "onTweenComplete");
	tween.interpolate_property(get_node("texture"), "transform/pos", Vector2(0, BOUNCE_DISTANCE), Vector2(0, 0), BOUNCE_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0);
	tween.start();