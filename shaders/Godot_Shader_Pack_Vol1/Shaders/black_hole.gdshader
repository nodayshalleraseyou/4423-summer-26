shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float pixel_size = 3.0;
uniform float distortion_strength = 0.15;
uniform float vignette_intensity = 0.6;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);

    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;

    // Distorsión gravitacional desde el centro
    vec2 delta = pixelated_uv - 0.5;
    float dist = length(delta);
    float gravity = distortion_strength / (dist * dist + 0.1);
    vec2 distorted_uv = pixelated_uv - normalize(delta) * gravity * 0.02;

    vec3 color = texture(SCREEN_TEXTURE, distorted_uv).rgb;

    // Viñeta oscura en los bordes
    vec2 vig_uv = uv * (1.0 - uv.yx);
    float vignette = vig_uv.x * vig_uv.y * 15.0;
    vignette = pow(vignette, vignette_intensity);
    color *= vignette;

    COLOR = vec4(color, 1.0);
}