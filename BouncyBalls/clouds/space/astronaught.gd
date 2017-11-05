extends Node2D

var tween = null;
var alienTween = null;

const TOTAL_TIME = 60.0
const ALIEN_TIME = 15.0;

func _ready():
	tween = get_node("tween");
	
	tween.connect("tween_complete", self, "tweenComplete");
	tween.interpolate_property(self, "transform/rot", 0, -360, TOTAL_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
	tween.start();
	
	alienTween = get_node("alien/tween");
	alienTween.connect("tween_complete", self, "tweenAlienComplete");
	alienTween.interpolate_property(get_node("alien"), "transform/rot", 0, 360, ALIEN_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
	alienTween.start();

func tweenComplete(object, key):
	tween.interpolate_property(self, "transform/rot", 0, -360, TOTAL_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
	tween.start();

func tweenAlienComplete(object, key):
	alienTween.interpolate_property(get_node("alien"), "transform/rot", 0, 360, ALIEN_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
	alienTween.start();