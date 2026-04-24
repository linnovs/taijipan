#version 450

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(binding = 1) uniform sampler2D sourceImg;
layout(binding = 2) uniform sampler2D destImg;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;

    float progress;
    float maxRadius;

    float origImgWidth;
    float origImgHeight;
    float destImgWidth;
    float destImgHeight;

    float screenWidth;
    float screenHeight;
    vec2 aspectRatio;

    float origIsSolid;
    vec4 solid;
};

vec2 scaleUVWithCrop(vec2 uv, float imgW, float imgH) {
    float scale = max(screenWidth / imgW, screenHeight / imgH);
    vec2 scaledSize = vec2(imgW, imgH) * scale;
    vec2 offset = (scaledSize - vec2(screenWidth, screenHeight)) / scaledSize;
    vec2 scaledUV = uv * (vec2(1.) - offset) + offset * .5;

    return scaledUV;
}

float rippleOffset(float adjustment, vec2 direction) {
    float t = progress + mix(0., adjustment, float(progress));
    float d = length(direction / aspectRatio) - t * maxRadius; // SDF of circle
    d *= 1. - smoothstep(0., 0.1, abs(d)); // limit the offset to a narrow band around the circle
    d *= smoothstep(0., 0.1, t); // fade in

    return d;
}

vec4 sampleWithRipple(sampler2D source, vec2 uv, vec2 direction) {
    float tAdjustment = 0.05 * sin(progress * 3.14);
    float rD = rippleOffset(tAdjustment, direction);
    float gD = rippleOffset(0., direction);
    float bD = rippleOffset(-tAdjustment, direction);

    direction = normalize(direction);

    float r = texture(source, uv + direction * rD).r;
    float g = texture(source, uv + direction * gD).g;
    float b = texture(source, uv + direction * bD).b;

    float shading = gD * 3.;

    vec4 color = vec4(r, g, b, 1.);
    color.rgb += shading;

    return color;
}

float offsetFactor(vec2 direction) {
    float d = length(direction / aspectRatio) - progress * maxRadius;
    d = smoothstep(0., -0.1, d);

    return d;
}

void main() {
    vec2 uv = qt_TexCoord0;

    vec2 center = vec2(0.5);
    vec2 direction = uv - center;

    vec2 scaleUV1 = scaleUVWithCrop(uv, origImgWidth, origImgHeight);
    vec2 scaleUV2 = scaleUVWithCrop(uv, destImgWidth, destImgHeight);

    vec4 color1 = sampleWithRipple(sourceImg, scaleUV1, direction);
    vec4 color2 = sampleWithRipple(destImg, scaleUV2, direction);

    color1 = mix(color1, solid, step(0.5, origIsSolid));

    fragColor = mix(color1, color2, offsetFactor(direction));
}
