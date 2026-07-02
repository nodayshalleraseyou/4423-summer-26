shader_type canvas_item;

uniform vec4 white_color : source_color;
uniform vec4 red_color   : source_color;
uniform vec4 green_color : source_color;
uniform vec4 blue_color  : source_color;
uniform vec4 black_color : source_color;


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