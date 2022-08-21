// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function character_step() {
	var hspd = lengthdir_x(walk_spd, walk_dir) * global.step;
	var vspd = lengthdir_y(walk_spd, walk_dir) * global.step;

	//if !started {
	//	hspd = 0;
	//	vspd = 0;
	//}

	//if !place_meeting(x, y, o_player_floor_parent){
	//	effect_create_above(ef_flare, x, y, choose(1, 2), choose(c_orange, c_red));
	//	hspd = 0;
	//	vspd = 0;
	//}

	//update to turn towards cheese
	if place_meeting(x + CELL_W, y, o_cheese) walk_dir = 0;
	if place_meeting(x - CELL_W, y, o_cheese) walk_dir = 180;
	if place_meeting(x, y - CELL_H, o_cheese) walk_dir = 90;
	if place_meeting(x, y + CELL_H, o_cheese) walk_dir = 270;

	//Use the empty floor as walls

	var cx = x;
	var cy = y;
	var barrier = place_meeting(cx + hspd*CELL_W, cy + vspd*CELL_H, o_barrier);
	var door = place_meeting(cx + hspd*CELL_W, cy + vspd*CELL_H, o_door);
	var cheese = place_meeting(cx + hspd*CELL_W, cy + vspd*CELL_H, o_cheese);
	//if there's cheese in front of you, take the bait
	if (place_meeting(cx + hspd*CELL_W, cy + vspd*CELL_H, collision_type) or cheese) and !barrier and !door {
		x += CELL_W*hspd;
		y += CELL_H*vspd;
	}
	
	var dir_switch = instance_place(x, y, o_character_dir_switch);
	if dir_switch != noone {
		walk_dir = dir_switch.image_angle;
		
		//update immediately
		var cx = x;
		var cy = y;
		var hspd = lengthdir_x(walk_spd, walk_dir);
		var vspd = lengthdir_y(walk_spd, walk_dir);

	
		barrier = place_meeting(cx + hspd*CELL_W, cy + vspd*CELL_H, o_barrier);
		door = place_meeting(cx + hspd*CELL_W, cy + vspd*CELL_H, o_door);
		if !barrier and !door {
			x += CELL_W*hspd;
			y += CELL_H*vspd;
		}
	}

	//update to turn towards cheese
	if place_meeting(x + CELL_W, y, o_cheese) walk_dir = 0;
	if place_meeting(x - CELL_W, y, o_cheese) walk_dir = 180;
	if place_meeting(x, y - CELL_H, o_cheese) walk_dir = 90;
	if place_meeting(x, y + CELL_H, o_cheese) walk_dir = 270;
	
	

	if place_meeting(x, y, o_death_parent) or !place_meeting(x, y, collision_type) or hp = 0 {
		//death reaction
		set_game_state_loss();
		make_death_FX(x, y);
		instance_destroy(id);
	}
	
	if place_meeting(x, y, o_pit) and !place_meeting(x, y, collision_type) {
		xscale = lerp(xscale, 0, 0.1);
		yscale = lerp(yscale, 0, 0.1);
	} else {
		xscale = 1;
		yscale = 1;
	}
}


function cheese_step(){
	if global.step {
		if move_spd != 0 {
		
			var hspd = CELL_W*lengthdir_x(move_spd, move_direction);
			var vspd = CELL_H*lengthdir_y(move_spd, move_direction);
		
			if (place_meeting(x+hspd, y+vspd, o_player_floor_parent) and layer_get_name(layer) != "Above") or place_meeting(x+hspd, y+vspd, o_barrier){
				move_spd = 0;
			}
		
			x += hspd*move_spd;
			y += vspd*move_spd;
			
			if place_meeting(x, y, o_death_parent) {
				make_temp_effects_ext(x + CELL_W/2, y + CELL_H/2, "Below_FX", [spr_residue_1, spr_residue_2, spr_dust_poof1, spr_dust_poof2],
					[CHEESE_COLOR, CHEESE_COLOR, c_white], irandom_range(2, 3), 0, 359,	0.6, 1, choose(0, 1, 2));
				instance_destroy(id);
			}
		}
	}
}

