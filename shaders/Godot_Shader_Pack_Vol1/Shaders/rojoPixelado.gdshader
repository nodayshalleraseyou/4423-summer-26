shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float pixel_size = 4.0;
uniform float edge_threshold = 0.3;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    vec2 px = vec2(1.0 / screen_size.x, 1.0 / screen_size.y) * pixel_size;

    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    vec4 color = texture(SCREEN_TEXTURE, pixelated_uv);

    // Detección de bordes (Sobel)
    float top    = length(texture(SCREEN_TEXTURE, pixelated_uv + vec2(0, -px.y)).rgb);
    float bottom = length(texture(SCREEN_TEXTURE, pixelated_uv + vec2(0,  px.y)).rgb);
    float left   = length(texture(SCREEN_TEXTURE, pixelated_uv + vec2(-px.x, 0)).rgb);
    float right  = length(texture(SCREEN_TEXTURE, pixelated_uv + vec2( px.x, 0)).rgb);
    float center = length(color.rgb);

    float edge = abs(top - center) + abs(bottom - center) + abs(left - center) + abs(right - center);

    // Convertir a escala de grises y tintar de rojo
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 red_tint = vec3(gray, 0.0, 0.0);

    // Bordes en negro
    if (edge > edge_threshold) {
        red_tint = vec3(0.0);
    }

    COLOR = vec4(red_tint, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
