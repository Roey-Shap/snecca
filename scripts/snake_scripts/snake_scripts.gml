// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function make_head(xx, yy){
	//Make first part
	var head = instance_create_layer(xx, yy, layer, o_collision_snake_part);
		
	head.part = 1;
	head.dir = last_direction;
	head.switch_dir = last_direction;
	head.snake_parent = id;		

	body_parts_grid[# 0, 0] = head.x;
	body_parts_grid[# 1, 0] = head.y;
	body_parts_grid[# 2, 0] = head.dir;
	body_parts_grid[# 3, 0] = head.switch_dir;
	body_parts_grid[# 4, 0] = head.object_index;
	return(head);
}

function get_part_id(index){
	var this_snake = id;
	with(o_snake_part_parent){
		if part == index + 1 and snake_parent == this_snake {
			return(id);
		}
	}
	return(noone);
}

function update_body(hinput, vinput){
	
	var parts = array_create(cur_length);
	for (var i = 0; i < cur_length; i++){
		parts[i] = get_part_id(i);
	}
	
	var prevx = parts[0].x;
	var prevy = parts[0].y;
	var prevdir = parts[0].dir; 
	var input_dir = point_direction(0, 0, hinput, vinput);

	//Move head
	var first_part = parts[0];
	first_part.x += round(CELL_W*hinput);
	first_part.y += round(CELL_H*vinput);
	first_part.dir = point_direction(0, 0, hinput, vinput);//last_direction
		
	body_parts_grid[# 0, 0] = first_part.x;
	body_parts_grid[# 1, 0] = first_part.y;
	body_parts_grid[# 2, 0] = first_part.dir;
		
	head_x = first_part.x;
	head_y = first_part.y;
	
	var last = parts[cur_length-1];
	var lx = last.x + CELL_W/2;
	var ly = last.y + CELL_H/2;
	var variance = 20;
	make_temp_effects(lx, ly, "Below_FX", [spr_residue_1, spr_residue_2, spr_dust_poof1, spr_dust_poof2],
					irandom_range(2, 3), input_dir+180+variance, input_dir+180-variance,
					0.4, 1, choose(0, 1));
	
	//Move everything but the head
	for (var i = cur_length-1; i > 1; i--){
		var cur_part = parts[i];
		var next_part = parts[i-1];
			
		cur_part.x = next_part.x;
		cur_part.y = next_part.y;
		cur_part.dir = next_part.dir;
			
		body_parts_grid[# 0, i] = cur_part.x;
		body_parts_grid[# 1, i] = cur_part.y;
		body_parts_grid[# 2, i] = cur_part.dir;
	}
	
	

	
	if cur_length > 1 {
		var p1 = parts[1];
		p1.x = prevx;
		p1.y = prevy;
		p1.dir = input_dir;
		
		body_parts_grid[# 0, 1] = p1.x;
		body_parts_grid[# 1, 1] = p1.y;
		body_parts_grid[# 2, 1] = p1.dir;		
	}
	
	//play a random sound
	sound_play_random_pitch(step_sounds, 0.8, 1.2);
	
}

function add_to_body(num, apple_type, angle){
	
	var last_part = get_part_id(cur_length-1);
	
	var lastx = last_part.x;
	var lasty = last_part.y;
	var lastdir = last_part.dir; //if it's just you, make it your dir

	//Add that many pieces to the end
	for (var i = 0; i < num; i++){
		var new_part = instance_create_layer(lastx, lasty, layer, apple_type);
		cur_length++;
		
		new_part.part = cur_length;
		new_part.dir = lastdir;
		new_part.switch_dir = angle;
		new_part.snake_parent = id;		

		ds_grid_resize(body_parts_grid, ds_grid_width(body_parts_grid), cur_length);

		body_parts_grid[# 0, cur_length-1] = new_part.x;
		body_parts_grid[# 1, cur_length-1] = new_part.y;
		body_parts_grid[# 2, cur_length-1] = new_part.dir;
		body_parts_grid[# 3, cur_length-1] = new_part.switch_dir;
		body_parts_grid[# 4, cur_length-1] = apple_type;

	}
	
	var last = get_part_id(cur_length-1);
	var lx = last.x + CELL_W/2;
	var ly = last.y + CELL_H/2;
	
	make_temp_effects_ext(lx, ly, "Above_FX", [spr_residue_1, spr_residue_2, spr_dust_poof1, spr_dust_poof2],
					[SNAKE_COLOR], irandom_range(4, 5), 0, 359, 0.6, 1.5, choose(0, 2));
}

function remove_body_from_part(part){
	if cur_length > 0 {
		
		var parts_to_remove = cur_length - part + 1;
		
		//Remove the contacted piece
		var piece = get_part_id(part - 1);
		var xx = piece.x + CELL_W/2;
		var yy = piece.y + CELL_H/2;
	
		make_temp_effects(xx, yy, "Mid_FX", [spr_dust_poof1, spr_dust_poof2], irandom_range(5, 8), 0, 359, 0.7, 1.1, 1);
		
		piece.part = -1;
		instance_destroy(piece);
	
		//Make everything after the severed piece independent...
		for (var i = 0; i < parts_to_remove - 1; i++){
			var cur = get_part_id(part + i);
			cur.part = -1;
			cur.snake_parent = noone;
			switch (cur.object_index){
				default:
					var created = instance_create_layer(cur.x, cur.y, cur.layer, o_collision_basic_below);
					created.image_blend = SNAKE_COLOR;
					instance_destroy(cur);
				break;
				
				case o_collision_snake_part:
					var created = instance_create_layer(cur.x, cur.y, cur.layer, o_collision_basic_below);
					created.image_blend = SNAKE_COLOR;
					instance_destroy(cur);
				break;
				
				case o_collision_snake_dir_switch:
					//do nothing - just leave it there with it proper direction
				break;
				
				case o_collision_snake_destroy:
					var created = instance_create_layer(cur.x, cur.y, cur.layer, o_collision_destroy_below);
					instance_destroy(cur);					
				break;
			}
		}
		//... and remove them all from the list
		cur_length -= parts_to_remove;
		ds_grid_resize(body_parts_grid, ds_grid_width(body_parts_grid), cur_length);
	
		var spd = random_range(1.5, 2.75);
		var dir = last_direction;
		screen_shake(lengthdir_x(spd, dir), lengthdir_y(spd, dir), 18);
		
		sound_play_random_pitch([snd_eat_2, snd_eat_3], 0.9, 1.15);
	}
	
	//update all of the blocks to change their colors??? why was this here
	//with (o_player_floor_parent) {
	//	event_perform(ev_other, ev_room_start);
	//}
}

function remove_body_from_part_no_making_walls(part){
	if cur_length > 0 {
		
		var parts_to_remove = cur_length - part + 1;
		
		//Remove the contacted piece
		var piece = get_part_id(part - 1);
		if instance_exists(piece) {
			var xx = piece.x + CELL_W/2;
			var yy = piece.y + CELL_H/2;
	
			make_temp_effects(xx, yy, "Mid_FX", [spr_dust_poof1, spr_dust_poof2], irandom_range(5, 8), 0, 359, 0.7, 1.1, 1);
		
			piece.part = -1;
			instance_destroy(piece);
		}
	
		//Make everything after the severed piece independent...
		for (var i = 0; i < parts_to_remove - 1; i++){
			var cur = get_part_id(part + i);
			cur.part = -1;
			cur.snake_parent = noone;
			instance_destroy(cur);
		}
		//... and remove them all from the list
		cur_length -= parts_to_remove;
		ds_grid_resize(body_parts_grid, ds_grid_width(body_parts_grid), cur_length);
	}
}


function vanilla_mode_death_effects(_x, _y) {
	screen_shake(random_range(2, 3.5), random_range(2, 3.5), 20);
	sound_play_random_pitch([snd_loss], 0.925, 1.075);
				
	make_temp_effects_ext(_x, _y, "Mid_FX", [spr_dust_poof1, spr_dust_poof2, spr_wiggly_3], [c_white, c_black, HURT_COLOR], irandom_range(8, 12), 0, 359, 1, 3, -2);			
}




