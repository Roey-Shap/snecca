/// @description Camera variables

camwidth =	SCREEN_W;
camheight =	SCREEN_H;
varCamera = camera_create();

view_enabled = true;
view_visible[0] = true;
view_camera[0] = varCamera;
camera_set_view_size(0, camwidth, camheight);

var factor = 2;
view_set_wport(0, camwidth*factor);
view_set_hport(0, camheight*factor);


var rx = round(x);
var ry = round(y);
var vm = matrix_build_lookat(rx, ry, -100, rx, ry, 0, 0, 1, 0);
var pm_norm = matrix_build_projection_ortho(camwidth, camheight, 1.0, 32000.0);
//pm_vert = matrix_build_projection_ortho(512, 1024, 1, 10000);

//pm_active = pm_norm;

camera_set_view_mat(varCamera, vm);
camera_set_proj_mat(varCamera, pm_norm);



//window_set_fullscreen(true);

follow = o_camera_anchor;
if instance_exists(follow){
	x = round(follow.x);
	y = round(follow.y);

}



xTo = x;
yTo = y;

x = round(x);
y = round(y);

current_room = room;

//SHAKE (juicy) (it's 2:22 AM)
shake_counter = 0;
shake_frequency = 0;
shake_x = 0;
shake_y = 0;

fade_timer = 25;
room_id = -1;
fade = 0; //0 = fade in, 1 = fade out

up_follow = false;