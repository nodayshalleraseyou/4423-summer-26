shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float pixel_size = 4.0;
uniform float edge_threshold = 0.3;
uniform vec4 edge_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float aberration_amount = 0.005;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    vec2 px = vec2(1.0 / screen_size.x, 1.0 / screen_size.y) * pixel_size;
    
    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    
    // Aberración cromática rosa/verde
    vec2 offset = vec2(aberration_amount, 0.0);
    vec4 left = texture(SCREEN_TEXTURE, pixelated_uv - offset);
    vec4 center = texture(SCREEN_TEXTURE, pixelated_uv);
    vec4 right = texture(SCREEN_TEXTURE, pixelated_uv + offset);
    
    vec3 color = center.rgb;
    color += vec3(-left.r * 0.5, left.g * 0.8, -left.b * 0.5);
    color += vec3(right.r * 0.8, -right.g * 0.5, right.b * 0.5);
    
    // Detección de bordes
    float top    = length(texture(SCREEN_TEXTURE, pixelated_uv + vec2(0, -px.y)).rgb);
    float bottom = length(texture(SCREEN_TEXTURE, pixelated_uv + vec2(0,  px.y)).rgb);
    float left_s = length(texture(SCREEN_TEXTURE, pixelated_uv + vec2(-px.x, 0)).rgb);
    float right_s = length(texture(SCREEN_TEXTURE, pixelated_uv + vec2(px.x, 0)).rgb);
    float c = length(center.rgb);
    
    float edge = abs(top - c) + abs(bottom - c) + abs(left_s - c) + abs(right_s - c);
    
    if (edge > edge_threshold) {
        color = edge_color.rgb;
    }
    
    COLOR = vec4(color, 1.0);
}