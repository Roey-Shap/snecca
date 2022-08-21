/// @description

global.step = room == rm_level_select;		// if on the level select menu, it'll begin as true
											// most of the time, it'll start false each frame
if global.step_input > 0 {
	global.step_input -= 1;
}

global.undo = false;

var last_state = state;

var confirmed = keyboard_check_pressed(vk_space) or keyboard_check_pressed(vk_enter);
if confirmed and state != game_state.playing sound_play_random_pitch([snd_menu_click_1], 0.8, 1.15);


var hinput = clamp(keyboard_check_pressed(ord("D")) - keyboard_check_pressed(ord("A"))
		+ keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left), -1, 1);
var vinput = clamp(keyboard_check_pressed(ord("W")) - keyboard_check_pressed(ord("S"))
		+ keyboard_check_pressed(vk_up) - keyboard_check_pressed(vk_down), -1, 1) * !editing_audio * !editing_buffer_time;


if hinput != 0 or vinput != 0 {
	last_hinput = hinput;
	last_vinput = vinput;
}


if state == game_state.options or state == game_state.paused or state == game_state.level_select or state == game_state.main_menu {
	if hinput != 0 or vinput != 0 {
		sound_play_random_pitch([snd_menu_click_1], 0.75, 1.1);	
	}
}
	

