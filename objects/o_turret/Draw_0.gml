/// @description

//draw_set_halign(fa_center);
//draw_set_valign(fa_center);
//draw_set_font(fnt_medium);


var offset = place_meeting(x, y, o_player_floor_parent) ? 8 : 0;
simple_outline(x, y-offset, c_black);
draw_sprite_ext(sprite_index, image_index, x, y-offset, image_xscale, image_yscale, image_angle,
				image_blend, image_alpha);

//draw_text_color(, fire_timer, image_blend, image_blend, image_blend, image_blend, 1);
var dis = CELL_W/8;
var total_distance = dis*(2*fire_timer - 1);
var height = floor(CELL_H/5);
for (var i = 0; i < fire_timer + 1; i++){
	var curx = (x + CELL_W/2) - (total_distance/2) + (dis*(i+1));
	draw_set_color(c_black);
	draw_circle(curx, y - height, 3, false);
	draw_set_color(image_blend);
	draw_circle(curx, y - height, 3, true);
}
