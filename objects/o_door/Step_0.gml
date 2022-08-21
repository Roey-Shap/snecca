/// @description

if open {
	x = -init_x;
	y = -init_y;
	
	var FX_chance = 40;
	if irandom(FX_chance) == 0 {
		make_temp_effects_ext(init_x + CELL_W/2, init_y + CELL_H/2, "Mid_FX", [spr_dust_poof1, spr_dust_poof2], [image_blend, c_white],
			irandom_range(1, 3), 0, 359, 0.8, 1.8, 3);		
	}
} else {
	x = init_x;
	y = init_y;
}

image_index = open;
image_blend = set_object_index_color(index);