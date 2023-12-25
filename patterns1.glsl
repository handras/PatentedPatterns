#include "circle.glsl"
#include "square.glsl"

const vec4 c1 = vec4(0.0, 0.50, 0.1, 1.0);
const vec4 c2 = vec4(0.9765, 0.9492187, 0.13671875, 1.0);
const vec4 c3 = vec4(0.6523, 0.9375, 0.039, 1.0);
const vec4 c4 = vec4(0.23, 0.285, 0.975, 1.0);
const vec4 c5 = vec4(73.0/256.0, 230.0/256.0, 46.0/256.0, 1.0);
const vec4 c6 = vec4(0.84, 0.12, 0.585, 1.0);


void main(){
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xx - 0.5) * 8.0;
    float r = sin(uv.x - time) * 0.5 + 0.5;
    float b = sin(uv.y + time) * 0.5 + 0.5;
    float g = sin((uv.x + uv.y + sin(time * 0.5)) * 0.5) * 0.5 + 0.5;
    gl_FragColor = vec4(r, g, b, 1.0);

    vec4 cir1 = circles(vec3(0.75, 1.5, 1.0), uv, 5, 0.27, c1, c2);
    gl_FragColor = mix(gl_FragColor, cir1, cir1.a);

    vec4 sq1 = squares(vec3(-1.05, 2.365, 1.0), uv, 6, .35, c5, c6);
    gl_FragColor = mix(gl_FragColor, sq1, sq1.a);

    vec4 cir2 = circles(vec3(-0.51, 0.15, 1.0), uv, 4, 0.36, c3, c4);
    gl_FragColor = mix(gl_FragColor, cir2, cir2.a);

}