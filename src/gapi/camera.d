module gapi.camera;

import gl3n.linalg;

struct CameraMatrices {
    mat4 viewMatrix;
    mat4 projectionMatrix;
    mat4 modelMatrix;
    mat4 mvpMatrix;
}

struct OthroCameraTransform {
    vec2 viewportSize;
    vec2 position;
    float zoom;
}

CameraMatrices createOrthoCameraMatrices(in OthroCameraTransform transform) {
    CameraMatrices cameraMatrices;

    const vec3 eye = vec3(transform.position, 1.0f);
    const vec3 target = vec3(transform.position, 0.0f);
    const vec3 up = vec3(0.0f, 1.0f, 0.0f);

    cameraMatrices.viewMatrix = mat4.look_at(eye, target, up);
    cameraMatrices.projectionMatrix = mat4.orthographic(
        0.0f, transform.viewportSize.x,
        0.0f, transform.viewportSize.y,
        0.0f, 10.0f
    );

    if (transform.zoom > 1.0f) {
        cameraMatrices.modelMatrix = mat4.scaling(transform.zoom, transform.zoom, 1.0f);
    } else {
        cameraMatrices.modelMatrix = mat4.identity;
    }

    cameraMatrices.mvpMatrix =
        cameraMatrices.projectionMatrix *
        cameraMatrices.modelMatrix *
        cameraMatrices.viewMatrix;

    return cameraMatrices;
}
