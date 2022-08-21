/// @description

var hinput = sign(keyboard_check(right_key)	- keyboard_check(left_key) + keyboard_check(vk_right) - keyboard_check(vk_left));
var vinput = sign(keyboard_check(down_key)	- keyboard_check(up_key) + keyboard_check(vk_down) - keyboard_check(vk_up));

var prev_head_x = head_x;
var prev_head_y = head_y;

if dummy_mode {
	hinput = 0;
	vinput = 0;
	if irandom(60) == 0 {
		hinput = choose(-1, 0, 1);
		vinput = (hinput == 0) * choose(-1, 0, 1);
	}
}

// if holding hinput and pressed vinput, switch to vinput, and vice versa
// if pressing both, prefer horizontal
var pot_hinput = hinput;
var pot_vinput = vinput;

var pressed_hinput = hinput != 0 and last_hinput == 0;
var pressed_vinput = vinput != 0 and last_vinput == 0;

var changed = false;
if horizontal {
	if pressed_vinput {
		horizontal = false;
		pot_hinput = 0;
		changed = true;
	} else {
		if hinput {
			pot_vinput = 0;
		} else {
			horizontal = false;
		}
	}
}

if !horizontal {
	if pressed_hinput and !changed {
		horizontal = true;
		pot_vinput = 0;
	} else {
		if vinput {
			pot_hinput = 0;
		} else {
			horizontal = true; 
		}
	}
}


if pot_hinput != 0 and pot_vinput != 0 {
	pot_vinput = 0;	// horizontal has precedence
}



// to account for how the code treats hinput and vinput in the old movement style
if !global.vanilla_snake_mode {
	
	// store for comparison next frame
	last_hinput = hinput;
	last_vinput = vinput;
	
	

	pot_hinput *= global.step;
	pot_vinput *= global.step;
	hinput = pot_hinput;
	vinput = pot_vinput;
}

// 
if global.vanilla_snake_mode {
	
	if !global.step {
		if hinput != 0 last_hinput = hinput;
		if vinput != 0 last_vinput = vinput;
		if last_hinput != 0 and last_vinput != 0 {
			last_vinput = 0;
		}
		
		hinput = 0;
		vinput = 0;
		
	} else {
		if hinput == 0 and vinput == 0 {
			hinput = last_hinput;
			vinput = last_vinput;
		}
		
		var emulated_dir = point_direction(0, 0, hinput, vinput * (hinput == 0));
		
		if hinput == 0 and vinput == 0 or (emulated_dir + 180) % 360 == last_direction {
			emulated_dir = last_direction;
		}
		
		hinput = lengthdir_x(1, emulated_dir);
		vinput = lengthdir_y(1, emulated_dir);
		
		last_hinput = 0;
		last_vinput = 0;
	}
	pot_hinput = hinput;
	pot_vinput = vinput;
}


if pot_hinput != 0 or pot_vinput != 0 {
	last_input_direction = point_direction(0, 0, pot_hinput, pot_vinput) % 360;
	if last_input_direction < 0 last_input_direction = 360 - last_input_direction;
}

var parts_array = array_create(cur_length);
for (var i = 0; i < cur_length; i++){
	parts_array[i] = get_part_id(i);
}


var head = parts_array[0];
head_x = head.x;
head_y = head.y;

var potx = head_x + (CELL_W*pot_hinput);
var poty = head_y + (CELL_H*pot_vinput);
var pot_input_dir = point_direction(0, 0, pot_hinput, pot_vinput) % 360;
if pot_input_dir < 0 pot_input_dir = 360 - pot_input_dir;

var backwards = (pot_input_dir == (last_direction + 180) % 360);
if (!moved_once or cur_length == 1) backwards = false;
var in_bounds = potx >= CELL_W and potx <= room_width-CELL_W and poty >= CELL_H and poty <= room_height-CELL_H;
var can_move = (!place_meeting(potx, poty, o_collision_parent_below) or place_meeting(potx, poty, o_snake_part_parent)) and !backwards and in_bounds;

var prev_direction = last_direction;

if (pot_hinput != 0 or pot_vinput != 0) and (can_move) {
	if !moved_once moved_once = true;
	last_direction = pot_input_dir % 360;
	if last_direction < 0 last_direction = 360 - last_direction;
}


//Biting
//If you're about to move to a spot where a piece of your body already is,
//then destroy that piece and everything after it, making them walls

