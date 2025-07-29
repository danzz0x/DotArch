uniform sampler2D tex;
uniform float opacity;
uniform float time;

const float saturation = 2.7; // Aumenta la saturación aquí (1.0 = normal, 1.5 = +50%)

void main() {
    vec4 color = texture2D(tex, gl_TexCoord[0].xy);
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114)); // Luminancia
    vec3 saturated = mix(vec3(gray), color.rgb, saturation);
    gl_FragColor = vec4(saturated, color.a) * opacity;
}
