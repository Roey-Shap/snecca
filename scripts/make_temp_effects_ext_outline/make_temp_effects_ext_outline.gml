// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function make_temp_effects_ext_outline(xx, yy, layer_id, sprites, colors, outline_col, number, min_angle, max_angle, min_speed, max_speed, rotation_speed){
	//if WEB_BUILD return;
	repeat(number){
		var add_x = irandom_range(-3, 3);
		var add_y = irandom_range(-3, 3);
		var ran_spd = random_range(min_speed, max_speed);
		var ran_dir = random_range(min_angle, max_angle);
		
		var fx = instance_create_layer(xx + add_x, yy + add_y, layer_id, o_temp_FX);
		fx.sprite_index = sprites[irandom(array_length(sprites)-1)];
		fx.image_xscale = random_range(0.9, 1.1);
		fx.image_yscale = random_range(0.9, 1.1);
		fx.rotation_speed = random(rotation_speed);
		fx.image_blend = global_color(colors[irandom(array_length(colors)-1)]);

		fx.outline_col = fx.image_blend == c_white ? c_black : outline_col; //white-on-white prevention
		if fx.image_blend = c_black fx.outline_col = c_white; //black on black prevention
		
		fx.hspd = lengthdir_x(ran_spd, ran_dir);
		fx.vspd = lengthdir_y(ran_spd, ran_dir);
	}
}