if moved_once {
	var remove = false;
	var me = id;
	with(head){
		var snake_part = instance_place(potx, poty, o_snake_part_parent); //o_collision_snake_part just regulars?
		if snake_part != noone {
			// if you're in VANILLA MODE, you lose!
			if global.vanilla_snake_mode {
				vanilla_mode_death_effects(other.head_x, other.head_y);
				
				if snake_part.snake_parent == me and snake_part.part != -1 and snake_part.part != 1 and snake_part.part != 2 
					and snake_part.x != other.overlapx and snake_part.y != other.overlapy {
					with (other) {
						remove_body_from_part_no_making_walls(snake_part.part);
					}
				}
				
				
			} else {
				//if the part is part of me and not right behind me
				if snake_part.snake_parent == me and snake_part.part != -1 and snake_part.part != 1 and snake_part.part != 2 
					and snake_part.x != other.overlapx and snake_part.y != other.overlapy {
					remove = true;
				}
			}
		}
	}
	
	if remove remove_body_from_part(snake_part.part);
}

//update the acting parts list
var parts_array = array_create(cur_length);
for (var i = 0; i < cur_length; i++){
	parts_array[i] = get_part_id(i);
}


//Turrets---------------------
with (o_turret) {
	turret_step();
}


//Movement-------------------------
for (var i = 0; i < cur_length; i++) {
	with(parts_array[i]){
		if object_index != o_collision_snake_dir_switch {
			switch_dir = dir;
		}
	}
}


//Character direction update
with(o_character_parent){
	//Update based on directional snake parts
	var p_floor = instance_place(x, y, o_player_floor_parent);
	if p_floor != noone {
		if variable_instance_exists(p_floor, "switch_dir"){
			if p_floor.switch_dir != -1 {
				walk_dir = p_floor.switch_dir;
			}
		}
	}
	//if pot_hinput == 0 and pot_vinput == 0 {
	//	//update to turn towards cheese
	//	if place_meeting(x + CELL_W, y, o_cheese) walk_dir = 0;
	//	if place_meeting(x - CELL_W, y, o_cheese) walk_dir = 180;
	//	if place_meeting(x, y - CELL_H, o_cheese) walk_dir = 90;
	//	if place_meeting(x, y + CELL_H, o_cheese) walk_dir = 270;
	//}
}

//with(o_turret_parent){
//	//Update based on directional snake parts
//	var p_floor = instance_place(x, y, o_player_floor_parent);
//	if p_floor != noone {
//		if variable_instance_exists(p_floor, "switch_dir"){
//			if p_floor.switch_dir != -1 {
//				fire_direction = p_floor.switch_dir;
//			}
//		}
//	}
//}

if !place_meeting(potx, poty, o_collision_parent_below) {
	var turret = instance_place(potx, poty, o_turret_parent);
	if turret != noone {
		with (turret) {
			//check if it can move - if it can't, stop the snake
			var move_x = x + hinput*CELL_W;
			var move_y = y + vinput*CELL_H;
			if place_meeting(move_x, move_y, o_barrier) or place_meeting(move_x, move_y, o_door_parent){
				pot_hinput = 0;
				pot_vinput = 0;
				last_direction = prev_direction; //so as to not cause silly direction errors
			} else {
				//move into that spot
				x = move_x;
				y = move_y;
				//and set yourself on top of it
				if place_meeting(x, y, o_player_floor_parent){
					layer = layer_get_id("Above");
				}
			}
		}
	}
}

with(o_turret_parent){
	//direction switching
	var dir_switch = instance_place(x, y, o_character_dir_switch);
	if dir_switch != noone {
		fire_direction = dir_switch.image_angle;
		
		//update immediately
		var cx = x;
		var cy = y;
		var hspd = lengthdir_x(CELL_W, fire_direction);
		var vspd = lengthdir_y(CELL_H, fire_direction);

	
		var barrier = place_meeting(cx + hspd*CELL_W, cy + vspd*CELL_H, o_barrier);
		var door = place_meeting(cx + hspd*CELL_W, cy + vspd*CELL_H, o_door);
		if !barrier and !door {
			x += hspd;
			y += vspd;
		}
	}
	
	var snake_dir = instance_place(x, y, o_collision_snake_dir_switch);
	if snake_dir != noone {
		fire_direction = snake_dir.switch_dir;
	}
	
	//being over a pit without a support
	if place_meeting(x, y, o_pit) and !place_meeting(x, y, o_player_floor_parent) {
		//make a shrinkning effect
		falling_FX();
		instance_destroy(id);
	}
}

