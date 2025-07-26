float hash(float i) { // in float, out float — effective range of 420k
    i = fract(i * 20.5043) + 1.23;
    i = fract(i * 23.403);
    return i;
}

float hash(vec2 i) { // in vec2, out float — effective range of 10k^2
    float r;
    r = fract(i.x * 20.1234 + 1.) * 10.403 + 1.; //Add in pseudo random lines along the x axis
    r += fract(i.y * 13.503) * 8.4023; //addin pseudo random lines along the y axis
    r *= fract(length((i + 10.) + r + pow(r, 2.))) + 10.; //break it up with a 'salted' uv;
    r = fract(r);
    return r;
}

float hash(vec3 i) { // in vec3, out float — effective range of 50k^2 * (needs testing)
    float r = hash(i.xy) * 12.6023 + 1.; //add a base 'salt' hash
    r += fract(i.z + i.y * 12.504) * 12.5043; //add a z based x hash
    r += fract(i.z + i.x * 14.203) * 11.9950; //add a z based y hash
    r += fract(length(i.xy * 20.3423)) * i.z; //add an extra hash to break up any (obvious) patterns
    r = fract(r);
    return r;
}

float hash(vec4 i) { // in vec3, out float — effective range of 400k^2 * (needs testing)^2
    float r = hash(i.zxy) * 12.504 + 1.43; //add a base 'salt' hash
    r += fract(i.w + length(i.zy) * 12.150) * 11.8504; //add a w based zy hash
    r += fract(i.w + length(i.xz) * 12.026) * 12.9542; //add a w based xz hash
    r += fract(hash(i.yxz) * 12.504) * i.w; //add a repetition breaker
    r = fract(r);
    return r;
}

vec2 hash2(float i) { // in float, out vec2 — effective range of 300k
    vec2 r;
    r.x = fract(i * 12.2304) + 0.42; //make a hash for x
    r.y = fract(i * 14.203) - 2.04; //make a hash for y
    r *= fract(i * 12.402) - .2; //make a repetition breaker
    r = fract(r);
    return r;
}

vec2 hash2(vec2 i) { // in vec2, out vec2 — effective range of 10k^2
    vec2 r;
    r.x = hash(i.xy) - .2; //add salt to x
    r.y = hash(i.yx) + .8231; //add salt to y
    r += fract(r * 12.504 + i); //add a repetition breaker
    r = fract(r);
    return r;
}

vec2 hash2(vec3 i) { // in vec3, out vec2 — effective range of 100k^2 * (needs testing)
    vec2 r;
    r.x = hash(i.xyz) + .13; //add salt to x
    r.y = hash(i.zxy) + 1023.124123; //add salt to y
    r += hash(i.z) * (hash(i.xzy) + hash(i.zyx)); //add a repetition breaker
    r += hash2(i.xy);
    r = fract(r);
    return r;
}

vec2 hash2(vec4 i) { // in vec4, out vec2 — effective range of 500k^2 * (needs testing)^2
    vec2 r;
    r.x = hash(i.xyzw + hash(i.zw)) + 1.231;
    r.y = hash(i.zxwy) + .901823;
    r += hash2(i.xyz);
    r = fract(r);
    return r;
}

vec3 hash3(float i) { // in float, out vec2 — effective range of 700k
    vec3 r;
    r.x = fract(i * 13.0412) + .53;
    r.y = fract(i * 12.2403) + .25;
    r.z = fract(i * 15.4023) - .82;
    r *= fract(i * 11.2340) + .3 * sign(i);
    r = fract(r);
    return r;
}

vec3 hash3(vec2 i) { // in vec2, out vec3 — effective range of 10k^2
    vec3 r;
    r.x = hash(i.xy); //salt x
    r.y = hash(i.yx); //salt y
    r.z = hash(i.xx) + hash(i.y); //salt z
    r += vec3(hash2(i), hash(length(i - 2.))); //add a repetition breaker
    r = fract(r);
    return r;
}

vec3 hash3(vec3 i) { // in vec3, out vec3 — effective range of 100k^2 * (needs testing)
    vec3 r;
    r.x = hash(i); //seed x
    r.y = hash(i.yxz); //seed y
    r.z = hash(i.xyz + vec3(i.xy, 0.)); //seed z
    r += hash3(i.xy * .1) + hash3(i.z); //add a repetition breaker
    r = fract(r);
    return r;
}

vec3 hash3(vec4 i) { // in vec4, out vec3 — effective range of 500k^2 * (needs testing)^2
    vec3 r;
    r.xy = hash2(i + hash(i.xyz)); //hash xy
    r.z += hash(i); //hash z
    r.xyz += hash3(i.xyz); //hash all three
    r = fract(r);
    return r;
}