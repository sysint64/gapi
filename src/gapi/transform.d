module gapi.transform;

import gl3n.linalg;

struct Transform2D {
    vec2 position;
    vec2 scaling;
    float rotation = 0.0f;
}

mat4 create2DModelMatrix(in Transform2D transform) {
    const translateMatrix = mat4.translation(vec3(transform.position, 0.0f));
    const rotateMatrix = mat4.rotation(transform.rotation, 0.0f, 0.0f, 1.0f);
    const scaleMatrix = mat4.scaling(transform.scaling.x, transform.scaling.y, 0.0f);

    return translateMatrix * rotateMatrix * scaleMatrix;
}

mat4 create2DModelMatrixPosition(in vec2 position) {
    const translateMatrix = mat4.translation(vec3(position, 0.0f));
    return translateMatrix;
}
