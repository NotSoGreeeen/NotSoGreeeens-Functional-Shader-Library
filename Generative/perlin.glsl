#include "hash.glsl"

vec2 corners[4] = vec2[4] (
    vec2(0, 0),
    vec2(1, 0),
    vec2(0, 1),
    vec2(1, 1)
);


//TODO: fix zeroing problem at center, make more random.
float perlin(in vec2 uv) {
    //calculate 4 unit-length gradients (one for each corner of a cell)
    vec2 grad[4] = vec2[4] (
        hash2(floor(uv) + corners[0]),
        hash2(floor(uv) + corners[1]),
        hash2(floor(uv) + corners[2]),
        hash2(floor(uv) + corners[3])
    );
    //calculate distance to point from each corner
    vec2 len[4];
    for (int i = 0; i < 4; i++) {
        len[i] = fract(uv) - corners[i];
    }
    //dot product the gradient and offset vector
    float dots[4];
    for (int i = 0; i < 4; i++) {
        dots[i] = dot(grad[i], len[i]);
    }

    //make uv into an easing function
    uv = fract(uv);
    uv = 6. * pow(uv, vec2(5.)) - 15. * pow(uv, vec2(4.)) + 10. * pow(uv, vec2(3.));

    //ease along the x axis
    float u = mix(dots[0], dots[1], uv.x);
    float v = mix(dots[2], dots[3], uv.x);

    //ease along the y axis
    float w = mix(u, v, uv.y);

    //return absolute w.
    return abs(w);
}

void main() {
    vec2 uv = (2. * gl_FragCoord.xy - iResolution.xy) / max(iResolution.x, iResolution.y);

    uv += 10.;
    
    float p;
    float frequency = 1.;
    float amplitude = 128.;
    float maxValue;
    for (int i = 0; i < 8; i++) {
        p += perlin(uv * frequency) * amplitude;

        maxValue += amplitude;
        amplitude *= .8;
        frequency *= 2.;
    }

    p /= maxValue;


    gl_FragColor = vec4(vec3(p), 1.);
}