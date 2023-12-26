#include "utils.glsl"

float area(vec2 a, vec2 b, vec2 c){
    return a.x*(b.y-c.y) + b.x*(c.y-a.y) + c.x*(a.y-b.y);
}

vec4 triangle(vec3 pos, vec2 uv, float radius, vec3 angles, vec4 color){
    vec4 ret = vec4(1.0);
    vec2 a = vec2(cos(angles.x), sin(angles.x)) * radius + pos.xy;
    vec2 b = vec2(cos(angles.y), sin(angles.y)) * radius + pos.xy;
    vec2 c = vec2(cos(angles.z), sin(angles.z)) * radius + pos.xy;
    float area = area(a,b,c);
    float s = b.x*c.y - c.x*b.y + (b.y-c.y)*uv.x + (c.x-b.x)*uv.y;
    float t = c.x*a.y - a.x*c.y + (c.y-a.y)*uv.x + (a.x-c.x)*uv.y;
    s=s/(area);
    t=t/(area);
    float v=1.-s-t;
    s = smoothstep(0., 0.0001, s);
    t = smoothstep(0., 0.0001, t);
    v = smoothstep(0., 0.0001, v);

    float d = distance(pos.xy, uv);
    color *= 1.-smoothstep(radius, radius+1e-1, d) + smoothstep(radius-1e-2, radius, d);

    float mask = 1.-color.a;
    mask += smoothstep(0., 0.0001, s*t*v);
    ret = mix(vec4(0.0), color, mask);

    return ret;
}

vec4 triangles(vec3 pos, vec2 uv, int bands, float thickness, vec3 angles, vec4 col1, vec4 col2){
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
        vec3 tr = vec3(sin(time), cos(time), 0)*thickness*0.0;
        vec4 trii = triangle(pos+tr, uv, float(i)*thickness, angles, coli);
        color = mix(color, trii, trii.a);
    }
    return color;
}

#define triangle_main main
void triangle_main(){
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xx - 0.5) * 8.0;
    float r = sin(uv.x - time) * 0.5 + 0.5;
    float b = sin(uv.y + time) * 0.5 + 0.5;
    float g = sin((uv.x + uv.y + sin(time * 0.5)) * 0.5) * 0.5 + 0.5;
    gl_FragColor = vec4(r, g, b, 1.0);

    #define angles vec3(0.*PI/180., 180.*PI/180., 210.*PI/180.)

    vec4 tri = triangles(vec3(0.0, 0.0, 1.0), uv, 3, 0.8, angles, vec4(0.975, 0.237, 0.362, 1.0),vec4(0.084, 0.5341, 0.8258, 1.0));

    gl_FragColor = mix(gl_FragColor, tri, tri.a);
}
