/// @description

if current_time % 3 == 0 {
	make_temp_effects_ext(CX, CY, "Mid_FX", [spr_dust_poof1, spr_dust_poof2], [CHEESE_COLOR, c_white],
						irandom_range(2, 3), 0, 359, 0.2, 0.5, 0);
}