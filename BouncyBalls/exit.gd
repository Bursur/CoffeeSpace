
extends Node2D

var objectManager;
var levelManager;

func _ready():
	objectManager = get_node("/root/objectManager");
	levelManager = get_node("/root/levelManager");
	
	var body = get_node("collisionBox");
	body.set_collision_mask(objectManager.GREY_MASK);
	body.set_layer_mask(objectManager.GREY_MASK);

func exit(body):
	var colour = objectManager.MASK_LUT.find(body.get_layer_mask());
	levelManager.currentOutput[colour] += 1;
	
	body.despawn();
	
	var pos = get_global_pos();
	var ballPos = body.get_global_pos();
	
	pos.x = ballPos.x - pos.x;
	pos.y = ballPos.y - pos.y;
	
	var dust = get_node("dust");
	dust.set_pos(pos);
	dust.set_emitting(true);