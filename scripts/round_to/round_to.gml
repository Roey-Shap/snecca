// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function round_to(val, unit){
	
	show_debug_message(val);
	val = val - (val % unit);
	return(val);
}