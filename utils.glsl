
#ifndef PI
#define PI 3.141562;

float hash2_1(vec2 s){
    return fract(sin(dot(s, vec2(12.9898, 4.1614))) * 43758.5453);;
}
#endif