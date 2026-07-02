shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float glow_size : hint_range(1.0, 20.0) = 8.0;
uniform float glow_strength : hint_range(0.0, 5.0) = 1.5;
uniform float threshold : hint_range(0.0, 2.0) = 0.8;

void fragment() {
    vec3 original = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;

    vec2 px = SCREEN_PIXEL_SIZE * glow_size;

    vec3 blur = vec3(0.0);
    float weight_sum = 0.0;

    for (int x = -4; x <= 4; x++) {
        for (int y = -4; y <= 4; y++) {
            vec2 offset = vec2(float(x), float(y));

            float weight = exp(-dot(offset, offset) / 8.0);

            vec3 sample_col =
                texture(SCREEN_TEXTURE, SCREEN_UV + offset * px / 4.0).rgb;

            sample_col = max(sample_col - threshold, 0.0);

            blur += sample_col * weight;
            weight_sum += weight;
        }
    }

    blur /= weight_sum;

    COLOR.rgb = original + blur * glow_strength;
    COLOR.a = 1.0;
}