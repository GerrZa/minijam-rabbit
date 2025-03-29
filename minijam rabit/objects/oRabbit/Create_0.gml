toMouseDir = point_direction(x, y, mouse_x, mouse_y)
toMouseRad = degtorad(toMouseDir)
#macro DEF_JUMPSPD 10


jumpDir = 0
jumpSpd = 0


jumpLerp = 0.8


enum S{
	IDLE, // first start
	JUMP, // jump
	REC // recovery from jump
}

state = S.IDLE