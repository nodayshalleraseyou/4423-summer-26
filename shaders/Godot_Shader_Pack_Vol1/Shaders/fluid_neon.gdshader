shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float speed = 0.5;
uniform float opacity = 0.5;
uniform float pixel_size = 4.0;
uniform vec3 color1 = vec3(1.0, 0.0, 1.0);
uniform vec3 color2 = vec3(0.0, 1.0, 1.0);

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);

    // Pixelado de la escena
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    vec3 scene = texture(SCREEN_TEXTURE, pixelated_uv).rgb;

    // Fluido neon
	vec2 fuv = floor((uv * 2.0 - 1.0) * screen_size / pixel_size) * pixel_size / screen_size * 2.0 - 1.0;
    float t = TIME * speed;
    for (int i = 0; i < 5; i++) {
        fuv.x += 0.3 / float(i + 1) * sin(float(i) * fuv.y + t + float(i) * 1.5);
        fuv.y += 0.3 / float(i + 1) * cos(float(i) * fuv.x + t + float(i) * 0.5);
    }

    float pattern = sin(fuv.x + fuv.y) * 0.5 + 0.5;
    vec3 fluid = mix(color1, color2, pattern);

    // Mezcla
    vec3 final_color = mix(scene, fluid, opacity);

    COLOR = vec4(final_color, opacity);
}