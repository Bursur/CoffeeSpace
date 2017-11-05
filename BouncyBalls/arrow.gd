
extends Node2D

const RATIO = 0.05;
var targetExit;
var currentCamera;
var baseSize;

func _ready():
	pass

func setExit(exit, camera):
	targetExit = exit;
	currentCamera = camera;
	set_process(true);
	set_process_input(true);
	
	baseSize = get_node("texture").get_texture().get_width();
	
	get_node("/root").connect("size_changed", self, "onResize");
	setArrowSize();

func onResize():
	setArrowSize();

func setArrowSize():
	var screenSize = get_viewport_rect().size;
	var scale = (screenSize.width * RATIO) / baseSize;
	
	set_scale(Vector2(scale, scale));

func _input(event):
	if(get_opacity() < 1.0):
		return;
	
	if(event.type == InputEvent.MOUSE_BUTTON && event.is_pressed() == false):
		var pos = event.pos;
		var arrowPos = get_pos();
		if(arrowPos.distance_to(pos) <= (get_node("texture").get_texture().get_width() * get_scale().x) * 0.5):
			get_node("/root/levelManager").currentLevel.showExit();

func _process(delta):
	if(targetExit == null):
		set_process(false);
	
	var viewport = get_viewport_rect();
	var exitPos = targetExit.get_pos();
	if(isOnScreen(exitPos) == true):
		set_opacity(0.0);
	else:
		var cameraPos = currentCamera.get_pos();
	
		var direction = exitPos - cameraPos;
		var unit = direction.normalized();
		var angle = atan2(unit.x, unit.y);
		
		set_rot(angle);
		
		var pos = Vector2(viewport.size.width * 0.5, viewport.size.height * 0.5);
		var textureSize = Vector2(get_node("texture").get_texture().get_width() * 0.5, get_node("texture").get_texture().get_height() * 0.5);
		pos += unit * (viewport.size.height * 0.5);# * 100);
		if(pos.x > viewport.size.width - textureSize.x):
			pos.x = viewport.size.width - textureSize.x;
		elif(pos.x < 0 + textureSize.x):
			pos.x = 0 + textureSize.x;
		
		if(pos.y > viewport.size.height - textureSize.y):
			pos.y = viewport.size.height - textureSize.y;
		elif(pos.y < 0 + textureSize.y):
			pos.y = 0 + textureSize.y;
		set_pos(pos);
		
		set_opacity(1.0);

func isOnScreen(pos):
	var viewport = get_viewport_rect();
	var screenSize = Vector2(viewport.size.width, viewport.size.height);
	var zoom = currentCamera.get_zoom().x;
	var level = get_node("/root/levelManager").currentLevel;
	zoom = (zoom - level.minZoom);
	zoom += 0.5;
	
	screenSize.x *= zoom;
	screenSize.y *= zoom;
	
	var screenPos = currentCamera.get_pos();
	screenPos.x -= screenSize.x * 0.5;
	screenPos.y -= screenSize.y * 0.5;
	
	if(pos.x > screenPos.x && pos.x < screenPos.x + screenSize.x):
		if(pos.y > screenPos.y && pos.y < screenPos.y + screenSize.y):
			return true;
	
	return false;



