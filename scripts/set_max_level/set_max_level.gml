// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function set_max_level(level){
	
	show_debug_message("Won level: " + string([global.max_unlocked_level, level]));
	//if your unlocked level is before the one you just got to, add to your level
	if global.max_unlocked_level <= level {
		global.max_unlocked_level += get_level_progression_from_index(level-1);
	}
//	global.max_unlocked_level = max(global.max_unlocked_level, level);
}