//Update variable
toMouseDir = point_direction(x, y, mouse_x, mouse_y)
toMouseRad = degtorad(toMouseDir)

switch(state){
	case S.IDLE:
		if (mouse_check_button_pressed(mb_left)){
			jumpSpd = DEF_JUMPSPD
			jumpDir = toMouseRad
			
			state = S.JUMP
		}
		
		
		break
	case S.JUMP:
	
		var colTile = layer_tilemap_get_id("colTile")
		
		//move X with collide
		if (place_meeting(x + cos(jumpDir) * jumpSpd, y, colTile)){
			while (!place_meeting(x + cos(jumpDir), y, colTile)){
				x += cos(jumpDir)
			}
		}else{
			x += cos(jumpDir) * jumpSpd
		}
		
		//move Y with collide
		if (place_meeting(x, y - sin(jumpDir) * jumpSpd, colTile)){
			while (!place_meeting(x, y - sin(jumpDir), colTile)){
				y -= sin(jumpDir)
			}
		}else{
			y += -sin(jumpDir) * jumpSpd
		}
		
		
		jumpSpd *= jumpLerp
		
		if (jumpSpd < 1){
			state = S.REC
			alarm[0] = 20
		}
		
		image_xscale = sign(cos(jumpDir))
		
		move_wrap(true,true,sprite_width/2)
		
		break
	case S.REC:
		break;
	
}

show_debug_message(jumpSpd)