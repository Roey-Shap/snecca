/// @description

//initialize each body part behind the snake's head, at a given angle
//var angle = last_direction;
//							vvv will be 1 vvv
add_to_body(starting_length - 1, o_collision_snake_part, last_direction);

last_input_direction = last_direction;
horizontal = last_input_direction % 180 == 0;	//horizontal is 1, vertical is 0

// see if this room should activate VANILLA snake mode

global.vanilla_snake_mode = false;
var len = array_length(global.vanilla_snake_rooms);
for (var i = 0; i < len; i++) {
	if global.vanilla_snake_rooms[i] == room {
		global.vanilla_snake_mode = true;
		break;
	}
}