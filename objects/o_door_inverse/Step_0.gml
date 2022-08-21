/// @description

if open {
	x = -100;
	y = -100;
	
} else {
	x = init_x;
	y = init_y;
	
	var FX_chance = 40;
	if irandom(FX_chance) == 0 {
		make_temp_effects_ext_outline(init_x + CELL_W/2, init_y + CELL_H/2, "Mid_FX", [spr_dust_poof1, spr_dust_poof2, spr_residue_1], 
			[c_black], c_white, irandom_range(2, 4), 0, 359, 0.7, 1.6, 3);		
	}
}

image_index = open;
image_blend = set_object_index_color(index);