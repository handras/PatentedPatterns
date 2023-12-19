
const float PI = 3.141562;

float hash2_1(vec2 s){
    return fract(sin(dot(s, vec2(12.9898, 4.1614))) * 43758.5453);;
}

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