function explosive_step(){
	if global.step {
		var explode = false;
		var hspd = CELL_W*lengthdir_x(move_spd, move_direction);
		var vspd = CELL_H*lengthdir_y(move_spd, move_direction);
		
		if (place_meeting(x+hspd, y+vspd, o_player_floor_parent) and layer_get_name(layer) != "Above") or (place_meeting(x+hspd, y+vspd, o_barrier) and !place_meeting(x+hspd, y+vspd, o_character_parent)){
			move_spd = 0;
			explode = true;
		}
		
		
		if move_spd != 0 {
		
			x += hspd*move_spd;
			y += vspd*move_spd;
			
			if place_meeting(x, y, o_death_parent) {
				//make_temp_effects_ext(x + CELL_W/2, y + CELL_H/2, "Below_FX", [spr_residue_1, spr_residue_2, spr_dust_poof1, spr_dust_poof2],
				//	[CHEESE_COLOR, CHEESE_COLOR, c_white], irandom_range(7, 9), 0, 359,	0.4, 2, choose(0, 1, 2));
				explode = true;
			}
		}	
		
		if !place_meeting(x, y, o_player_floor_parent) layer = layer_get_id("Mid_FX");

		
		//if you've been signaled to explode... explode
		if explode {
			commit_explode();
		}
	}
}

function commit_explode() {
	var offset_list = [
		0, 0,
		1, 0,
		-1, 0,
		0, 1,
		0, -1,
	];

//I'm making this total list in case I want to do something with all of them at a specific moment in the frame
	var final_list = ds_list_create();			
	var width = 2;
	//loop through each adjacent tile and see what needs to be blown up
	for (var i = 0; i < 5*width; i += width){
		var curx = x + CELL_W*offset_list[i];
		var cury = y + CELL_H*offset_list[i+(width-1)];
			
		var instance_list = ds_list_create();
		var instances = instance_place_list(curx, cury, all, instance_list, false);
		for (var j = 0; j < instances; j++){
			var inst = instance_list[| j];
			//This is the bomb, so for time-step simplicity we'll make no chain reactions possible
			if variable_instance_exists(inst, "destructible") and inst.object_index != o_explosive {
				if inst.destructible ds_list_add(final_list, instance_list[| j]);
			}
		}
			
		ds_list_destroy(instance_list);
		make_temp_effects_ext(curx + CELL_W/2, cury + CELL_H/2, "Above_FX", [spr_residue_1, spr_residue_2, spr_dust_poof1, spr_dust_poof2],
			[CHEESE_COLOR, c_white, c_white], irandom_range(2, 3), 0, 359, 0.3, 0.5, choose(0, 1, 2));
	}
			
	var final_instances = ds_list_size(final_list);
	for (var i = 0; i < final_instances; i++){
		with (final_list[| i]) {
			if variable_instance_exists(id, "hp") {
				hp -= 1;
			} else if object_get_parent(object_index) == o_snake_part_parent {
				var p = part;
				with(snake_parent){
					remove_body_from_part(p);
				}
			} else {
				instance_destroy(id);
			}
			explosion_hit_FX();
			sound_play_random_pitch([snd_explosion], 0.9, 1.3);
		}
	}
	ds_list_destroy(final_list);
			
	instance_destroy(id);
}

function turret_step(){
	if global.step           {
		if fire_timer > 0 {
			fire_timer -= 1;
		} else {
			var cx = x + CELL_W/2;
			var cy = y + CELL_H/2;
			var dis = horizontal_range;

			if collision_rectangle(cx + lengthdir_x(dis, fire_direction + 90), 
							cy + lengthdir_y(dis, fire_direction + 90), 
							cx + lengthdir_x(room_width, fire_direction) - lengthdir_x(dis, fire_direction + 90), 
							cy + lengthdir_y(room_height, fire_direction) - lengthdir_y(dis, fire_direction + 90), 
							o_character, false, true) or regular_turret {
				fire_timer = fire_rate;
				sound_play_random_pitch([snd_cannon], 0.8, 1.1);
			
				//var angle_offset_x = dcos(fire_angle); if angle_offset_x == 0 angle_offset_x = 1;
				//var angle_offset_y = dsin(fire_angle); if angle_offset_y == 0 angle_offset_y = 1;
				var angle_offset_x = 0;
				var angle_offset_y = 0;
				var proj = instance_create_layer(x + angle_offset_x*CELL_W, y + angle_offset_y*CELL_H,
													layer, o_explosive);
				proj.move_direction = fire_direction;
				proj.move_spd = 1;
				//effects?
			}
			
		}
	}
	
	if fire_timer == 0 {
		image_blend = global_color(HURT_COLOR);
	} else {
		if fire_timer == 1 {
			image_blend = global_color(CHAR_COLOR);
		} else {
			image_blend = init_blend;
		}
	}
	
}

