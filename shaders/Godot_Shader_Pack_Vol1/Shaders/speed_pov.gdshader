shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float pixel_size = 4.0;
uniform float speed = 0.3;
uniform float blend = 0.4;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);

    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    vec3 scene = texture(SCREEN_TEXTURE, pixelated_uv).rgb;

    // Gradiente animado tipo Balatro
    vec3 color1 = vec3(0.8, 0.0, 0.8); // magenta
    vec3 color2 = vec3(0.0, 0.0, 1.0); // azul
    vec3 color3 = vec3(1.0, 0.3, 0.0); // naranja

    float t1 = sin(uv.x * 2.0 + TIME * speed) * 0.5 + 0.5;
    float t2 = sin(uv.y * 3.0 + TIME * speed * 0.7 + 1.5) * 0.5 + 0.5;

    vec3 gradient = mix(mix(color1, color2, t1), color3, t2);

    // Mezclar con la escena
    vec3 final = mix(scene, gradient, blend);

    COLOR = vec4(final, 1.0);
}