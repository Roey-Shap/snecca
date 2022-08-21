/// @description

image_alpha = global.debug;

// make apples randomly
if !instance_exists(o_apple_basic) {
	var ranx = x + (CELL_W * irandom(image_xscale-1));
	var rany = y + (CELL_H * irandom(image_yscale-1));
	var apple = instance_create_layer(ranx, rany, "Above_FX", o_apple_basic);
}