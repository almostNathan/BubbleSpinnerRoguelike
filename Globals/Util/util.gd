extends Node

const RELATIVE_UP_LEFT : Vector2i = Vector2i(-1, -1)
const RELATIVE_UP_RIGHT : Vector2i = Vector2i(1, -1)
const RELATIVE_RIGHT : Vector2i = Vector2i(2, 0)
const RELATIVE_DOWN_RIGHT : Vector2i = Vector2i(1, 1)
const RELATIVE_DOWN_LEFT : Vector2i = Vector2i(-1, 1)
const RELATIVE_LEFT : Vector2i = Vector2i(-2, 0)

const RELATIVE_POSITIONS_ARRAY : Array[Vector2i] = [
	RELATIVE_RIGHT, 
	RELATIVE_DOWN_RIGHT,
	RELATIVE_DOWN_LEFT,
	RELATIVE_LEFT,
	RELATIVE_UP_LEFT,
	RELATIVE_UP_RIGHT]


var base_values = {
	"base_bubble_speed" : 1500,
	"base_bubble_weight" : 1
}
