shader_type canvas_item;

uniform sampler2D noise_texture : source_color, repeat_enable;
uniform float scroll_speed = .25;

void fragment() {
    vec2 adjusted_uv = UV + vec2(0.0, TIME * scroll_speed);
    vec4 noise_color = texture(noise_texture, adjusted_uv);
    
    vec2 center = vec2(0.5, 0.5);
    vec2 diff = UV - center;
    
    float x_scale = 0.4;  
    float y_scale = 0.7; 
    
    vec2 scaled_diff = vec2(diff.x / x_scale, diff.y / y_scale);
    float dist = length(scaled_diff);
    
    float alpha = 1.0 - smoothstep(0.0, 1.0, dist);
    alpha = noise_color.r * alpha;
	alpha = floor(alpha * 6.0) / 6.0;
	alpha += alpha * pow(UV.y,8);
    COLOR = vec4(1,1,1, alpha);
}