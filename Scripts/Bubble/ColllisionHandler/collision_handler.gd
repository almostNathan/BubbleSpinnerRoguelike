extends Node
class_name CollisionHandler

#local signals
signal on_collision(my_bubble, area)
signal after_collision(my_bubble, area)
#signal on_bubble_collision(my_bubble, area)
#signal after_bubble_collision(my_bubble, area)
#signal on_wall_collision(my_bubble, area)
#signal after_wall_collision(my_bubble, area)

static func get_new_instance() -> CollisionHandler:
	var new_instance := new()
	return new_instance

func handle_collision(my_bubble : BaseBubble, area : Area2D):
	self.on_collision.emit(self, area)
	if area.is_in_group('wall'):
		#TODO change to global signal and have all walls listen to the signal
		my_bubble.on_bounce.emit(my_bubble, area)
		area.bounce(my_bubble)
	if area.is_in_group('bubble') and !my_bubble.collided: 
		my_bubble.cur_speed = 0
		my_bubble.collided = true
		
		SignalHub.emit_bubble_colliding(my_bubble, area.get_parent())
		
	self.after_collision.emit(self, area)
	
