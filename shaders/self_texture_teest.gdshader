shader_type canvas_item;

void fragment() {
    float alpha = texture(TEXTURE, UV).r;
    COLOR = vec4(vec3(1.0), alpha);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
