// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function make_death_FX(xx, yy){
	make_temp_effects_ext_outline(xx + CELL_W/2, yy + CELL_H/2, "Above_FX",
		[spr_dust_poof1, spr_dust_poof2, spr_residue_1, spr_residue_2],
		[c_black], c_white, irandom_range(6, 8), 0, 359, 0.8, 1.5, 
		2);
}

function explosion_hit_FX(){
	make_temp_effects_ext(CX, CY, "Above_FX", [spr_residue_1, spr_residue_2, spr_dust_poof1, spr_dust_poof2],
			[HURT_COLOR, HURT_COLOR, HURT_COLOR, CHEESE_COLOR], irandom_range(15, 20), 0, 359, 0.5, 1.6, irandom(4));
}

function falling_FX(){
	//make a shrinkning effect
			image_xscale = 0.8;
			image_yscale = 0.8;
			make_shrink_effects(CX, CY, "Above_FX", sprite_index, 1, c_white, 0, 0, 0, 0, irandom(2), 0.95);
	//make_temp_effects(CX, CY, "Above_FX", [spr_residue_1, spr_residue_2, spr_dust_poof1, spr_dust_poof2, spr_wiggly_3],
	//		irandom_range(7, 8), 0, 359, 0.3, 0.4, irandom(4));
}