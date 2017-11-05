
extends Node2D

var isBouncing = false;

func _ready():
	pass

func startBouncing():
	if(isBouncing == true):
		return;
	
	onSquashComplete(null, "");
	isBouncing = true;

func stopBouncing():
	if(isBouncing == false):
		return;
	var tween = get_node("tween");
	var image = get_node("icon");
	
	tween.stop_all();
	if(tween.is_connected("tween_complete", self, "onExtendComplete") == true):
		tween.disconnect("tween_complete", self, "onExtendComplete");
	
	tween.interpolate_property(image, "transform/scale", image.get_scale(), Vector2(1.0, 1.0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
	tween.interpolate_property(image, "transform/pos", image.get_pos(), Vector2(0, 0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
	
	tween.start();
	isBouncing = false;

func onSquashComplete(object, key):
	var tween = get_node("tween");
	var image = get_node("icon");
	
	tween.interpolate_property(image, "transform/pos", Vector2(0, 0), Vector2(0, -50), 0.5, Tween.TRANS_SINE, Tween.EASE_OUT);
	tween.interpolate_property(image, "transform/scale", Vector2(1.2, 0.8), Vector2(1.0, 1.0), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT);
	tween.connect("tween_complete", self, "onExtendComplete");
	tween.start();

func onExtendComplete(object, key):
	var tween = get_node("tween");
	var image = get_node("icon");
	
	if(tween.is_connected("tween_complete", self, "onExtendComplete") == true):
		tween.disconnect("tween_complete", self, "onExtendComplete");
	tween.interpolate_property(image, "transform/pos", Vector2(0, -50), Vector2(0, 0), 0.5, Tween.TRANS_SINE, Tween.EASE_IN);
	tween.interpolate_property(image, "transform/scale", Vector2(1.0, 1.0), Vector2(1.2, 0.8), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4);
	tween.interpolate_callback(self, 0.51, "onSquashComplete", image, "");
	tween.start();
