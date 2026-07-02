shader_type canvas_item;

uniform vec2 pixel_size: vec2 = vec2(3.0, 3.0);
uniform sampler2D palette : hint_albedo;
uniform float scanline_strength: float = 0.08;
uniform float vignette_strength: float = 0.35;

void fragment() {
    // Pixelate
    vec2 screen = vec2(textureSize(SCREEN_TEXTURE, 0));
    vec2 px = pixel_size;
    vec2 coord = floor(UV * screen / px) * px / screen;
    vec4 c = texture(SCREEN_TEXTURE, coord);

    // Simple palette remap by luminance lookup on palette texture if provided
    vec3 col = c.rgb;
    float lum = dot(col, vec3(0.299, 0.587, 0.114));
    vec4 pal = texture(palette, vec2(lum, 0.5));
    vec3 remapped = mix(col, pal.rgb, 0.6);

    // Scanlines
    float scan = sin((UV.y * screen.y) * 1.5) * 0.5 + 0.5;
    remapped = mix(remapped, remapped * (1.0 - scanline_strength), scan);

    // Vignette
    vec2 center = UV - vec2(0.5);
    float dist = length(center);
    remapped *= mix(1.0, 1.0 - vignette_strength, smoothstep(0.4, 0.9, dist));

    COLOR = vec4(remapped, c.a);
}
