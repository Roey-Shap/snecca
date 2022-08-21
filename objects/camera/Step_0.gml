/// @description Player tracking


if fade_timer > 0 {
	fade_timer -= 1;
} else {
	if fade == 1 {
		if fade_timer != -1 { // to ensure that it doesn't activate from the default "locked" state
			if room_id != -1 { //incase it's just default "room+1" for some reason
				room = room_id;
			} else {
	//			room += 1;
			}
		}
	}
}

if instance_exists(follow){
	xTo = floor(follow.x);
	yTo = floor(follow.y);
	if variable_instance_exists(follow, "target") {
		if instance_exists(follow.target) {
			//follow = follow.target;
			var tar = follow.target;
			xTo = floor(tar.head_x);
			yTo = floor(tar.head_y);
		}
	}
} else {
	xTo = room_width/2;
	yTo = room_height/2;
}


x += floor((xTo - x)/10);
y += floor((yTo - y)/10);

x = clamp(floor(x), camwidth/2, room_width-camwidth/2);
y = clamp(floor(y), camheight/2, room_height-camheight/2);


if shake_counter > 0 or shake_counter == -1 {
	if shake_counter != -1 {
		shake_counter -= 1;
	}
	x += shake_x*choose(-1, 1);
	y += shake_y*choose(-1, 1);
	shake_x *= 0.998;
	shake_y *= 0.998;
} else {
	if abs(x-xTo) <= 1 x = xTo;
	if abs(y-yTo) <= 1 y = yTo;
}

x = floor(x);
y = floor(y);

var vm = matrix_build_lookat(x, y, -100, x, y, 0, 0, 2, 0);
var pm_norm = matrix_build_projection_ortho(camwidth, camheight, 1.0, 32000.0);
camera_set_view_mat(varCamera, vm);
camera_set_proj_mat(varCamera, pm_norm);
