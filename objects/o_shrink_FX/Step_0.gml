/// @description

x += hspd;
y += vspd;

image_angle += rotation_speed;

image_xscale *= scalefactor;
image_yscale *= scalefactor;

var minscale = 0.005;
if image_xscale <= minscale and image_yscale <= minscale {
	instance_destroy(id);
}