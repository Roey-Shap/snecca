/// @description

x += hspd;
y += vspd;

image_angle += rotation_speed;

if image_index + 1 >= image_number {
	instance_destroy(id);
}