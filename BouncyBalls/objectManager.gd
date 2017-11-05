
extends Node

const BLUE = 0;
const GREEN = 1;
const RED = 2;
const GREY = 3;
const YELLOW = 4;

const BLUE_MASK = 1 << 0;
const RED_MASK = 1 << 1;
const GREEN_MASK = 1 << 2;
const GREY_MASK = BLUE_MASK | RED_MASK | GREEN_MASK;
const YELLOW_MASK = GREY_MASK;

const NAME_LUT = ["blue", "green", "red", "grey", "yellow"];
const MASK_LUT = [BLUE_MASK, GREEN_MASK, RED_MASK, GREY_MASK, YELLOW_MASK];
const COLOUR_LUT = [Color(0, 0, 1), Color(0, 1, 0), Color(1, 0, 0), Color(1, 1, 1), Color(1, 1, 1)];
const INVERSE_LUT = [RED_MASK | GREEN_MASK, BLUE_MASK | RED_MASK, GREEN_MASK | BLUE_MASK];
const SHIFT_SEQUENCE = [BLUE, GREEN, RED];

const HORIZONTAL = 0;
const VERTICAL = 1;
const LEFT = 2;
const RIGHT = 3;
const ANGLES = [0, 90, 20, 340];


func _ready():
	pass


