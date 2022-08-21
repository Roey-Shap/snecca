// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function screen_shake(sx, sy, time){
	with(camera){
		shake_counter = irandom_range(time, time*5/4);
		shake_x = sx;
		shake_y = sy;
	}
}