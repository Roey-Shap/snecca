// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function global_color(index){
	if index == c_white or index == c_black return(index);
	return(global.color_palette[index + 1]);
}