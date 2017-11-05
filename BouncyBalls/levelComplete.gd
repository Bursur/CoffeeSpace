
extends Node2D

func _ready():
	var root = get_node("/root");
	root.connect("size_changed", self, "onResize");
	onResize();
	
	get_node("continueButton").set_opacity(0.0);
	
	var continueButton = get_node("continueButton");
	continueButton.connect("pressed", self, "onContinueButton");
	
	var tween = get_node("tween");
	tween.connect("tween_complete", self, "onTweenComplete");
	
	tween.interpolate_property(get_node("levelComplete"), "transform/scale", Vector2(0, 0), Vector2(1, 1), 0.75, Tween.TRANS_BACK, Tween.EASE_OUT);
	tween.start();
	
	set_process_input(true);
	
	OS.set_time_scale(1.0);

func onTweenComplete(object, key):
	var tween = get_node("tween");
	tween.disconnect("tween_complete", self, "onTweenComplete");
	
	tween.interpolate_property(get_node("continueButton"), "visibility/opacity", 0.0, 1.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tween.start();

func _input(event):
	if(event.type == InputEvent.MOUSE_BUTTON):
		onContinueButton();
		set_process_input(false);
		get_tree().set_input_as_handled();

func onResize():
	var screenSize = get_viewport_rect();
	var panelSize = get_node("sizer").get_size();
	
	var scale = screenSize.size.width / panelSize.width;
	
	var pos = Vector2(screenSize.size.width * 0.5, screenSize.size.height * 0.5);
	var nextText = get_node("levelComplete");
	nextText.set_scale(Vector2(scale, scale));
	nextText.set_pos(pos);
	
	var continueText = get_node("continueButton");
	continueText.set_scale(Vector2(scale, scale));
	var pos = Vector2(screenSize.size.width, screenSize.size.height);
	var texture = continueText.get_normal_texture();
	pos.x -= ((texture.get_width() * continueText.get_texture_scale().x) * scale) * 1.1;
	pos.y -= ((texture.get_height() * continueText.get_texture_scale().y) * scale) * 1.1;
	
	continueText.set_pos(pos);

func onContinueButton():
	var levelManager = get_node("/root/levelManager");
	#levelManager.levelNum += 1;
	#levelManager.loadLevel(levelManager.levelNum);
	levelManager.goToMainMenu();