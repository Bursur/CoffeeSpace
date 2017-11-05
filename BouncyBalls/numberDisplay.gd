
extends Node2D

const TEXTURE_PATH = "res://hud/";

func setText(text):
	removeOldText();
	var pos = 0;
	var length = text.length();
	for i in range(length):
		var letter = text.substr(i, 1);
		
		var texture = load(TEXTURE_PATH + letter + ".png");
		var sprite = Sprite.new();
		sprite.set_texture(texture);
		
		sprite.set_pos(Vector2(pos, 0));
		pos += texture.get_width();
		
		add_child(sprite);

func removeOldText():
	var numChildren = get_child_count();
	for i in range(numChildren):
		var node = get_child(i);
		node.queue_free();

func getWidth():
	var width = 0;
	var numChildren = get_child_count();
	for i in range(numChildren):
		var node = get_child(i);
		width += node.get_texture().get_width();
		
	return width;