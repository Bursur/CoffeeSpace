
extends Area2D

func _ready():
	connect("body_enter", self, "onCollision");

func onCollision(body):
	if(body.has_method("changeColour")):
		body.changeColour(get_parent().colour);