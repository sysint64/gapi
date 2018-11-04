import std.stdio;
import std.container;
import std.file;
import std.path;

import derelict.opengl.gl;

import derelict.sfml2.system;
import derelict.sfml2.window;
import derelict.sfml2.graphics;

import gapi.geometry;
import gapi.camera;
import gapi.shader;
import gapi.shader_uniform;
import gapi.opengl;
import gapi.transform;
import gapi.texture;
import gapi.font;

import gl3n.linalg;

struct WindowData {
    sfWindow* window;
    sfWindowHandle windowHandle;
    int viewportWidth = 1024;
    int viewportHeight = 768;
}

struct Geometry {
    Array!uint indices;
    Array!vec2 vertices;
    Array!vec2 texCoords;

    Buffer indicesBuffer;
    Buffer verticesBuffer;
    Buffer texCoordsBuffer;

    VAO vao;
}

enum VaoAttrLocation {
    in_Position = 0,
    in_TextCoords = 1,
    in_Colors = 2,
}

WindowData windowData;
Geometry sprite;
Transform2D spriteTransform;
mat4 spriteModelMatrix;
mat4 spriteMVPMatrix;
Texture2D spriteTexture;
Font dejavuFont;

ShaderProgram transformShader;
CameraMatrices cameraMatrices;
OthroCameraTransform cameraTransform = OthroCameraTransform(
    vec2(1024, 768),
    vec2(0, 0),
    1f
);

void main() {
    DerelictSFML2System.load();
    DerelictSFML2Window.load();
    DerelictSFML2Graphics.load();

    DerelictGL3.load();

    run();
}

void run() {
    initSFML();
    initGL();
    onCreate();
    mainLoop();
    onDestroy();
}

void onCreate() {
    createSprite();
    createShaders();
    createTexture();
    createFont();
}

void createSprite() {
    sprite.indices.insert([0, 3, 1, 2]);
    sprite.vertices.insert(
        [
            vec2(-0.5f, -0.5f),
            vec2( 0.5f, -0.5f),
            vec2( 0.5f,  0.5f),
            vec2(-0.5f,  0.5f)
        ]
    );

    sprite.texCoords.insert(
        [
            vec2(0.0f, 1.0f),
            vec2(1.0f, 1.0f),
            vec2(1.0f, 0.0f),
            vec2(0.0f, 0.0f),
        ]
    );

    sprite.indicesBuffer = createIndicesBuffer(sprite.indices);
    sprite.verticesBuffer = createVector2fBuffer(sprite.vertices);
    sprite.texCoordsBuffer = createVector2fBuffer(sprite.texCoords);

    sprite.vao = createVAO();

    bindVAO(sprite.vao);
    createVector2fVAO(sprite.verticesBuffer, VaoAttrLocation.in_Position);
    createVector2fVAO(sprite.texCoordsBuffer, VaoAttrLocation.in_TextCoords);
}

void createShaders() {
    const vertexSource = readText(buildPath("res", "transform_vertex.glsl"));
    const vertexShader = createShader("transform vertex shader", ShaderType.vertex, vertexSource);

    const fragmentSource = readText(buildPath("res", "texture_fragment.glsl"));
    const fragmentShader = createShader("transform fragment shader", ShaderType.fragment, fragmentSource);

    transformShader = createShaderProgram("transform program", [vertexShader, fragmentShader]);
}

void createTexture() {
    const Texture2DParameters params = {
        minFilter: true,
        magFilter: true
    };
    spriteTexture = createTexture2DFromFile(buildPath("res", "test.jpg"), params);
}

void createFont() {
    dejavuFont = createFontFromFile(buildPath("res", "DejaVuSans.ttf"));

    const Texture2DParameters params = {
        minFilter: true,
        magFilter: true
    };
    getFontGlyphsTexture(dejavuFont, 12, params);
}

void onDestroy() {
    deleteBuffer(sprite.indicesBuffer);
    deleteBuffer(sprite.verticesBuffer);
    deleteBuffer(sprite.texCoordsBuffer);
    deleteShaderProgram(transformShader);
    deleteTexture2D(spriteTexture);
    deleteFont(dejavuFont);
}

void onResize(in uint width, in uint height) {
    cameraTransform.viewportSize = vec2(width, height);
    windowData.viewportWidth = width;
    windowData.viewportHeight = height;
    writeln(cameraTransform);
}

void onProgress() {
    spriteTransform.position = vec2(
        cameraTransform.viewportSize.x / 2,
        cameraTransform.viewportSize.y / 2
    );
    spriteTransform.scaling = vec2(430.0f, 600.0f);
    spriteTransform.rotation += 0.01f;

    spriteModelMatrix = create2DModelMatrix(spriteTransform);
    cameraMatrices = createOrthoCameraMatrices(cameraTransform);

    spriteMVPMatrix = cameraMatrices.mvpMatrix * spriteModelMatrix;
}

void onRender() {
    bindShaderProgram(transformShader);
    setShaderProgramUniformMatrix(transformShader, "MVP", spriteMVPMatrix);
    setShaderProgramUniformTexture(transformShader, "texture", spriteTexture, 0);

    bindVAO(sprite.vao);
    bindIndices(sprite.indicesBuffer);
    renderIndexedGeometry(cast(uint) sprite.indices.length, GL_TRIANGLE_STRIP);
}

void mainLoop() {
    sfWindow_setActive(windowData.window, true);
    bool running = true;

    while (running) {
        sfEvent event;

        while (sfWindow_pollEvent(windowData.window, &event)) {
            if (event.type == sfEvtClosed) {
                running = false;
            } else {
                handleEvents(event);
            }
        }

        glViewport(0, 0, windowData.viewportWidth, windowData.viewportHeight);
        glClear(GL_COLOR_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

        onProgress();
        onRender();

        glFlush();
        sfWindow_display(windowData.window);
    }
}

void initSFML() {
    sfContextSettings settings;

    with (settings) {
        depthBits = 24;
        stencilBits = 8;
        antialiasingLevel = 0;
        majorVersion = 4;
        minorVersion = 3;
    }

    sfVideoMode videoMode = {windowData.viewportWidth, windowData.viewportHeight, 24};

    const(char)* title = "Simulator";

    windowData.window = sfWindow_create(videoMode, title, sfDefaultStyle, &settings);
    windowData.windowHandle = sfWindow_getSystemHandle(windowData.window);

    sfWindow_setVerticalSyncEnabled(windowData.window, true);
    sfWindow_setFramerateLimit(windowData.window, 60);

    DerelictGL3.reload();
}

void initGL() {
    glDisable(GL_CULL_FACE);
    glDisable(GL_MULTISAMPLE);
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glClearColor(150.0f/255.0f, 150.0f/255.0f, 150.0f/255.0f, 0);
}

void handleEvents(in sfEvent event) {
    switch (event.type) {
        case sfEvtResized:
            onResize(event.size.width, event.size.height);
            break;

        default:
            break;
    }
}