switch(state) {
	case game_state.playing:
		if keyboard_check_pressed(vk_escape){
			
			state = game_state.paused;
			option_index = 0;
			editing_audio = false;
			editing_buffer_time = false;
			var cam = camera;
			
			if !surface_exists(surf){
				surf = surface_create(display_get_gui_width(), display_get_gui_height());
				surface_copy(surf, 0, 0, application_surface);
			}
			
			x = cam.x;
			y = cam.y;
			camwidth = cam.camwidth;
			camheight = cam.camheight;
			
			sound_play_random_pitch([snd_pause], 0.9, 1.1);
			
			instance_deactivate_all(true);
			
			music_level = 1/3; //fade it out
			
			break;
		}
		
		var buttons = array_length(step_progress_buttons);
	
	
		// if in VANILLA snake mode, override inputs with automatic onces
		
		if global.vanilla_snake_mode {
			if global.step_input <= 0 or hinput != 0 or vinput != 0 {
				global.step = true; 
				global.step_input = global.snake_mode_step_time;	//global.buffer_amount;
			}
		} else {
			// if in SNECCA mode, read inputs normally
			
			// Forward step
			for (var i = 0; i < buttons; i++) {
				//allow them to hold
				if global.step_input <= 0 {
					if keyboard_check(step_progress_buttons[i]) {
						global.step = true;
						global.step_input = global.buffer_amount;
					}
				}
			
				// pressing button as opposed to holding
				if keyboard_check_pressed(step_progress_buttons[i]) {
					global.step = true;
					global.step_input = global.buffer_amount * 1.2;
				}		
			}
		
			// Undo
			//allow them to hold
			if global.step_input <= 0 and !global.step {
				if global.step_input <= 0 {
					if (keyboard_check(vk_lshift) or keyboard_check(vk_rshift)) {
						global.step_input = global.buffer_amount;
						do_undo();
					}
				}
				if (keyboard_check_pressed(vk_lshift) or keyboard_check_pressed(vk_rshift)) {
					global.step_input = global.buffer_amount;
					do_undo();
				}
			}
		}
	break;
	
	case game_state.win:
		global.step = false;
	break;
	
	case game_state.lost:
		
		if transition_timer <= 0 {
			if keyboard_check_pressed(ord("R")) or keyboard_check_pressed(global.button_text) {
				room_restart();
				with (o_snake) {
					if ds_exists(body_parts_grid, ds_type_grid) {
						ds_grid_destroy(body_parts_grid);
					}
				}
				global.start_paused = false;
				state = game_state.playing;
				music_level = 1;
				break;
			}
			
			if !global.vanilla_snake_mode {
				if (keyboard_check_pressed(vk_lshift) or keyboard_check_pressed(vk_rshift)) and global.step_input <= 0 {
					global.step_input = global.buffer_amount;
					state = game_state.playing;
					music_level = 1;
					do_undo();
					break;
				}
			}
		}
	break;
	
	case game_state.paused:
		option_index = (option_index - vinput) % paused_options.LAST;
		if option_index < 0 option_index = paused_options.LAST-1;
		
		button_jump_timer = hinput != 0 or vinput != 0 ? button_jump_time : button_jump_timer-1;
		
		//Breaking out early if needed
		if keyboard_check_pressed(vk_escape){
			sound_play_random_pitch([snd_pause], 1, 1.3);
			state = game_state.playing;
			if surface_exists(surf) surface_free(surf);	
			instance_activate_all();
			
			break;
		}
		
		if confirmed {
			switch(option_index){
				case paused_options.resume:
				
					sound_play_random_pitch([snd_pause], 1, 1.3);
					state = game_state.playing;
					music_level = 1;
					if surface_exists(surf) surface_free(surf);	
					instance_activate_all();
					
				break;
				
				case paused_options.level_select:
				
					state = game_state.level_select;
					back_out();
					
				break;
				
				case paused_options.options:
					
					state = game_state.options;
					return_state = game_state.paused;
					option_index = 0;
					
				break;
				
				case paused_options.exit_game:
					
					game_end();
					
				break;
				
			}
		}
	break;
	
	
	
	case game_state.level_select:
	
		
		if keyboard_check_pressed(vk_escape) {
			state = game_state.main_menu;
			option_index = 0;
			break;
		}
		
		var odd_row = level_select_y % 2 == 1;
		//if you move over the width of the grid, move back mod the width
		var prev_level_x = level_select_x;
		var prev_level_y = level_select_y;
		
		level_select_x = (level_select_x + hinput*(odd_row? -1 : 1));// % gridw;
		level_select_y = (level_select_y - vinput);// % gridh;
		button_jump_timer = hinput != 0 or vinput != 0 ? button_jump_time : button_jump_timer-1;
		
		if vinput != 0 level_select_x = gridw - (level_select_x + 1);
		
		var max_level = CAN_DEBUG and global.debug ? level_num : global.max_unlocked_level;
		var last_level_x = (max_level-1) % gridw;				//(level_num-1) % gridw;
		var last_level_y = floor((max_level-1) / gridw);		//floor((level_num-1) / gridw);
		var adj_last_level_y = floor((odd_row? 0 : (max_level-1)) / gridw);		//floor((level_num-1) / gridw);

		// changing to the snaking method:
		// if you're trying to move somewhere not accessible yet, no snapping or anything happens
		// instead, you can't move there
		
		var actual_level_number = ((level_select_y)*gridw) + (level_select_x);
		if actual_level_number >= max_level or actual_level_number < 0 or level_select_y < 0 or level_select_x > gridw-1 or level_select_x < 0 or level_select_y > gridh-1{
			level_select_x = prev_level_x;
			level_select_y = prev_level_y;
		}

		/*
		// if out of bounds to left:
		//	-> if you're the furthest down you can go, overflow to the furthest point of your latest level
		//	-> otherwise, snap to the grid's edge (your furthest accessible level is further down somewhere)
		if level_select_x < 0 {
			if level_select_y == last_level_y {
				level_select_x = last_level_x;
			} else {
				level_select_x = gridw-1;
			}
		}
		// if out of bounds to the top:
		//	-> snap to the bottom-most y-value you have access to
		if level_select_y < 0 level_select_y = last_level_y;	
		
		
		if level_select_x > last_level_x and level_select_y == last_level_y {
			if hinput == 1 {
				level_select_x = 0;
			} else {
				level_select_x = last_level_x;				
			}
		}
		
		if level_select_y > last_level_y level_select_y = 0;
		
		
		if level_select_y < 0 level_select_y = last_level_y;
		
		if level_select_x > last_level_x and level_select_y == last_level_y {
			if hinput == 1 {
				level_select_x = 0;
			} else {
				level_select_x = last_level_x;				
			}
		}
		*/
		
		if confirmed {
			state = game_state.playing;
			level_index = level_select_x + (level_select_y*gridw);
			just_transitioned = true;
			global.start_paused = true;
			
			var tracks = array_length(music_list);
			for (var m = 0; m < tracks; m++){
				var cur = music_list[m];
				if audio_is_playing(cur){
					audio_stop_sound(cur);
				}
			}
			room_goto(get_level_room_from_index(level_index));
		}
		
		
	break; 
	
	
	
	case game_state.main_menu:
		
		//Audio handling
		if last_state != game_state.main_menu and last_state != game_state.level_select {
			audio_stop_all();
		}
		
		if !audio_is_playing(snd_BG_main_menu){
			var BG = audio_play_sound(snd_BG_main_menu, 3, true);
			audio_sound_gain(BG, global.audio_music_level, 300);
		} else {
			audio_sound_gain(snd_BG_main_menu, global.audio_music_level, 300);
		}
		
		//Option handling
		option_index = (option_index - vinput) % main_menu_options.LAST;
		if option_index < 0 option_index = main_menu_options.LAST - 1;
	
		button_jump_timer = vinput != 0 ? button_jump_time : button_jump_timer-1;
		
		if confirmed {
			switch(option_index){
				case main_menu_options.level_select:
				
					state = game_state.level_select;
					
				break;
				
				case main_menu_options.options:
				
					state = game_state.options;
					return_state = game_state.main_menu;
					option_index = 0;
					
				break;
				
				case main_menu_options.credits:
					state = game_state.credits;
				break;
				
				case main_menu_options.exit_game:
					
					game_end();
					
				break;
				
			}
		}
		
		
	break;
	
	
	
	case game_state.options:
		option_index = (option_index - vinput) % options.LAST;
		if option_index < 0 option_index = options.LAST-1;
		
		button_jump_timer = hinput != 0 or vinput != 0 ? button_jump_time : button_jump_timer-1;
		
		//Break early if needed to return to previous screen
		if keyboard_check_pressed(vk_escape){
			save_data_to_file();
			state = return_state;
			option_index = return_state == game_state.paused ? paused_options.options : main_menu_options.options;
			break;
		}
		
		
		
		//Option handling itself
		
		switch(option_index) {
			
			case options.back:
				if confirmed {
					save_data_to_file();
					state = return_state;
					option_index = return_state == game_state.paused ? paused_options.options : main_menu_options.options;
				}
			break;
			
			case options.master_sound:
				if hinput != 0 {
					audio_set_master_gain(0, clamp(audio_get_master_gain(0) + (0.1*sign(hinput)), 0, 1));
				}
			break;
			
			case options.FX_sound:
				global.audio_FX_level = clamp(global.audio_FX_level + (0.1*sign(hinput)), 0, 1);			
			break;
			
			case options.music_sound:
				global.audio_music_level = clamp(global.audio_music_level + (0.1*sign(hinput)), 0, 1);
			break;
			
			case options.buffer_time:
				global.buffer_amount = clamp(global.buffer_amount + hinput, 4, 20);
			break;
			
			case options.grid_toggle:
				if confirmed {
					global.show_grid = !global.show_grid;
				}
			break;
			
			case options.color_mode:
				global.color_palette_index = clamp(global.color_palette_index + hinput, 0, array_length(global.color_palettes)-1);
				global.color_palette = global.color_palettes[global.color_palette_index];
				
				if hinput != 0 {
					
					if CAN_SCRIBBLE {
						global.__scribble_colours[? "c_snake" ] = global_color(SNAKE_COLOR);
						global.__scribble_colours[? "c_character" ] = global_color(CHAR_COLOR);
						global.__scribble_colours[? "c_cheese" ] = global_color(CHEESE_COLOR);
						global.__scribble_colours[? "c_hurt" ] = global_color(HURT_COLOR);
					
						//update the colors used in the textbox as well
						instance_activate_object(obj_cutscene_textbox_scribble);
						with (obj_cutscene_textbox_scribble){
												
							//get_typewriter_state, set after?
						
							var box = instance_create_layer(x, y, layer, object_index);
							box.textbox_conversation = array_create(1);
							box.textbox_conversation[0] = textbox_conversation[0];
							box.text_wrap_x = textSectionW + 1;	//keeps it unique

							with(box){
								show_debug_message("Updated text in room " + room_get_name(room));
								create_scribble_text(textbox_conversation[0]);
							}
						
							textbox_conversation = -1;
						}
					
						with (obj_cutscene_textbox_scribble) {
							if textbox_conversation == -1 {
								instance_destroy(id);
							}
						}
	
						instance_deactivate_object(obj_cutscene_textbox_scribble);
					} else {
						global.colors = [
							["c", c_white],
							["c_aqua", c_aqua],
							["c_black", c_black],
							["c_blue", c_blue],
							["c_dkgray", c_dkgray],
							["c_dkgrey", c_dkgrey],
							["c_fuchsia", c_fuchsia],
							["c_gray", c_gray],
							["c_green", c_green],
							["c_grey", c_grey],
							["c_lime", c_lime],
							["c_ltgray", c_ltgray],
							["c_ltgrey", c_ltgrey],
							["c_maroon", c_maroon],
							["c_navy", c_navy],
							["c_olive", c_olive],
							["c_orange", c_orange],
							["c_purple", c_purple],
							["c_red", c_red],
							["c_silver", c_silver],
							["c_teal", c_teal],
							["c_white", c_white],
							["c_yellow", c_yellow],
							["c_snake", global_color(SNAKE_COLOR)],
							["c_character", global_color(CHAR_COLOR)],
							["c_cheese", global_color(CHEESE_COLOR)],		
							["c_hurt", global_color(HURT_COLOR)],		
						]
					
						//update the colors used in the textbox as well
						instance_activate_object(obj_cutscene_textbox_scribble);
						with (obj_cutscene_textbox_scribble){
							parsed_text_array = parse_scribble_text(textbox_conversation[textbox_conversation_index]);
						}
	
						instance_deactivate_object(obj_cutscene_textbox_scribble);
						
					}
	
					
	
					if room == rm_level_select {
						var lay_id = layer_get_id("Backgrounds_1");
						var BG_id = layer_background_get_id(lay_id);
						if layer_exists(lay_id) layer_background_blend(BG_id, merge_color(global_color(SNAKE_COLOR), c_black, 0.1));
					}
				}
			break;
			
			case options.fullscreen:
				if confirmed {
					global.fullscreen = !global.fullscreen;
					window_set_fullscreen(global.fullscreen);
				}
			break;
			
		}

	break;
	
	case game_state.credits:
		
		if keyboard_check_pressed(vk_escape){
			state = game_state.main_menu;
		}
		
	break;
}

