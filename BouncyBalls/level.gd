
extends Node2D

var completeScene = preload("res://levelComplete.scn");
var completeShown = false;

var landscapeScene = preload("res://landscape.scn");

var camera;
var mouseDown = false;
var lastMousePos = Vector2(0, 0);
var cameraBounds = Rect2(0, 0, 0, 0);

export var exitTarget = [10, 0, 0];
export var redPlatforms = 2;
export var bluePlatforms = 0;
export var greenPlatforms = 0;
export var enableCamera = true;
export var minZoom = 0.5;
export var maxZoom = 1.5;
export var isSpace = false;
export var isChallenge = false;

var touches = [];
var touchIndices = [];
var touchPositions = [];
var initialDistance = 0;
var threshold = 10;
var hasPinched = false;

var levelManager;

func _ready():
	levelManager = get_node("/root/levelManager");
	levelManager.currentLevel = self;
	
	# Get the initial gravity of the world
	if(levelManager.initialGravity == null):
		levelManager.initialGravity = Physics2DServer.area_get_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY);
		levelManager.initialLinearDamping = Physics2DServer.area_get_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_LINEAR_DAMP);
		levelManager.initialAngularDamping = Physics2DServer.area_get_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_ANGULAR_DAMP);
	
	makeBounds();
	if(enableCamera == true):
		camera = get_node("camera");
	else:
		get_node("camera").queue_free();
	
	setRequirements();
	
	set_process(true);
	
	if(has_node("intro") == true):
		makeIntroTween();
	
	if(has_node("hudLayer/arrow") == true):
		setupArrow();

func _process(delta):
	# Set the new gravity of the world
	if(isSpace == true):
		Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, 0);
		Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_LINEAR_DAMP, 0);
		Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_ANGULAR_DAMP, 0);
	else:
		if(isChallenge == false):
			Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, levelManager.initialGravity);
			Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_LINEAR_DAMP, levelManager.initialLinearDamping);
			Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_ANGULAR_DAMP, levelManager.initialAngularDamping);
		else:
			Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, -levelManager.initialGravity);
	
	levelManager.time += delta;

func enableCameraControls():
	if(enableCamera == true):
		set_process_unhandled_input(true);

func _unhandled_input(event):
	if(levelManager.placementShown == true):
		hasPinched = false;
		initialDistance = 0;
		touches.clear();
		touchPositions.clear();
		touchIndices.clear();
		return;
	
	if(event.type == InputEvent.MOUSE_BUTTON || event.type == InputEvent.SCREEN_TOUCH):
		if(event.type == InputEvent.SCREEN_TOUCH):
			handleMultiMouseButton(event);
		else:
			if(event.is_pressed()):
				mouseDown = true;
				lastMousePos = event.pos;
			else:
				mouseDown = false;
	elif(event.type == InputEvent.MOUSE_MOTION || event.type == InputEvent.SCREEN_DRAG):
		if(mouseDown == true):
			if(hasPinched == true):
				return;
			
			get_node("intro").stop_all();
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
		else:
			if(event.type == InputEvent.SCREEN_DRAG):
				handlePinch(event);

func handleMultiMouseButton(event):
	var index = touchIndices.find(event.index);
	if(index == -1):
		touchIndices.push_back(event.index);
		touches.push_back(event);
		touchPositions.push_back(event.pos);
	else:
		if(event.is_pressed() == true):
			touchIndices.push_back(event.index);
			touches.push_back(event);
			touchPositions.push_back(event.pos);
		else:
			touchIndices.remove(index);
			touches.remove(index);
			touchPositions.remove(index);
	
	if(touches.size() == 1):
		mouseDown = true;
		lastMousePos = event.pos;
	elif(touches.size() == 0):
		hasPinched = false;
	else:
		if(touches.size() >= 2):
			initialDistance = touchPositions[0].distance_to(touchPositions[1]) * 0.01;
		mouseDown = false;

