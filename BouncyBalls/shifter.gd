
extends Node2D

var objectManager;


export (int, "Blue", "Green", "Red") var colour;

const SPIN_DURATION = 1.5;

func _ready():
	objectManager = get_node("/root/objectManager");
	
	var tween = get_node("spinTween");
	tween.interpolate_property(self, "transform/rot", 0, 359, SPIN_DURATION, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR);
	tween.set_repeat(true);
	tween.start();
	
	get_node("texture").set_texture(load("res://shifter/" + objectManager.NAME_LUT[colour] + ".png"));
	
	var body = get_node("collisionBox");
	body.set_collision_mask(objectManager.INVERSE_LUT[colour]);
	body.set_layer_mask(objectManager.INVERSE_LUT[colour]);