#include "utils.glsl"

vec4 square(vec3 pos, vec2 uv, float sidelen, vec4 color){
    vec4 ret = vec4(1.0);
    vec2 v = abs(pos.xy-uv);
    float a = 0.0*PI;
    float s = sin(a);
    float c = cos(a);
    mat2 m = mat2(c, s, -s, c);
    v = m*v;
    sidelen = sidelen/2.0;
    float x = 1.0-smoothstep(sidelen-2e-2, sidelen, v.x);
    float y = 1.0-smoothstep(sidelen-2e-2, sidelen, v.y);
    float mask = x*y;
    ret = mix(vec4(.0), color, mask);
    return ret;
}

vec4 squares(vec3 pos, vec2 uv, int bands, float thickness, vec4 col1, vec4 col2){
    vec4 color = vec4(0.0);
    vec2 v = abs(pos.xy-uv);
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
        ph += 3.2*float(i);
        vec3 tr = vec3(sin(time), .5*cos(time), 0)*thickness*0.075;
        vec4 sqi = square(pos+tr, uv, float(i)*thickness, coli);
        color = mix(color, sqi, sqi.a);
    }
    return color;
}

// #define square_main main
// void square_main(){
//     float time = iGlobalTime * 1.0;
//     vec2 uv = (gl_FragCoord.xy / iResolution.xx - 0.5) * 8.0;
//     float r = sin(uv.x - time) * 0.5 + 0.5;
//     float b = sin(uv.y + time) * 0.5 + 0.5;
//     float g = sin((uv.x + uv.y + sin(time * 0.5)) * 0.5) * 0.5 + 0.5;
//     gl_FragColor = vec4(r, g, b, 1.0);

//     vec4 sq = squares(vec3(0.0, 0.0, 1.0), uv, 11, 0.4, vec4(0.975, 0.237, 0.362, 1.0),vec4(0.084, 0.5341, 0.8258, 1.0));

//     gl_FragColor = mix(gl_FragColor, sq, sq.a);
// }
