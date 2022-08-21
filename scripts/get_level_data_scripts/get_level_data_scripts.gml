// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function get_level_room_from_index(index){
	var level_array = levels[index];
	return(level_array[0]);
}

function get_level_name_from_index(index){
	var level_array = levels[index];
	return(level_array[1]);
}

function get_level_progression_from_index(index){
	var level_array = levels[index];
	return(level_array[2]);
}

function get_level_music_from_index(index){
	var level_array = levels[index];
	return(level_array[3]);
}

function get_level_color_from_index(index){
	var level_array = levels[index];
	return(level_array[4]);
}