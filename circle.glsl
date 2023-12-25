#include "utils.glsl"

vec4 circle(vec3 pos, vec2 uv, float radius, vec4 color){
    vec4 ret = vec4(1.0);
    float mask = 1.0-smoothstep(radius-2e-2, radius, distance(pos.xy, uv));
    ret = mix(vec4(0.0), color, mask);
    return ret;
}

vec4 circles(vec3 pos,vec2 uv, int bands, float thickness, vec4 col1, vec4 col2){
    vec4 color = vec4(0.0);
    float ph = 1.68*hash2_1(pos.xy);
    for (int i=bands; i > 0; i--){
        vec4 coli;
        if(i%2==0){
            coli = col1;
        }
        else{
            coli = col2;
        }
        float time = iGlobalTime * (1.0 + hash2_1(pos.yx) * 2.0) + ph;
        ph += 5.2*float(i);
        vec3 tr = vec3(sin(time), cos(time), 0)*thickness*0.1;
        vec4 circi = circle(pos+tr, uv, float(i)*thickness, coli);
        color = mix(color, circi, circi.a);
    }
    return color;
}

// #define circle_main main
// void circle_main(){
//     float time = iGlobalTime * 1.0;
//     vec2 uv = (gl_FragCoord.xy / iResolution.xx - 0.5) * 8.0;
//     float r = sin(uv.x - time) * 0.5 + 0.5;
//     float b = sin(uv.y + time) * 0.5 + 0.5;
//     float g = sin((uv.x + uv.y + sin(time * 0.5)) * 0.5) * 0.5 + 0.5;
//     gl_FragColor = vec4(r, g, b, 1.0);

//     vec4 cir = circles(vec3(0.0, 0.0, 1.0), uv, 11, 0.2, vec4(0.975, 0.237, 0.362, 1.0),vec4(0.084, 0.5341, 0.8258, 1.0));

//     gl_FragColor = mix(gl_FragColor, cir, cir.a);
// }
