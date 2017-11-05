
extends Node2D

var root;

var lastMousePos = Vector2(0, 0);
var cameraBounds = Rect2(0, 0, 0, 0);
var mouseDown = false;
var camera;

func _ready():
	root = get_node("/root");
	onResize();
	root.connect("size_changed", self, "onResize");
	
	# Default the background to earth
	camera = get_node("camera");
	camera.make_current();
	camera.set_pos(get_node("islands/earth").get_pos());
	makeBounds();
	
	updateOpenLevels();
	set_process_unhandled_input(true);
	
	OS.set_time_scale(1.0);

func onResize():
	var screen = root.get_rect();
	
	var sizer = get_node("sizer");
	var scale = screen.size.height / sizer.get_size().height;
	
	if(sizer.get_size().width * scale > screen.size.width):
		scale = screen.size.width / sizer.get_size().width;
	
	var title = get_node("title");
	title.set_scale(Vector2(scale, scale));
	
func updateOpenLevels():
	var worlds = get_node("levels");
	for i in range(worlds.get_child_count()):
		var world = worlds.get_child(i).get_node("levels");
		for j in range(world.get_child_count()):
			var button = world.get_child(j);
			button.parentMap = self;
			if(levelManager.isLevelUnlocked(button.get_name()) == false):
				button.set_opacity(0.25);
			else:
				button.set_opacity(1.0);
				if(levelManager.isLevelNew(button.get_name()) == true):
					if(button.has_method("bounceButton") == true):
						button.bounceButton();

func _unhandled_input(event):
	if(event.type == InputEvent.MOUSE_BUTTON || event.type == InputEvent.SCREEN_TOUCH):
		if(event.is_pressed()):
			mouseDown = true;
			lastMousePos = event.pos;
		else:
			mouseDown = false;
	elif(event.type == InputEvent.MOUSE_MOTION || event.type == InputEvent.SCREEN_DRAG):
		if(mouseDown == false):
			return;
		var newMousePos = event.pos;
		var deltaX = newMousePos.x - lastMousePos.x;
		var deltaY = newMousePos.y - lastMousePos.y;
		lastMousePos = event.pos;
		
		var cameraPos = camera.get_pos();
		cameraPos.x -= deltaX;
		cameraPos.y -= deltaY;
		
		# Set the max bounds for the camera
		if(cameraPos.x < cameraBounds.pos.x):
			cameraPos.x = cameraBounds.pos.x;
		elif(cameraPos.x > cameraBounds.end.x):
			cameraPos.x = cameraBounds.end.x;
		
		if(cameraPos.y < cameraBounds.pos.y):
			cameraPos.y = cameraBounds.pos.y;
		elif(cameraPos.y > cameraBounds.end.y):
			cameraPos.y = cameraBounds.end.y;
		camera.set_pos(cameraPos);

func makeBounds():
	var container = get_node("islands");
	var numChildren = container.get_child_count();
	var minPoint = Vector2(1000000, 1000000);
	var maxPoint = Vector2(0, 0);
	for i in range(numChildren):
		var node = container.get_child(i);
		if(node extends Node2D):
			var nodePos = node.get_pos();
			if(nodePos.x < minPoint.x):
				minPoint.x = nodePos.x;
			elif (nodePos.x > maxPoint.x):
				maxPoint.x = nodePos.x;
			
			if(nodePos.y < minPoint.y):
				minPoint.y = nodePos.y;
			elif(nodePos.y > maxPoint.y):
				maxPoint.y = nodePos.y;
	
	cameraBounds = Rect2(minPoint.x, minPoint.y, maxPoint.x - minPoint.x, maxPoint.y - minPoint.y);
	print("cameraBounds ", str(cameraBounds));