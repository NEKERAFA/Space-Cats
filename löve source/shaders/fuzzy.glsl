// More and more colours

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec4 pixel = Texel(texture, texture_coords);
	vec4 shader = Texel(texture, texture_coords);
	number pos = screen_coords.x/love_ScreenSize.x;
	
	if(pos < 0.2) {
		shader.r = 1.0;
		shader.g = 5.0*pos;
		shader.b = 0.0;
	} else if(pos < 0.4) {
		shader.r = -5.0*pos+2.0;
		shader.g = 1.0;
		shader.b = 0.0;
	} else if(pos < 0.6) {
		shader.r = 0;
		shader.g = 1.0;
		shader.b = 5.0*pos-2.0;
	} else if(pos < 0.8) {
		shader.r = 0;
		shader.g = -5.0*pos+4;
		shader.b = 1.0;
	} else {
		shader.r = 5.0*pos-4;
		shader.g = 0;
		shader.b = 1.0;
	}

	return (pixel+shader)/2.0;
}