if (pot_hinput != 0 or pot_vinput != 0) and !place_meeting(potx, poty, o_collision_parent_below) and potx >= CELL_W and potx <= room_width-CELL_W and poty >= CELL_H and poty <= room_height-CELL_H {
	//Apples--------------------------------

	var apple = instance_place(potx, poty, o_apple_parent);
	if apple != noone {
		//do specific apple thing here	
		var num = 1;
		add_to_body(num, apple.snake_part_type, apple.image_angle);
		screen_shake(random_range(0.8, 1.2)*pot_hinput, random_range(0.8, 1.2)*pot_vinput, 7);
			//play a random sound
		sound_play_random_pitch([snd_apple_get_1], 0.8, 1.2);
	
		instance_destroy(apple);
	}
	
	update_body(pot_hinput, pot_vinput);
}


//update the acting parts list
var parts_array = array_create(cur_length);
for (var i = 0; i < cur_length; i++){
	parts_array[i] = get_part_id(i);
}

//Death reaction--------------------------------

if moved_once {
	every_piece_is_over_a_hole = true;
	for (var i = 0; i < cur_length; i++ ){
		var part = parts_array[i];
		with(part){
			if !place_meeting(x, y, o_pit) {
				other.every_piece_is_over_a_hole = false;
			}
		}
		if !every_piece_is_over_a_hole break;
	}
} else {
	every_piece_is_over_a_hole = false;
}

if every_piece_is_over_a_hole {
	for (var i = 0; i < cur_length; i++) {
		with (parts_array[i]) {
			falling_FX();
		}
	}
	
	instance_destroy(id);
}

if place_meeting(head_x, head_y, o_death_parent) or cur_length <= 0 or every_piece_is_over_a_hole {
	if !global.vanilla_snake_mode {
		//death reaction
		if o_manager.state == game_state.playing {
			set_game_state_loss(!every_piece_is_over_a_hole);
			repeat(irandom_range(4, 6)){
				var ranx = irandom_range(-10,10);
				var rany = irandom_range(-10,10);
		
				make_death_FX(head_x + ranx, head_y + rany);
			}
		}
	} else {
		// the vanilla mode reaction:
		// remove the pieces and continue from where you came
		vanilla_mode_death_effects(head_x, head_y);
		
		remove_body_from_part_no_making_walls(2);
		last_direction += 180;
		last_direction = last_direction % 360;
		last_input_direction = last_direction;

		update_body(lengthdir_x(1, last_direction), lengthdir_y(1, last_direction));
		
	}
}


//Overlap--------------------------------
//check how many body parts are overlapping
overlap = 1;
overlapx = -1;
overlapy = -1;

for (var i = 0; i < cur_length; i++){
	var current = parts_array[i];
	if current.x == overlapx and current.y == overlapy {
		overlap++;
	}
	overlapx = current.x;
	overlapy = current.y;
}
if overlap == 1 {
	overlapx = -1;
	overlapy = -1;
}


