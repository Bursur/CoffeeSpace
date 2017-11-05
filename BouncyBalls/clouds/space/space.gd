
extends ParallaxBackground

func _ready():
	var root = get_node("/root");
	onResize();
	root.connect("size_changed", self, "onResize");

func onResize():
	var bg = get_node("backgroundLayer/background");
	
	var root = get_node("/root");
	var screenSize = root.get_rect();
	
	bg.set_region_rect(Rect2(0, 0, screenSize.size.width, screenSize.size.height));