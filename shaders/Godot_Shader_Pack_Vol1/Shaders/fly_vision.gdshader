shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float hex_size = 0.06;
uniform float border = 0.05;

vec2 hex_grid(vec2 uv, float size) {
    vec2 r = vec2(1.0, 1.732) * size;
    vec2 h = r * 0.5;
    vec2 a = mod(uv, r) - h;
    vec2 b = mod(uv - h, r) - h;
    return dot(a, a) < dot(b, b) ? a : b;
}

void fragment() {
    vec2 uv = SCREEN_UV;
    
    vec2 local = hex_grid(uv, hex_size);
    float dist = length(local);
    
    vec2 center_uv = uv - local;
    vec3 color = texture(SCREEN_TEXTURE, center_uv).rgb;
    
    if (dist > hex_size * (1.0 - border)) {
        color = vec3(0.0);
    }
    
    COLOR = vec4(color, 1.0);
}