func handlePinch(event):
	if(touches.size() < 2):
		return;
		
	if(touches.size() >= 2):
		var number = touchIndices.find(event.index);
		if(number != -1):
			touchPositions[number] = event.pos;
		else:
			return;
	
	var left = touchPositions[0];
	var right = touchPositions[1];
	
	var distance = left.distance_to(right) * 0.01;
	
	if(abs(initialDistance - distance) > 0):
		var camera = get_node("camera");
		var newZoom = distance / initialDistance;#initialDistance / distance;
		var zoom = newZoom * camera.get_zoom().x;
		
		var diff = camera.get_zoom().x - zoom;
		zoom = camera.get_zoom().x + (diff * 0.01);
		
		if(zoom < minZoom):
			zoom = minZoom;
		elif(zoom > maxZoom):
			zoom = maxZoom;
		camera.set_zoom(Vector2(zoom, zoom));
		hasPinched = true;

func setRequirements():
	# Setup the requirements and limits on this level
	var objectManager = get_node("/root/objectManager");
	
	levelManager.time = 0;
	levelManager.currentOutput = [0, 0, 0];
	levelManager.targetOutput = exitTarget;
	levelManager.availablePlatforms[objectManager.NAME_LUT.find("blue")] = bluePlatforms;
	levelManager.availablePlatforms[objectManager.NAME_LUT.find("green")] = greenPlatforms;
	levelManager.availablePlatforms[objectManager.NAME_LUT.find("red")] = redPlatforms;
	
	updateUI();

func updateUI():
	if(has_node("hudLayer/hud") == true):
		var hud = get_node("hudLayer/hud");
		hud.update();
	
	if(levelManager.isLevelComplete() == true):
		if(has_node("hudLayer") == true && completeShown == false):
			var hud = get_node("hudLayer");
			var menu = completeScene.instance();
			hud.add_child(menu);
			
			get_node("hudLayer/hud").queue_free();
		
		if(has_node("tutorial") == true):
			get_node("tutorial").queue_free();
			
		set_process_input(false);
		completeShown = true;

func makeBounds():
	var numChildren = get_child_count();
	var minPoint = Vector2(1000000, 1000000);
	var maxPoint = Vector2(0, 0);
	for i in range(numChildren):
		var node = get_child(i);
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
	
	levelManager.maxBounds = Vector2(maxPoint.x * 5, maxPoint.y * 5);
	levelManager.minBounds = Vector2(maxPoint.x * -5, maxPoint.y * -5);
	levelManager.deathPoint = maxPoint.y * 5;
	
	if(isSpace == false):
		makeLandscape(minPoint, maxPoint);

func makeLandscape(minPoint, maxPoint):
	var pos = Vector2(0, maxPoint.y + 175);
	var screenSize = get_viewport_rect().size;
	
	pos.x = minPoint.x - (screenSize.width * 1.5)
	
	var numLandscapes = 0;
	
	while(pos.x < maxPoint.x + (screenSize.width * 1.5)):
		var node = landscapeScene.instance();
		node.set_pos(pos);
		
		add_child(node);
		move_child(node, numLandscapes);
		numLandscapes += 1;
		pos.x += 2998;

func setupArrow():
	var arrow = get_node("hudLayer/arrow");
	arrow.setExit(get_node("exit"), get_node("camera"));

func makeIntroTween():
	var tween = get_node("intro");
	var points = [];
	points.push_back(get_node("exit").get_pos());
	
	var index = 0;
	var searchNode = "spawner";
	while(has_node(searchNode) == true):
		var spawner = get_node(searchNode);
		points.push_back(spawner.get_pos());
		
		index += 1;
		searchNode = "spawner" + str(index);
	
	tween.startPan(get_node("camera"), points);

func showExit():
	if(is_processing_unhandled_input() == false):
		return;
	
	var tween = get_node("intro");
	var camera = get_node("camera");
	tween.interpolate_property(camera, "transform/pos", camera.get_pos(), get_node("exit").get_pos(), 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT);
	tween.start();

func setZoom(ratio):
	var zoomRange = maxZoom - minZoom;
	var newZoom = minZoom + (zoomRange * ratio);
	
	get_node("camera").set_zoom(Vector2(newZoom, newZoom));





