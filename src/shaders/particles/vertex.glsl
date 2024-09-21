uniform vec2 uResolution;
uniform sampler2D uPictureTexture;
uniform sampler2D uDisplacementTexture;
attribute float aIntensity;
attribute float aAngle;

varying vec3 vColor;

void main()
{ 
    // Displacement
    vec3 newPosition = position;
    float DisplacementIntensity = texture(uDisplacementTexture, uv).r;

    vec3 displacement = vec3(
       cos(aAngle),
        sin(aAngle),
        1.0
    );

    displacement *= DisplacementIntensity;
    displacement *= 3.0;
    displacement *= aIntensity;
    
    newPosition += displacement;

    // Final position
    vec4 modelPosition = modelMatrix * vec4(newPosition, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;

    // Picture
    float pictureIntensity = texture(uPictureTexture, uv).r;

    // Point size
    gl_PointSize = 0.15 * pictureIntensity * uResolution.y;
    gl_PointSize *= (1.0 / - viewPosition.z);

    // Varyings
    vColor = vec3(pow(pictureIntensity, 2.0));
}