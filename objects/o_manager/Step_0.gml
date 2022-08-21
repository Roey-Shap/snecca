/// @description

switch(state){
	
	case game_state.playing:	
		
	break;
	
	case game_state.win:
			
		if keyboard_check_pressed(vk_anykey) and transition_timer <= 0 {
			if level_index < level_num-1 {
				level_index++;
				//update level select screen option index
	
				var cur_level_ind = level_select_x + (level_select_y*gridw);
				cur_level_ind++;
				level_select_x = cur_level_ind % gridw;
				level_select_y = floor(cur_level_ind / gridw);
			
				//update current level based on the one you just beat
				set_max_level(level_index);
		
				save_data_to_file();
		
				//fade out previous music
				var tracks = array_length(music_list);
				for (var m = 0; m < tracks; m++){
					var cur = music_list[m];
					if audio_is_playing(cur){
						if audio_sound_get_gain(cur) <= 0.05 {
							audio_stop_sound(cur);
						} else {	
							audio_sound_gain(cur, 0, 500); //milliseconds to fade in/out
						}
					}
				}
			
			
				room_goto(get_level_room_from_index(level_index));
		
				just_transitioned = true;
				global.start_paused = true;
				state = game_state.playing;
			} else {
				state = game_state.level_select;
				back_out();
			}
		}
		
	
	break;
	
	case game_state.lost:
	
	break;
	
	case game_state.paused:
		
		
		
	break;
	
	case game_state.level_select:
	break;
	
	case game_state.main_menu:

	break;

}

if transition_timer > 0 transition_timer -= 1;


if keyboard_check_pressed(restart_key) and state != game_state.win room_restart();


