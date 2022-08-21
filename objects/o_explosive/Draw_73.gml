/// @description

var offset_list = [
	0, 0,
	1, 0,
	-1, 0,
	0, 1,
	0, -1,
];


var width = 2;
//loop through each adjacent tile and see what needs to be blown up
draw_set_color(global_color(HURT_COLOR));
draw_set_alpha(0.8*(sin(current_time/400) + 1)/2);
for (var i = 0; i < 5*width; i += width){
	var curx = x + CELL_W*offset_list[i];
	var cury = y + CELL_H*offset_list[i+(width-1)];
	
	draw_rectangle(1 + curx, 1 + cury, curx + CELL_W, cury + CELL_H, true);
}

draw_set_color(c_white);
draw_set_alpha(1);