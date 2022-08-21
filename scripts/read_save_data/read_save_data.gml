// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function read_save_data(){

	var data = array_create(10);
	var web_or_no_file = false;

	if CAN_SCRIBBLE {
		var file_name = "snecca_sava_data.ini";
		if file_exists(file_name){
			ini_open(file_name);
		
			data[0] = ini_read_real("Data", "Master Levels", 1);
			data[1] = ini_read_real("Data", "SFX Levels", 1);
			data[2] = ini_read_real("Data", "Music Levels", 1);
			data[3] = ini_read_real("Data", "Current Max Level", 1);
			data[4] = ini_read_real("Data", "Grid Toggle", true);
			data[5] = ini_read_real("Data", "Step Time", 8);
			data[6] = ini_read_real("Data", "Color Mode Index", 0);
			data[7] = ini_read_real("Data", "Fullscreen", true);
		
			ini_close();
		} else {
			//for new saves (I know it's built in to the functions above... it feels less clean that way
			web_or_no_file = true;
		}
	
		show_debug_message("=====================\nREAD SAVE DATA AT TIMESTEP " + string(current_time) + "\n===================");
	} else {
		web_or_no_file = true;
	}
	
	if web_or_no_file {
		data[0] = 1;
		data[1] = 1;
		data[2] = 1;
		data[3] = 1;
		data[4] = false;	
		data[5] = 8;
		data[6] = 0;
		data[7] = true;		
	}
	
	return(data);
}