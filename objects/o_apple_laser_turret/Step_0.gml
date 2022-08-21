/// @description

jitter = irandom(FX_chance) == 0;

if jitter {
	var rx = x + lengthdir_x(CELL_W/2, image_angle);
	var ry = y + lengthdir_y(CELL_H/2, image_angle);
	
	make_temp_effects(rx, ry, "Below_FX", [spr_dust_poof1, spr_dust_poof2], 
		irandom_range(1, 2), 0, 359, 0.8, 1.8, 3);		
}