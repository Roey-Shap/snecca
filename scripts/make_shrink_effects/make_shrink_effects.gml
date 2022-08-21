// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function make_shrink_effects(xx, yy, layer_id, sprite, number, color, min_angle, max_angle, min_speed, max_speed, rotation_speed, scale_factor){
	repeat(number){
		var add_x = irandom_range(-5, 5);
		var add_y = irandom_range(-5, 5);
		var ran_spd = random_range(min_speed, max_speed);
		var ran_dir = random_range(min_angle, max_angle);
		
		var fx = instance_create_layer(xx + add_x, yy + add_y, layer_id, o_shrink_FX);
		fx.sprite_index = sprite;
		fx.rotation_speed = rotation_speed;
		fx.image_blend = color;
		fx.image_xscale = image_xscale;
		fx.image_yscale = image_yscale;
		fx.scalefactor = scale_factor;
		fx.image_speed = 0;
		
		fx.hspd = lengthdir_x(ran_spd, ran_dir);
		fx.vspd = lengthdir_y(ran_spd, ran_dir);
	}
}