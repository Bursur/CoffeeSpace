
extends Node2D

var nodes = [];

func _ready():
	# get a list of all the nodes in this object
	var number = 1;
	while(has_node(str(number)) == true):
		var node = get_node(str(number));
		nodes.push_back(node);
		
		number += 1;
	
	makeIdleTween();

func makeIdleTween():
	var tween = get_node("tween");
	
	var count = 0;
	for node in nodes:
		var pos = node.get_pos();
		var delay = 5 + (count * 0.05);
		count += 1;
		
		tween.interpolate_property(node, "transform/scale", Vector2(1.0, 1.0), Vector2(1.1, 0.9), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay);
		tween.interpolate_property(node, "transform/scale", Vector2(1.1, 0.9), Vector2(1.0, 1.0), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT, delay + 0.1);
		
		node.set_pos(pos);
	
	tween.set_repeat(true);
	tween.start();