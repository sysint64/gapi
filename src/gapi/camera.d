module gapi.camera;

import gl3n.linalg;

struct Camera {
    vec2 viewportSize;
    mat4 viewMatrix;
    mat4 projectionMatrix;
    mat4 modelMatrix;
    mat4 MVPMatrix;
}

struct OthroCameraTransform {
    vec2 position;
    float zoom;
}

void updateOrthoMatrices(ref Camera camera, in OthroCameraTransform transform) {
    const vec3 eye = vec3(transform.position, 1.0f);
    const vec3 target = vec3(transform.position, 0.0f);
    const vec3 up = vec3(0.0f, 1.0f, 0.0f);

    camera.viewMatrix = mat4.look_at(eye, target, up);
    camera.projectionMatrix = mat4.orthographic(
        0.0f, camera.viewportSize.x,
        0.0f, camera.viewportSize.y,
        0.0f, 10.0f
    );

    if (transform.zoom > 1.0f) {
        camera.modelMatrix = mat4.scaling(transform.zoom, transform.zoom, 1.0f);
    } else {
        camera.modelMatrix = mat4.identity;
    }

    camera.MVPMatrix = camera.projectionMatrix * camera.modelMatrix * camera.viewMatrix;
}
