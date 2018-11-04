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
import gapi.opengl;

import gl3n.linalg;

struct WindowData {
    sfWindow* window;
    sfWindowHandle windowHandle;
    const int viewportWidth = 1024;
    const int viewportHeight = 768;
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

WindowData windowData;
Geometry sprite;
ShaderProgram transformShader;

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
    createVector2fVAO(sprite.verticesBuffer);
    createVector2fVAO(sprite.texCoordsBuffer);
}

void createShaders() {
    const vertexSource = readText(buildPath("res", "transform_vertex.glsl"));
    const vertexShader = createShader("transform vertex shader", ShaderType.vertex, vertexSource);

    const fragmentSource = readText(buildPath("res", "transform_fragment.glsl"));
    const fragmentShader = createShader("transform fragment shader", ShaderType.fragment, fragmentSource);

    transformShader = createShaderProgram("transform program", [vertexShader, fragmentShader]);

    memoizeShaderLocation(transformShader, "MVP");
    memoizeShaderLocation(transformShader, "texture");
}

void onDestroy() {
    deleteBuffer(sprite.indicesBuffer);
    deleteBuffer(sprite.verticesBuffer);
    deleteBuffer(sprite.texCoordsBuffer);
    deleteShaderProgram(transformShader);
}

void onProgress() {
}

void onRender() {
}

void mainLoop() {
    sfWindow_setActive(windowData.window, true);
    bool running = true;

    while (running) {
        sfEvent event;

        while (sfWindow_pollEvent(windowData.window, &event)) {
            if (event.type == sfEvtClosed) {
                running = false;
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