//Interactables happen------------------------
with(o_button){
	var snake_pressing = (place_meeting(x, y, o_player_floor_parent) and layer_get_name(layer) != "Above");
	var snake = noone;
	if snake_pressing {
		snake = instance_place(x, y, o_player_floor_parent);
	}
	var char_pressing = place_meeting(x, y, o_character_parent);
	var char = noone;
	if char_pressing char = instance_place(x, y, o_character_parent);
	
	var turret_pressing = place_meeting(x, y, o_turret_parent);

	pressed = snake_pressing or char_pressing or turret_pressing;
	image_index = pressed;
	image_blend = set_object_index_color(index);
	
	var FX_chance = 25;

	if pressed {
		if !last_pressed {
			//react with visuals effects
			make_temp_effects_ext(x + CELL_W/2, y + CELL_H/2, "Above_FX", [spr_dust_poof1, spr_dust_poof2], [image_blend],
				irandom_range(7, 10), 0, 359, 1, 2, 3);
			
			//react with a sound
			sound_play_random_pitch([snd_button_on_1, snd_button_on_2], 0.9, 1.1);
		}
		if irandom(FX_chance) == 0 {
			make_temp_effects_ext(x + CELL_W/2, y + CELL_H/2, "Mid_FX", [spr_dust_poof1, spr_dust_poof2], [image_blend, c_white],
				irandom_range(1, 3), 0, 359, 0.8, 1.8, 3);		
		}
	}



	with(o_door){
		if index == other.index {
			if !open {
				open = other.pressed;
			}
			//if the button was pressed this frame and, specifically, not last frame
			if other.pressed and !other.last_pressed {
				make_temp_effects_ext(x + CELL_W/2, y + CELL_H/2, "Above_FX", [spr_dust_poof1, spr_dust_poof2], [image_blend],
				irandom_range(7, 10), 0, 359, 1, 2, 3);
			}
		}
	}
}
with(o_button_inverse){
	var snake_pressing = (place_meeting(x, y, o_player_floor_parent) and layer_get_name(layer) != "Above");
	var snake = noone;
	if snake_pressing {
		snake = instance_place(x, y, o_player_floor_parent);
	}
	var char_pressing = place_meeting(x, y, o_character_parent);
	var char = noone;
	if char_pressing char = instance_place(x, y, o_character_parent);

	pressed = snake_pressing or char_pressing;
	image_index = pressed;
	image_blend = set_object_index_color(index);
	
	var FX_chance = 25;

	if pressed {
		if !last_pressed {
			//react with visuals effects
			make_temp_effects_ext(x + CELL_W/2, y + CELL_H/2, "Above_FX", [spr_dust_poof1, spr_dust_poof2], [image_blend],
				irandom_range(7, 10), 0, 359, 1, 2, 3);
			
			//react with a sound
			sound_play_random_pitch([snd_button_on_1, snd_button_on_2], 0.9, 1.1);
		}
		if irandom(FX_chance) == 0 {
			make_temp_effects_ext(x + CELL_W/2, y + CELL_H/2, "Mid_FX", [spr_residue_1, spr_wiggly_2, spr_wiggly_3], [image_blend, c_white, c_black],
				irandom_range(2, 4), 0, 359, 0.8, 1.8, 3);		
		}
	}



	with(o_door_inverse){
		if index == other.index {
			open = !other.pressed;
			//if the button was pressed this frame and, specifically, not last frame
			if other.pressed and !other.last_pressed {
				make_temp_effects_ext(x + CELL_W/2, y + CELL_H/2, "Above_FX", [spr_residue_2, spr_wiggly_1, spr_wiggly_4], [image_blend, c_white, c_black],
				irandom_range(7, 10), 0, 359, 1, 2, 3);
			}
		}
	}
}



//Post-movement character updates--------------------------
//if the player didn't manage to move this turn, then take any bait
with(o_character_parent){
	character_step();
	//Update character's direction to align with new block orientations (this happens with char_step)
}

////move the turrets accordingly
//with(o_turret_parent){
//	//If you're on the snake, progress to the next piece
//	var ride = instance_place(x, y, o_snake_part_parent);
//	if ride != noone {
//		x += lengthdir_x(CELL_W, ride.switch_dir);
//		y += lengthdir_y(CELL_W, ride.switch_dir);
//	}
//}

//redundant - see above?
with(o_turret_parent){
	if place_meeting(x, y, o_pit) and !place_meeting(x, y, o_player_floor_parent) {
		instance_destroy(id);
	}
}

with (o_turret_line_of_sight) {
	turret_line_of_sight_step();
}

with(o_explosive) {
	explosive_step();
}



//Second round of Biting - if doors chomp down on you


///
//Seems stable for now, but if we're doing multiple doors biting in the same frame,
//then just put the variables that ultimately remove parts within each door's check
///

remove = false;
var snake_part = noone;
var found_piece = false;
with(o_door_parent){
	if !found_piece {
		snake_part = instance_place(x, y, o_snake_part_parent);
		if snake_part != noone {
			found_piece = true;
			if snake_part.part == 1 {
				set_game_state_loss(false);
				
				with(other){
					make_death_FX(head_x, head_y);
					make_death_FX(head_x, head_y);
					if cur_length > 1 {
						var neck = get_part_id(2);
						var created = instance_create_layer(neck.x, neck.y, neck.layer, o_collision_basic_below);
						created.image_blend = SNAKE_COLOR;
						remove_body_from_part(2);
					}
				}
				
				instance_destroy(other);	//destroys the snake
			} else {
				//if the part is part of me and not right behind me
				if snake_part.part != -1 and snake_part.x != other.overlapx and snake_part.y != other.overlapy {
					remove = true;
					show_debug_message(snake_part.part);				
				}
			}
		}
	}
}
if remove {
	show_debug_message(snake_part.part);
	remove_body_from_part(snake_part.part);
}