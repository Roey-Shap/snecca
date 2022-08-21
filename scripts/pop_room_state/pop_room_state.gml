// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pop_room_state(){
	if WEB_BUILD return;
	if ds_exists(room_state_data, ds_type_list){
		if !ds_list_empty(room_state_data){
			show_debug_message("Did undo");
			pop_room_state_helper();
			global.undo = true;
			return(true);
		}
	}
	return(false);
}

function pop_room_state_helper(){
	
	
	//performs a single undo
		//get the last recorded frame
		//load and create each instance
		//destroy the popped list
	
	
	
	//get the last recorded frame
	var last_index = ds_list_size(room_state_data) - 1;
	var last_frame_list = room_state_data[| last_index];
	ds_list_delete(room_state_data, last_index);
	var instances = ds_list_size(last_frame_list);
	
	//destroy everything onscreen that is a recorded child (if it wasn't recorded, it won't be recreated, and we really don't care about it)

	instance_destroy(o_frame_data_store_parent);	
	//iterate through the instances of the frame we're restoring and spawn them each in
	for (var i = 0; i < instances; i++) {
		
		//get the map representing the current instance
		var inst_map = last_frame_list[| i];
		
		//load basic variables
		var _x					= ds_map_find_value(inst_map, "x");
		var _y					= ds_map_find_value(inst_map, "y");
		var _layer				= ds_map_find_value(inst_map, "layer");
		var _object_index		= ds_map_find_value(inst_map, "object_index");
								  
		//var _sprite_index		= ds_map_find_value(inst_map, "sprite_index");
		//var _image_index		= ds_map_find_value(inst_map, "image_index");
								  
		//var _image_xscale		= ds_map_find_value(inst_map, "image_xscale");
		//var _image_yscale		= ds_map_find_value(inst_map, "image_yscale");
		//var _image_angle		= ds_map_find_value(inst_map, "image_angle");
		//var _image_blend		= ds_map_find_value(inst_map, "image_blend");
		//var _image_alpha		= ds_map_find_value(inst_map, "image_alpha");

		//create object
		var inst				= instance_create_layer(_x, _y, _layer, _object_index);
	//	show_message([_x, _y, object_get_name(_object_index)]);
		
		//remove these variables
		ds_map_delete(inst_map, "x");
		ds_map_delete(inst_map, "y");
		ds_map_delete(inst_map, "layer");
		ds_map_delete(inst_map, "object_index");
		
		//now we're just left with the other variables, and can apply them in a loop
		var keys_array = ds_map_keys_to_array(inst_map);
		var vals_array = ds_map_values_to_array(inst_map);
		var variables = array_length(keys_array);
		
		for (var k = 0; k < variables; k++) {
			variable_instance_set(inst, keys_array[k], vals_array[k]);
		}
		
		
		ds_map_destroy(inst_map);
		
		
	}
	
	//destroy the list used
	ds_list_destroy(last_frame_list);
}