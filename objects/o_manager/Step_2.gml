/// @description


switch(state){
	
	case game_state.playing:	

		intro_timer -= 1 * (intro_timer > 0);
		if intro_timer <= 0 {
			
			with(obj_cutscene_textbox_scribble){
				if CAN_SCRIBBLE {
					textbox_element.typewriter_unpause(true);
				} else {
					text_spd = text_spd_init;
				}
			}
			global.start_paused = false;
		}

		var snake_win = true;
		with(o_snake){
			if !place_meeting(head_x, head_y, o_snake_goal){
				snake_win = false;
			}
		}

		var char_win = true;
		with(o_character){
			if !place_meeting(x, y, o_character_goal){
				char_win = false;
			}
		}
		
		var bad_char = instance_exists(o_bad_character);

		if char_win and snake_win and !bad_char {
			state = game_state.win; 
			
			var arr = [spr_wiggly_1, spr_wiggly_2, spr_wiggly_4, spr_wiggly_5, spr_residue_1, spr_residue_2];
			with(o_character_goal){
				make_temp_effects_ext(x + CELL_W/2, y + CELL_W/2, "Above_FX",
								arr, [CHAR_COLOR, c_white], irandom_range(6, 10), 0, 359, 1.25, 2.5, 3);
				screen_shake(random_range(2, 3), random_range(2, 3), 15);
			}
			with(o_snake_goal){
				make_temp_effects_ext(x + CELL_W/2, y + CELL_W/2, "Above_FX",
								arr, [SNAKE_COLOR, c_white], irandom_range(6, 10), 0, 359, 1.25, 2.5, 3);
				screen_shake(random_range(2, 3), random_range(2, 3), 15);
			}
			
			sound_play_random_pitch([snd_win], 0.975, 1.025);
			
		}
		
		#region Debug keys
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		if CAN_DEBUG {
			if keyboard_check_pressed(vk_enter) state = game_state.win;
			if keyboard_check_pressed(ord("1")) {
			
				level_index = array_length(levels)-1;
				room_goto(get_level_room_from_index(level_index));
			}
			if keyboard_check_pressed(ord("T")){
				room_goto(rm_test);
			}
		}
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		#endregion
		
	break;
	
	case game_state.win:
		
	
	break;
	
	case game_state.lost:
	
	break;
	
	case game_state.paused:
		
		
		
	break;

}
if CAN_DEBUG {
	if keyboard_check_pressed(ord("M")) audio_set_master_gain(0, 1-audio_get_master_gain(0));
	if keyboard_check_pressed(vk_tab) {
		global.debug = !global.debug;
		show_debug_overlay(global.debug);
	}
}