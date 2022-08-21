/// @description

//draw_set_lighting(true);
//draw_light_define_point(1, head_x, head_y, 1, 2000, c_red);
//draw_light_enable(1, true);

var parts = array_create(cur_length);
for (var i = 0; i < cur_length; i++){
	parts[i] = get_part_id(i);
}

if !every_piece_is_over_a_hole {

	//Connections
	for (var i = 0; i < cur_length-1; i++) {
		var cur = parts[i]
		var next = parts[i+1];
		var cx = cur.x + CELL_W/2;
		var cy = cur.y + CELL_H/2;
		var nx = next.x + CELL_W/2;
		var ny = next.y + CELL_H/2;
		draw_line_width_color(cx, cy, nx, ny, 5, c_black, c_black);
		draw_line_width_color(cx, cy, nx, ny, 3, c_white, c_white);
	}

	if moved_once {
		for (var i = 0; i < cur_length; i++) {
			var cur = parts[i];
			with(cur){
				simple_outline(x, y, c_black);
				event_perform(ev_draw, 0);
			}
		}
	}


		
	if overlap > 1 {
	
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		draw_set_color(c_black);
		draw_set_font(fnt_small);
	
		//draw_text(fx, fy, overlap);
		draw_sprite_ext(spr_snake_body_dir, parts[cur_length-1].dir, overlapx, overlapy, 1, 1, 0, 
						merge_color(c_white, global_color(SNAKE_COLOR), 0.8), 1);
	
		draw_set_color(c_white);
		draw_set_halign(fa_left);
	
		//draw_circle_color(fx-1, fy-2, 8, c_white, c_black, true);
	}

	//Draw head
	var img_index = last_direction/90;

	var outl_col = global.color_palette_index == 0 ? c_black : c_white;

	draw_sprite_ext(spr_snake_body, img_index, head_x+1, head_y, image_xscale, image_yscale,
				0, outl_col, image_alpha);
	draw_sprite_ext(spr_snake_body, img_index, head_x-1, head_y, image_xscale, image_yscale,
				0, outl_col, image_alpha);
	draw_sprite_ext(spr_snake_body, img_index, head_x, head_y+1, image_xscale, image_yscale,
				0, outl_col, image_alpha);
	draw_sprite_ext(spr_snake_body, img_index, head_x, head_y-1, image_xscale, image_yscale,
				0, outl_col, image_alpha);


	draw_sprite_ext(spr_snake_body, img_index, head_x, head_y, image_xscale, image_yscale,
				0, global_color(SNAKE_COLOR), image_alpha);
}
			
if global.debug {
	var str = [last_hinput, last_vinput];
	draw_text_color(1+head_x+CELL_W/2, 1+head_y-CELL_H, str, c_black, c_black, c_black, c_black, 1);
	draw_text_color(head_x+CELL_W/2, head_y-CELL_H, str, c_white, c_white, c_white, c_white, 1);
	
//	effect_create_above(ef_ring, x, y, 20, c_green);
}
//Draw body
//for (var i = 0; i < cur_length; i++) {
//	var partx = body_parts[# 0, i];
//	var party = body_parts[# 1, i];
//	draw_sprite_ext(spr_snake_body, image_index, partx, party, image_xscale, image_yscale,
//			0, image_blend, image_alpha);
//}
