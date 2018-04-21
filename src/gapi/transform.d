module gapi.transform;

import gl3n.linalg;

struct OrthoTransform {
    vec2 position;
    vec2 scaling;
    float rotation;
    mat4 modelMatrix;
}

void update2DMatrices(ref OrthoTransform transform) {
    const translateMatrix = mat4.translation(vec3(transform.position, 0.0f));
    const rotateMatrix = mat4.rotation(transform.rotation, 0.0f, 0.0f, 1.0f);
    const scaleMatrix = mat4.scaling(transform.scaling.x, transform.scaling.y, 0.0f);

    transform.modelMatrix = translateMatrix * rotateMatrix * scaleMatrix;
}
