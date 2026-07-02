shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float pixel_size = 3.0;
uniform float grain_intensity = 0.15;
uniform float brightness = 1.8;
uniform float vignette_intensity = 0.5;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    
    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    vec3 color = texture(SCREEN_TEXTURE, pixelated_uv).rgb;
    
    // Escala de grises y brillo
    float gray = dot(color, vec3(0.299, 0.587, 0.114)) * brightness;
    
    // Tono verde militar
    vec3 nv_color = vec3(gray * 0.2, gray, gray * 0.2);
    
    // Grano
    float grain = fract(sin(dot(pixelated_uv + TIME * 0.1, vec2(127.1, 311.7))) * 43758.5453);
    nv_color += (grain - 0.5) * grain_intensity;
    
    // Viñeta
    vec2 vig_uv = uv * (1.0 - uv.yx);
    float vignette = pow(vig_uv.x * vig_uv.y * 15.0, vignette_intensity);
    nv_color *= vignette;
    
    COLOR = vec4(nv_color, 1.0);
}