//END OF STATE MANAGEMENT=======================================================================

//More Music management
if state == game_state.main_menu or state == game_state.level_select {
	if last_state != game_state.main_menu and last_state != game_state.level_select {
		audio_stop_all();
	}
		
	if !audio_is_playing(snd_BG_main_menu){
		var BG = audio_play_sound(snd_BG_main_menu, 3, true);
		audio_sound_gain(BG, global.audio_music_level, 300);
	}
}

set_music_level(music_level);


//saving current room state
if global.step and !global.undo and !global.vanilla_snake_mode and room != rm_level_select and state != game_state.options and room != rm_init {
	push_room_state();
}


//Auxiliary functions-===============================================

function do_undo(){
	if !global.undo {
		global.undo = true;
		var success = pop_room_state();
		if success {
			regenerate_parts_from_undo();
		}
		return(success);
	}
}

function regenerate_parts_from_undo(){
	with(o_snake_part_parent){
		if snake_parent != noone {
			instance_destroy(id);
		}
	}
	
	//the player's parts have just been reset (including the head)
	//regenerate them
	with(o_snake){
		var head = make_head(body_parts_grid[# 0, 0], body_parts_grid[# 1, 0]);
		var prev_len = cur_length;
		cur_length = 1;
		for (var i = 1; i < prev_len; i++){
			var last_part = head;
	 
			var lastx = body_parts_grid[# 0, i];
			var lasty = body_parts_grid[# 1, i];

			var apple_type = body_parts_grid[# 4, i];
			var angle = body_parts_grid[# 2, i];
			var final_angle = body_parts_grid[# 3, i];
			
			var new_part = instance_create_layer(lastx, lasty, layer, apple_type);
			cur_length++;
		
			new_part.part = cur_length;
			new_part.dir = angle;
			new_part.switch_dir = final_angle;
			new_part.snake_parent = id;		

		}
	}
}

function back_out() { //resets variables (and some data only necessary while playing)
	just_transitioned = true;
	option_index = 0;
	audio_edit_option = 1;
	if surface_exists(surf) surface_free(surf);	
	room_goto(rm_level_select);
	
	//Refresh the undo list
	if ds_exists(room_state_data, ds_type_list) {
	
		//loop through the stack, destroying every frame's state_data_list
		while (!ds_list_empty(room_state_data)) {
			//get the top-most one
			var cur_list = room_state_data[| 0];
			ds_list_destroy(cur_list);
			ds_list_delete(room_state_data, 0);
		}
	
		ds_list_destroy(room_state_data);
		//effect_create_above(ef_ring, 0, 0, 20, c_red);
	}			
}
