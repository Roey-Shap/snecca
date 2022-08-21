// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function push_room_state(){
	
	if WEB_BUILD return;
	//if the list is too large, delete the snapshot that's furthest back
	if ds_list_size(room_state_data) == 275 {
		show_debug_message("Full! Deleted furthest-back snapshot of game state.");
		ds_list_delete(room_state_data, 0);
	}
	
	//overall structure is:
//Stack			 TOTAL ROOM DATA
//				I				I
//Lists		Snapshot 1 ... Snapshot n
//			I	I	I		I		I
//Maps	 Obj1, Obj2 ... Objn	......
	
	//make a new LIST for this room state
	//track every item in the room, store all of its information
	//within a corresponding list of its own
	//push that LIST into the overall data_stack 

	var state_list = ds_list_create();
	var index_counter = -1;
	
	with(o_frame_data_store_parent){
		//make an entry for yourself
		var my_data_map = ds_map_create();
		index_counter++;
		
		//Variables------------------------------------------------
		//go through basic object properties
		ds_map_add(my_data_map, "x", x);
		ds_map_add(my_data_map, "y", y);
		ds_map_add(my_data_map, "layer", layer_get_name(layer));
		ds_map_add(my_data_map, "object_index", object_index);
		
		ds_map_add(my_data_map, "sprite_index", sprite_index);
		ds_map_add(my_data_map, "image_index", image_index);
		
		ds_map_add(my_data_map, "image_xscale", image_xscale);
		ds_map_add(my_data_map, "image_yscale", image_yscale);
		ds_map_add(my_data_map, "image_angle", image_angle);
		ds_map_add(my_data_map, "image_blend", image_blend);
		ds_map_add(my_data_map, "image_alpha", image_alpha);
		
		//get variable names
		var var_names = variable_instance_get_names(id);
		var len = array_length(var_names);

		
		//loop through the instance variables and store them in the list
		for (var i = 0; i < len; i++){
			//get the current variable
			var cur_var = variable_instance_get(id, var_names[i]);
			var final_var = cur_var;
			
			 
			
			//if the variable is a list, we'll copy the list and store THAT
			//this is to store the list information accurately, and not just the pointer to a different list
			var mark_as_list = false;
			var mark_as_grid = string_copy(var_names[i], string_length(var_names[i])-4+1, 4) == "grid";
			
			//if !is_undefined(cur_var) and cur_var != noone {
			//if is_int32(cur_var) {
			//	mark_as_list = ds_exists(cur_var, ds_type_list);
			//}
			if mark_as_list {
				
				final_var = ds_list_create();
				ds_list_copy(final_var, cur_var);
				
	//vvvv different function for marking this list as within a map for garbage removal! vvvv 
	
				ds_map_add_list(my_data_map, var_names[i], final_var);
				
			} else if mark_as_grid {
				////necessary here?
				
				final_var = ds_grid_create(ds_grid_width(cur_var), ds_grid_height(cur_var));
				ds_grid_copy(final_var, cur_var);
				
				ds_map_add(my_data_map, var_names[i], final_var);
			} else {
				//if the variable is just a value, we'll store it as such	
				ds_map_add(my_data_map, var_names[i], final_var);
			}
		}
		
		//End of Variable Fetching-------------------------------------------------------------------
		
		//add this individual's list into the total snapshot's state_list
		ds_list_add(state_list, my_data_map);
		ds_list_mark_as_map(state_list, index_counter);
	}
	
	//finally, add this to the overall list
	ds_list_add(room_state_data, state_list);
}