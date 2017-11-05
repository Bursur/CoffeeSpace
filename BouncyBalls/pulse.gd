extends Node2D

var texture = null;
var tween = null;

func _ready():
	texture = get_node("texture");
	tween = get_node("tween");
	set_opacity(0.0);

func activate():
	set_opacity(1.0);
	tween.interpolate_property(texture, "transform/scale", Vector2(0.8, 0.8), Vector2(2.0, 2.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tween.interpolate_property(texture, "visibility/opacity", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tween.start();