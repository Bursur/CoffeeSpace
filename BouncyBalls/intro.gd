
extends Tween

const TRANSITION_TIME = 3.0;

var levelManager;
var targetPoints;
var currentPoint = 0;
var currentCamera;

func _ready():
	levelManager = get_node("/root/levelManager");
	connect("tween_complete", self, "onTweenComplete");

func startPan(camera, points):
	currentCamera = camera
	targetPoints = points;
	interpolate_property(currentCamera, "transform/pos", currentCamera.get_pos(), points[0], TRANSITION_TIME, TRANS_SINE, EASE_IN_OUT, 0.25);
	start();

func onTweenComplete(object, key):
	currentPoint += 1;
	if(currentPoint < targetPoints.size()):
		interpolate_property(currentCamera, "transform/pos", currentCamera.get_pos(), targetPoints[currentPoint], TRANSITION_TIME, TRANS_SINE, EASE_IN_OUT, 0.25);
		start();
	else:
		levelManager.currentLevel.enableCameraControls();