shader_type canvas_item;

uniform vec2 tile_size = vec2(30.0, 30.0);

uniform vec4 color_a : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color_b : source_color = vec4(0.0, 1.0, 0.0, 1.0);

varying vec2 world_pos;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
    vec2 tile_coord = floor((world_pos + tile_size * 0.5) / tile_size);

    float r = hash(tile_coord);

    vec4 blended_color = mix(color_a, color_b, r);

    float mask_alpha = texture(TEXTURE, UV).a;

    COLOR = vec4(
        blended_color.rgb,
        blended_color.a * mask_alpha
    );
}