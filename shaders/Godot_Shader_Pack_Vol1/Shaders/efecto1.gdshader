shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float pixel_size = 4.0;
uniform float scanline_intensity = 0.2;
uniform float aberration_amount = 0.005;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    
    vec2 offset = vec2(aberration_amount, 0.0);
    vec4 left = texture(SCREEN_TEXTURE, pixelated_uv - offset);
    vec4 center = texture(SCREEN_TEXTURE, pixelated_uv);
    vec4 right = texture(SCREEN_TEXTURE, pixelated_uv + offset);
    
    // Verde lima a la izquierda, rosa a la derecha
    vec3 color = center.rgb;
    color += vec3(-left.r * 0.5, left.g * 0.8, -left.b * 0.5);  // Verde lima
    color += vec3(right.r * 0.8, -right.g * 0.5, right.b * 0.5); // Rosa
    
    float scanline = mod(floor(uv.y * screen_size.y), 2.0);
    color *= 1.0 - scanline * scanline_intensity;
    
    COLOR = vec4(color, 1.0);
}