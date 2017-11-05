
extends Node2D

export var rate = 5.0;
export (int, "Blue", "Green", "Red", "Grey") var colour;

var objectManager;
var levelManager;

var lastSpawn = 0.0;

var ballScene = preload("res://ball.scn");

func _ready():
	objectManager = get_node("/root/objectManager");
	levelManager = get_node("/root/levelManager");
	var texture = get_node("texture");
	texture.set_texture(load("res://spawners/" + objectManager.NAME_LUT[colour] + ".png"));
	set_process(true);
	
	var body = get_node("staticBody");
	body.set_collision_mask(objectManager.MASK_LUT[colour]);
	body.set_layer_mask(objectManager.MASK_LUT[colour]);

func _process(delta):
	lastSpawn += delta;
	if(lastSpawn >= rate):
		var node = ballScene.instance();
		var texture = node.get_node("rigidBody/texture");
		
		var path = "res://balls/";
		if(levelManager.currentLevel.isSpace == true):
			path += "space/";
		path += objectManager.NAME_LUT[colour] + ".png";
		texture.set_texture(load(path));
		
		var body = node.get_node("rigidBody");
		body.set_layer_mask(objectManager.MASK_LUT[colour]);
		body.set_collision_mask(objectManager.MASK_LUT[colour]);
		body.currentColour = colour;
		
		var pos = get_global_pos();
		if(levelManager.currentLevel.isChallenge == false):
			pos.y += texture.get_texture().get_size().height * 2;
		else:
			if(levelManager.currentLevel.isSpace == true):
				pos.y += texture.get_texture().get_size().height * 2;
			else:
				pos.y -= texture.get_texture().get_size().height * 2;
		node.set_pos(pos);
		
		get_parent().add_child(node);
		
		if(levelManager.currentLevel.isSpace == true):
			body.apply_impulse(Vector2(0, 0), Vector2(0, 100));
		
		lastSpawn = 0.0;