// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function save_data_to_file(){
	
	if CAN_SCRIBBLE {
		var file_name = "snecca_sava_data.ini";
	
		ini_open(file_name);
		
		ini_write_real("Data", "Master Levels", audio_get_master_gain(0));
		ini_write_real("Data", "SFX Levels", global.audio_FX_level);
		ini_write_real("Data", "Music Levels", global.audio_music_level);
		ini_write_real("Data", "Current Max Level", global.max_unlocked_level);
		ini_write_real("Data", "Grid Toggle", global.show_grid);
		ini_write_real("Data", "Step Time", global.buffer_amount);
		ini_write_real("Data", "Fullscreen", global.fullscreen);
		ini_write_real("Data", "Color Mode", global.color_palette_index);
	
		ini_close();
	
		show_debug_message("SAVED DATA AT TIMESTEP " + string(current_time));
	} else {
		show_debug_message("SAVED DATA AT TIMESTEP " + string(current_time) + " BUT WAS ON WEB");		
	}
}