
extends RigidBody2D

var objectManager;
var levelManager;

export var velocityMultiplier = 1.00;
export var spaceVelocityMultiplier = 1.00;

const DESPAWN_RATE = 2.5;
var fade = 1.0;

var turnRate = 360.0;

var currentColour = -1;

func _ready():
	objectManager = get_node("/root/objectManager");
	levelManager = get_node("/root/levelManager");
	set_max_contacts_reported(5);
	set_contact_monitor(true);
	connect("body_exit", self, "_on_collision_end");
	connect("body_enter", self, "_on_collision_begin");
	
	set_process(true);
	
	get_node("dust").set_emitting(true);

func _process(delta):
	var pos = get_pos();
	if(pos.y < levelManager.minBounds.y || pos.y > levelManager.maxBounds.y):
		despawn();
	elif(pos.x < levelManager.minBounds.x || pos.x > levelManager.maxBounds.x):
		despawn();
	
	var velocity = get_linear_velocity();
	var rot = get_node("texture").get_rotd();
	if(velocity.x > 0):
		rot -= turnRate * delta;
	elif(velocity.x < 0):
		rot += turnRate * delta;
	
	get_node("texture").set_rotd(rot);

func _on_collision_end(body):
	if(body extends StaticBody2D):
		if(levelManager.currentLevel == null || levelManager.currentLevel.isSpace == false):
			set_linear_velocity(get_linear_velocity() * velocityMultiplier);
		else:
			set_linear_velocity(get_linear_velocity() * spaceVelocityMultiplier);
		
		var bodyParent = body.get_parent();
		if(bodyParent.has_method("bounce")):
			bodyParent.bounce(self);

func _on_collision_begin(body):
	if(body extends StaticBody2D):
		var bodyParent = body.get_parent();
		if(bodyParent.has_method("exit")):
			bodyParent.exit(self);

func changeColour(colour):
	var name = "res://balls/";
	if(levelManager.currentLevel.isSpace == true):
		name += "space/";
	name += objectManager.NAME_LUT[colour] + ".png";
	get_node("texture").set_texture(load(name));
	set_collision_mask(objectManager.MASK_LUT[colour]);
	set_layer_mask(objectManager.MASK_LUT[colour]);
	get_node("dust").set_emitting(true);
	currentColour = colour;

func nextColour():
	currentColour = currentColour + 1;
	if(currentColour >= objectManager.SHIFT_SEQUENCE.size()):
		currentColour = 0;
	
	changeColour(currentColour);

func despawn():
	set_process(true);
	fade = get_parent().get_scale().x;
	disconnect("body_exit", self, "_on_collision_end");
	set_collision_mask(0);
	set_layer_mask(0);
	
	var ball = get_parent();
	ball.set_hidden(true);
	ball.queue_free();
	
	var level = ball.get_parent();
	level.updateUI();