function turret_line_of_sight_step(){
	
	
	if global.step {
		if fire_timer > 0 {
			fire_timer -= 1;
			//on the next update, if it was firing last frame, stop
			firing = false;
		} else {
			
			var dis = CELL_W/2;
			
			//var in_sight = collision_rectangle(CX + lengthdir_x(dis, fire_direction + 90), 
			//				CY + lengthdir_y(dis, fire_direction + 90), 
			//				CX + lengthdir_x(room_width, fire_direction) - lengthdir_x(dis, fire_direction + 90), 
			//				CY + lengthdir_y(room_height, fire_direction) - lengthdir_y(dis, fire_direction + 90), 
			//				o_character, false, true) != noone;
							
			if alarmed {//and in_sight {
				alarmed = false;
				
				var variance = 40;
				make_temp_effects_ext(CX, CY, "Above_FX", 
										[spr_residue_1, spr_residue_2, spr_dust_poof1, spr_dust_poof2],
										[HURT_COLOR, CHEESE_COLOR, c_white], irandom_range(9, 11), fire_direction+180-variance, fire_direction+180+variance, 0.6, 1.3, irandom(5));
			
				var shake = random_range(1, 2);
				screen_shake(lengthdir_x(shake, fire_direction+180), lengthdir_y(shake, fire_direction+180), irandom_range(10, 15));
		
				var dis = horizontal_range;

			
				fire_timer = fire_rate;
				sound_play_random_pitch([snd_laser], 0.8, 1.1);
			
				firing = true;
					
				//if you hit anything, destroy
				
				var end_x = CX + lengthdir_x(room_width, fire_direction);
				var end_y = CY + lengthdir_y(room_width, fire_direction);
			
				var instance_list = ds_list_create();
				var instances = collision_line_list(CX, CY, end_x, end_y, all, false, false, instance_list, true);
				
				var final_list = ds_list_create();
				
				//we'll get the square upon which all of the closest objects are standing
				for (var j = 0; j < instances; j++){
					var inst = instance_list[| j];
					if !(place_meeting(x, y, inst) and layer_get_name(layer) == "Above") {
						with (inst) {
							//variable safety check
							if variable_instance_exists(id, "destructible") {
								//if they should even be affected
								if destructible {
									ds_list_add(final_list, id);
								}
							}
						}
					}
				}
				
				var destroy_x = 0;
				var destroy_y = 0;
				//update how many instances we're interested in
				instances = ds_list_size(final_list);
				
				if instances > 0 {
					destroy_x = final_list[| 0].x;
					destroy_y = final_list[| 0].y;
					
					//round to snap to nearest cell regardless of this instance's origin
					destroy_x = (destroy_x) - (destroy_x % CELL_W);
					destroy_y = (destroy_y) - (destroy_y % CELL_H);
				}
				
				//loop through the objects and find any that are standing on the "nearest hit" cell
				for (var i = 0; i < instances; i++){
					var inst = final_list[| i];
					if collision_rectangle(destroy_x, destroy_y, destroy_x+CELL_W-1, destroy_y+CELL_H-1, inst, false, true) {
						//destroy it
						with (inst) {
							explosion_hit_FX();
							
							//if variable_instance_exists(id, "move_spd") move_spd = 0;
							if variable_instance_exists(id, "hp") {
								hp -= 1;
							} else if variable_instance_exists(id, "explosion_radius"){
								commit_explode();
							} else if object_get_parent(object_index) == o_snake_part_parent {
								var p = part;
								with(snake_parent){
									remove_body_from_part(p);
								}
							} else {
								instance_destroy(id);
							}
						}
					} else {
						//they're in order, so we're already past the point where all the action should occur
						break;
					}
				}
				
				
				ds_list_destroy(instance_list);
				ds_list_destroy(final_list);					
				//extra visual effects?
			}
		}
		
		//to avoid being alerted and firing on the same frame, do updates after attempting to fire
		var dis = horizontal_range;
		if collision_rectangle(CX + lengthdir_x(dis, fire_direction + 90), 
								CY + lengthdir_y(dis, fire_direction + 90), 
								CX + lengthdir_x(room_width, fire_direction) - lengthdir_x(dis, fire_direction + 90), 
								CY + lengthdir_y(room_height, fire_direction) - lengthdir_y(dis, fire_direction + 90), 
								o_character_parent, false, true) != noone {
			//if you've found a character in your line of sight, be alarmed
			alarmed = true;
								
								
		} else {
			alarmed = false;
		}
	}
	
	if fire_timer == 0 {
		image_blend = HURT_COLOR;
	} else {
		if fire_timer == 1 {
			image_blend = CHAR_COLOR;
		} else {
			image_blend = init_blend;
		}
	}
	
}