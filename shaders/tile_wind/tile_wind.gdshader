shader_type canvas_item;

uniform float wind_strength = 3.0; 
uniform float offset_strength = 0.5;
uniform float time_scale = 20;

const float TILE_SIZE = 30.0;

uniform vec4 white_color : source_color;
uniform vec4 red_color   : source_color;
uniform vec4 green_color : source_color;
uniform vec4 blue_color  : source_color;
uniform vec4 black_color : source_color;


void vertex() {
	float time = TIME * time_scale;
	vec2 world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	float vx = sin(time + world_pos.x*offset_strength)*wind_strength;
	float vy = sin(time + world_pos.y*offset_strength)*wind_strength;
	
	VERTEX += vec2(vx,vy);
}


//water effect try this later on that
//void vertex() {
	//
	//vec2 world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	//VERTEX += vec2(sin(TIME + world_pos.x*offset_strength)*wind_strength,
	//sin(TIME + world_pos.x*offset_strength)*wind_strength);
//}

float color_match(vec3 a, vec3 b)
{
    return float(all(equal(a, b)));
}


void fragment()
{
    vec4 tex = texture(TEXTURE, UV);

    float is_red   = color_match(tex.rgb, vec3(1.0, 0.0, 0.0));
    float is_green = color_match(tex.rgb, vec3(0.0, 1.0, 0.0));
    float is_blue  = color_match(tex.rgb, vec3(0.0, 0.0, 1.0));
    float is_black = color_match(tex.rgb, vec3(0.0, 0.0, 0.0));
    float is_white = color_match(tex.rgb, vec3(1.0, 1.0, 1.0));

    vec3 result =
        red_color.rgb   * is_red +
        green_color.rgb * is_green +
        blue_color.rgb  * is_blue +
        black_color.rgb * is_black +
        white_color.rgb * is_white +
        tex.rgb * (1.0 - (
            is_red +
            is_green +
            is_blue +
            is_black +
            is_white
        ));

    COLOR = vec4(result, tex.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
