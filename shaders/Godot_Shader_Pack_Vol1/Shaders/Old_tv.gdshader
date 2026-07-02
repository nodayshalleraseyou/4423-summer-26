shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float pixel_size = 3;
uniform float noise_intensity = 0.08;
uniform float scanline_intensity = 0.3;
uniform float aberration_amount = 0.003;
uniform float vignette_intensity = 0.4;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    
    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    
    // Aberración cromática
    vec2 offset = vec2(aberration_amount, 0.0);
    float r = texture(SCREEN_TEXTURE, pixelated_uv + offset).r;
    float g = texture(SCREEN_TEXTURE, pixelated_uv).g;
    float b = texture(SCREEN_TEXTURE, pixelated_uv - offset).b;
    vec3 color = vec3(r, g, b);
    
    // Ruido de señal
    float noise = fract(sin(dot(pixelated_uv + TIME * 0.1, vec2(127.1, 311.7))) * 43758.5453);
    color += (noise - 0.5) * noise_intensity;
    
    // Scanlines
    float scanline = mod(floor(uv.y * screen_size.y), 2.0);
    color *= 1.0 - scanline * scanline_intensity;
    
    // Viñeta
    vec2 vig_uv = uv * (1.0 - uv.yx);
    float vignette = vig_uv.x * vig_uv.y * 15.0;
    vignette = pow(vignette, vignette_intensity);
    color *= vignette;
    
    // Tono cálido amarillento de TV vieja
    color.r *= 1.1;
    color.g *= 1.05;
    color.b *= 0.85;
    
    COLOR = vec4(color, 1.0);
}